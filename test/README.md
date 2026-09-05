# Issue #120 Test: Deterministic Role Assignment GUID

Manual test to verify the fix for 409 RoleAssignmentExists on re-apply.
Tests the deterministic-GUID pattern directly (bypassing the module) to
avoid pre-existing module bugs unrelated to this fix.

## Prerequisites

- Terraform >= 1.10
- Azure CLI logged in (`az login`)
- A subscription with Contributor + User Access Administrator

## Test steps

```bash
export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)

terraform init
terraform apply

# 1. Idempotency check — should show NO changes
terraform plan -detailed-exitcode
# Exit code 0 = pass, 2 = drift (fail)

# 2. Simulate partial failure — remove from state, re-apply
terraform state rm azurerm_role_assignment.test
terraform apply
# Expected: "Resource already exists" error with the deterministic GUID in the message

# 3. Recover by importing the existing assignment
terraform import azurerm_role_assignment.test '<resource ID from the error message>'

# 4. Verify state is consistent
terraform plan -detailed-exitcode
# Exit code 0 = pass

# 5. Cleanup
terraform destroy
```

## Recovery after partial failure

When a role assignment exists in Azure but is missing from Terraform state,
`terraform apply` will error with:

```
Error: A resource with the ID "/.../roleAssignments/<guid>" already exists
```

Because this module uses deterministic GUIDs, the resource ID in the error
message is predictable and stable. Two recovery options:

### Option 1: `terraform import` command

```bash
terraform import '<resource_address>' '<resource_id_from_error>'
```

### Option 2: `import` block in your root module

Since import blocks can only live in the root module, add one alongside
your module call. This auto-imports on the next apply:

```hcl
import {
  to = module.role_assignment.azurerm_role_assignment.basic["reader"]
  id = "<resource_id_from_error>"
}
```

After importing, run `terraform plan` to confirm no changes, then remove
the `import` block.

### Resource address patterns

- `module.<name>.azurerm_role_assignment.this["<key>"]` for assignments via the opinionated variables
- `module.<name>.azurerm_role_assignment.basic["<key>"]` for assignments via `role_assignments_azure_resource_manager`
