<#
.SYNOPSIS
  Connects to Azure and vertically scales the VM

.DESCRIPTION
  This runbook connects to Azure and scales up the VM 

  REQUIRED AUTOMATION ASSETS
  1. An Automation variable asset called "AzureSubscriptionId" that contains the GUID for this Azure subscription of the VM.  
  2. An Automation credential asset called "AzureCredential" that contains the Azure AD user credential with authorization for this subscription. 

.PARAMETER WebhookData
   Required 
   This is the data that is sent in the webhook that is triggered from the VM alert rules

.NOTES
   AUTHOR: Azure Compute Team 
   LASTEDIT: March 27, 2016
#>

param (
	[parameter(Mandatory = $true)]
    [object]$WebhookData
)

if ($WebhookData -ne $null) {  
	# Returns strings with status messages
	[OutputType([String])]
	
	# Collect properties of WebhookData.
	$WebhookBody    =   $WebhookData.RequestBody
    $WebhookBody = $WebhookBody.Replace("\""","""");
	Write-Output $WebhookBody
	# Obtain the WebhookBody containing the AlertContext
    $WebhookBody = (ConvertFrom-Json -InputObject $WebhookBody)
	
	if ($WebhookBody.data.status -eq "Activated") {
		# Obtain the AlertContext
		$AlertContext = [object]$WebhookBody.data.context
		
		$ResourceGroupName = $AlertContext.resourceGroupName
		$VmName = $AlertContext.resourceName
		Write-Output $VmName
        
		$noResize = "noresize"
		
		$scaleUp = @{
			"Standard_A0"      = "Standard_A1"
		    "Standard_A1"      = "Standard_A2"
		    "Standard_A2"      = "Standard_A3"
		    "Standard_A3"      = "Standard_A4"
		    "Standard_A4"      = $noResize
		    "Standard_A5"      = "Standard_A6"
		    "Standard_A6"      = "Standard_A7"
		    "Standard_A7"      = $noResize
		    "Standard_A8"      = "Standard_A9"
		    "Standard_A9"      = $noResize
		    "Standard_A10"     = "Standard_A11"
		    "Standard_A11"     = $noResize
		    "Basic_A0"         = "Basic_A1"
		    "Basic_A1"         = "Basic_A2"
		    "Basic_A2"         = "Basic_A3"
		    "Basic_A3"         = "Basic_A4"
			"Basic_A4"         = $noResize
			"Standard_A1_v2"   = "Standard_A2_v2"
			"Standard_A2_v2"   = "Standard_A4_v2"
			"Standard_A4_v2"   = "Standard_A8_v2"
			"Standard_A8_v2"   = $noResize
			"Standard_A2m_v2"  = "Standard_A4m_v2"
			"Standard_A4m_v2"  = "Standard_A8m_v2"
			"Standard_A8m_v2"  = $noResize
		    "Standard_D1_v2"   = "Standard_D2_v2"
		    "Standard_D2_v2"   = "Standard_D3_v2"
		    "Standard_D3_v2"   = "Standard_D4_v2"
		    "Standard_D4_v2"   = "Standard_D5_v2"
			"Standard_D5_v2"   = $noResize
			"Standard_DS1_v2"  = "Standard_DS2_v2"
		    "Standard_DS2_v2"  = "Standard_DS3_v2"
		    "Standard_DS3_v2"  = "Standard_DS4_v2"
		    "Standard_DS4_v2"  = "Standard_DS5_v2"
		    "Standard_DS5_v2"  = $noResize
		    "Standard_D11_v2"  = "Standard_D12_v2"
		    "Standard_D12_v2"  = "Standard_D13_v2"
		    "Standard_D13_v2"  = "Standard_D14_v2"
			"Standard_D14_v2"  = "Standard_D15_v2"
			"Standard_D15_v2"  = $noResize
			"Standard_DS11_v2" = "Standard_DS12_v2"
		    "Standard_DS12_v2" = "Standard_DS13_v2"
		    "Standard_DS13_v2" = "Standard_DS14_v2"
      		"Standard_DS14_v2" = "Standard_DS15_v2"
			"Standard_DS15_v2" = $noResize
		    "Standard_DS1"     = "Standard_DS2"
		    "Standard_DS2"     = "Standard_DS3"
		    "Standard_DS3"     = "Standard_DS4"
		    "Standard_DS4"     = $noResize
		    "Standard_DS11"    = "Standard_DS12"
		    "Standard_DS12"    = "Standard_DS13"
		    "Standard_DS13"    = "Standard_DS14"
		    "Standard_DS14"    = $noResize
		    "Standard_D1"      = "Standard_D2" 
		    "Standard_D2"      = "Standard_D3"
		    "Standard_D3"      = "Standard_D4"
		    "Standard_D4"      = $noResize
		    "Standard_D11"     = "Standard_D12"
		    "Standard_D12"     = "Standard_D13"
		    "Standard_D13"     = "Standard_D14"
		    "Standard_D14"     = $noResize
		    "Standard_G1"      = "Standard_G2" 
		    "Standard_G2"      = "Standard_G3"
		    "Standard_G3"      = "Standard_G4" 
		    "Standard_G4"      = "Standard_G5"  
		    "Standard_G5"      = $noResize
		    "Standard_GS1"     = "Standard_GS2" 
		    "Standard_GS2"     = "Standard_GS3"
		    "Standard_GS3"     = "Standard_GS4"
		    "Standard_GS4"     = "Standard_GS5"
			"Standard_GS5"     = $noResize
			"Standard_D2_v3"   = "Standard_D4_v3"
			"Standard_D4_v3"   = "Standard_D8_v3"
			"Standard_D8_v3"   = "Standard_D16_v3"
			"Standard_D16_v3"  = "Standard_D32_v3"
			"Standard_D32_v3"  = "Standard_D64_v3"
			"Standard_D64_v3"  = $noResize
			"Standard_D2s_v3"  = "Standard_D4s_v3"
			"Standard_D4s_v3"  = "Standard_D8s_v3"
			"Standard_D8s_v3"  = "Standard_D16s_v3"
			"Standard_D16s_v3" = "Standard_D32s_v3"
			"Standard_D32s_v3" = "Standard_D64s_v3"
			"Standard_D64s_v3" = $noResize
			"Standard_E2_v3"   = "Standard_E4_v3"
			"Standard_E4_v3"   = "Standard_E8_v3"
			"Standard_E8_v3"   = "Standard_E16_v3"
			"Standard_E16_v3"  = "Standard_E32_v3"
			"Standard_E32_v3"  = "Standard_E64_v3"
			"Standard_E64_v3"  = $noResize
			"Standard_E2s_v3"  = "Standard_E4s_v3"
			"Standard_E4s_v3"  = "Standard_E8s_v3"
			"Standard_E8s_v3"  = "Standard_E16s_v3"
			"Standard_E16s_v3" = "Standard_E32s_v3"
			"Standard_E32s_v3" = "Standard_E64s_v3"
     		"Standard_E64s_v3" = $noResize
			"Standard_F1"  	   = "Standard_F2"
			"Standard_F2"      = "Standard_F4"
			"Standard_F4"      = "Standard_F8"
			"Standard_F8"      = "Standard_F16"
			"Standard_F16"     = $noResize
			"Standard_F1s"	   = "Standard_F2s"
			"Standard_F2s"     = "Standard_F4s"
			"Standard_F4s"     = "Standard_F8s"
			"Standard_F8s"     = "Standard_F16s"
			"Standard_F16s"    = $noResize
			"Standard_F2s_v2"  = "Standard_F4s_v2"
			"Standard_F4s_v2"  = "Standard_F8s_v2"
			"Standard_F8s_v2"  = "Standard_F16s_v2"
      		"Standard_F16s_v2" = "Standard_F32s_v2"
      		"Standard_F32s_v2" = "Standard_F64s_v2"
      		"Standard_F64s_v2" = "Standard_F72s_v2"
      		"Standard_F72s_v2" = $noResize
			"Standard_L4s"     = "Standard_L8s"
			"Standard_L8s"	   = "Standard_L16s"
			"Standard_L16s"    = "Standard_L32s"
			"Standard_L32s"    = $noResize
			"Standard_NV6"	   = "Standard_NV12"
			"Standard_NV12"    = "Standard_NV24"
			"Standard_NV24"    = $noResize
			"Standard_NC6"     = "Standard_NC12"
			"Standard_NC12"    = "Standard_NC24"
			"Standard_NC24"    = $noResize
			"Standard_H8"      = "Standard_H16"
			"Standard_H16"     = $noResize
			"Standard_H8m"     = "Standard_H16m"
			"Standard_H16m"    = $noResize
		}
		
		# Get Azure Run As Connection Name
		$connectionName = "AzureRunAsConnection"
		# Get the Service Principal connection details for the Connection name
		$servicePrincipalConnection = Get-AutomationConnection -Name $connectionName         
		# Logging in to Azure AD with Service Principal
		"Logging in to Azure AD..."
		Add-AzureRmAccount -ServicePrincipal -TenantId $servicePrincipalConnection.TenantId `
					    -ApplicationId $servicePrincipalConnection.ApplicationId `
					    -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint
		
		try {
		    $vm = Get-AzureRmVm -ResourceGroupName $ResourceGroupName -VMName $VmName -ErrorAction Stop
		} catch {
		    Write-Error "Virtual Machine not found"
		    exit
		}
		$currentVMSize = $vm.HardwareProfile.vmSize
		
		Write-Output "`nFound the specified Virtual Machine: $VmName"
		Write-Output "Current size: $currentVMSize"
		
		$newVMSize = ""
		
		$newVMSize = $scaleUp[$currentVMSize]
		
		if($newVMSize -eq $noResize) {
		    Write-Output "Sorry the current Virtual Machine size $currentVMSize can't be scaled $scaleAction. You'll need to recreate the specified Virtual Machine with your requested size"
		} else {
		    Write-Output "`nNew size will be: $newVMSize"
				
			$vm.HardwareProfile.VmSize = $newVMSize
		    Update-AzureRmVm -VM $vm -ResourceGroupName $ResourceGroupName
			
		    $updatedVm = Get-AzureRmVm -ResourceGroupName $ResourceGroupName -VMName $VmName
		    $updatedVMSize = $updatedVm.HardwareProfile.vmSize
			
		    Write-Output "`nSize updated to: $updatedVMSize"	
		}
	} else {
		Write-Output "`nAlert not activated"
		exit
	}
}
else 
{
    Write-Error "This runbook is meant to only be started from a webhook." 
}
