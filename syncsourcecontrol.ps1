param
(
)

$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "jason "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

    "Logging in to Azure..."
    Add-AzureRmAccount `
       -ServicePrincipal `
       -TenantId $servicePrincipalConnection.TenantId `
       -ApplicationId $servicePrincipalConnection.ApplicationId `
       -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
}
catch {
   if (!$servicePrincipalConnection)
   {
      $ErrorMessage = "Connection $connectionName not found."
      throw $ErrorMessage
  } else{
      Write-Error -Message $_.Exception
      throw $_.Exception
  }
}

 Get-AzureRmAutomationWebhook -RunbookName "Process-SourceControlWebhook" -ResourceGroup "Default-SQL-WestUS" -AutomationAccountName "myfirsttest"