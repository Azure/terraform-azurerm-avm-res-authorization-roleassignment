locals {
  # Both keys resolve to the test identity, through different lookups. Never give them the same role at the same scope.
  app_registrations = {
    app_registration1 = "app_registration1"
    app_registration2 = "app_registration2"
  }
  system_assigned_managed_identities = {
    sami1 = "sami1"
    sami2 = "sami2"
    sami3 = "sami3"
    sami4 = "sami4"
    sami5 = "sami5"
    sami6 = "sami6"
  }
  user_assigned_managed_identities = {
    uami1 = "uami1"
    uami2 = "uami2"
    uami3 = "uami3"
    uami4 = "uami4"
    uami5 = "uami5"
    uami6 = "uami6"
    uami7 = "uami7"
  }
}
