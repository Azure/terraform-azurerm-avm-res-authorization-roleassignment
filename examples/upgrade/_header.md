# Upgrade example

This example tests upgrading from v0.3.1 of the module, which used the AzureRM provider, to this version, which uses AzAPI.

Before the E2E run, `pre.ps1` deploys this configuration with v0.3.1 into the example's state file. The E2E run then applies this version over that state. The `moved` blocks convert the existing role assignments to AzAPI, and the idempotency check confirms nothing is replaced.

The role assignments cover the `role_assignments_azure_resource_manager` input and the resource group, subscription, and management group scopes. The principal is the identity running Terraform, so the example needs no Microsoft Graph write permissions.

To run the upgrade locally, set `AVM_UPGRADE_FIXTURE` to `true`. Otherwise `pre.ps1` skips the v0.3.1 deployment.
