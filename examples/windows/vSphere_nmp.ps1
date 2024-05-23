$ErrorActionPreference = "SilentlyContinue"
$WarningPreference = "Continue"

#region Top of Script

#requires -version 4
#requires -Module VMware.VimAutomation.Core

<#
.SYNOPSIS
	Queries vSphere Server Hosts for Native Multipating datastores
.DESCRIPTION
    This script gets a list of vSphere hosts, then gets the NMP datastores.
.NOTES
	Version:		1.0
	Author:			Peter Nguyen
	Creation Date:	22-May-2024
	Purpose/Change:	Initial script development
#>

#endregion Top of Script

#####-----------------------------------------------------------------------------------------#####

#region Script Parameters

Param
	(
		
        [ Parameter( Mandatory = $true ) ] [ string ] $vSphereServerName,
        [ Parameter( Mandatory = $true ) ] [ string ] $vSphereUsername,
        [ Parameter( Mandatory = $true ) ] [ string ] $vSpherePassword

	)

#endregion Script Parameters

#####-----------------------------------------------------------------------------------------#####

#region Execution

# Import the VMware module
Import-Module VMware.VimAutomation.Core | out-null

# Connect to vSphere Server
Connect-VIServer -Server $vSphereServerName -User $vSphereUsername -Password $vSpherePassword | out-null

# Initialize an empty array to store the results
$paths = @()

# Loop through each VM host
Get-VMHost | ForEach-Object {
    # Get the name of the current VM host
    $vmHostName = $_.Name
    
    # Get the storage paths for the current VM host
    $storagePaths = (Get-EsxCli -VMHost $_).Storage.Nmp.Path.List()

    # Loop through each storage path
    foreach ($path in $storagePaths) {
        # Add the path information to the array
        $paths += @{
            VMServerName = $vSphereServerName
            VMHostName = $vmHostName
            ArrayPriority = $path.ArrayPriority
            Device = $path.Device
            DeviceDisplayName = $path.DeviceDisplayName
            GroupState = $path.GroupState
            Path = $path.Path
            PathSelectionPolicyPathConfig = $path.PathSelectionPolicyPathConfig
            RuntimeName = $path.RuntimeName
            StorageArrayTypePathConfig = $path.StorageArrayTypePathConfig
        }
    }
}

# Convert the array to JSON and save it to a file
$paths | ConvertTo-Json

#endregion Execution