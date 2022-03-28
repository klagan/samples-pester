# https://github.com/fluffy-cakes/pester_lz
# https://pester.dev/
# https://www.terraform.io/internals/json-format
# https://markwarneke.me/2019-08-23-Azure-DevOps-Test-Dashboard/
# https://devblogs.microsoft.com/scripting/unit-testing-powershell-code-with-pester/

function Confirm-StorageAccount {
                        [CmdletBinding()]
                        param (
                            [Parameter(Mandatory=$true)] $infra
                        )
      $storageAcc = $infra | Where-Object { 
          ($_.name -eq 'ikitsolutions2') -and ($_.type -eq 'Microsoft.Storage/storageAccounts') 
        }

      It "storage account is provisioned" {
          $storageAcc.location          | Should -Be 'uksouth'
          $storageAcc.provisioningState | Should -Be "Succeeded"
      }
}

$infra = az resource list --resource-group ikit-development --output json | ConvertFrom-Json

Confirm-StorageAccount -infra $infra
