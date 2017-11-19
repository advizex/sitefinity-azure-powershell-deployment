# Creates new azure resource group with website template
# The AzureResourceManager module requires Add-AzureAccount
function NewAzureResourceGroup
{
    Param(
        [Parameter(Mandatory=$true)]
        $ResourceGroupName,
        [Parameter(Mandatory=$true)]
        $AzureAccount,
        [Parameter(Mandatory=$true)]
        $AzureAccountPassword,
        $ResourceGroupLocation = "East US",
        $TemplateFile = "$PSScriptRoot\Templates\Default.json",
        $TemplateParameterFile = "$PSScriptRoot\Templates\Default.params.json"
    )

    #NOTE:
    #The AzureResourceManager module requires Add-AzureAccount. A Publish Settings file is not sufficient.
    $secpassword = ConvertTo-SecureString $AzureAccountPassword -AsPlainText -Force
    $credentials = New-Object System.Management.Automation.PSCredential ($AzureAccount, $secpassword)
    Add-AzureRmAccount -Credential $credentials

    Select-AzureRMSubscription -SubscriptionName $config.azure.subscription
    
    #Creating new AzureResourceGroup
    Write-Host "Creating '$ResourceGroupName' Azure Resource group..."


    New-AzureRmResourceGroup -Name $ResourceGroupName `
                       -Location $ResourceGroupLocation `
                       -Force -Verbose


    Write-Host "'$ResourceGroupName' Azure Resource group has been successfully created."                          

    New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName `
                        -TemplateFile $TemplateFile `
                        -TemplateParameterFile $TemplateParameterFile `
                        -Force -Verbose
    
    Write-Host "'$ResourceGroupName' Azure Resource group has been successfully created."
}
