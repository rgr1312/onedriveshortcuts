function New-OneDriveShortcut {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [Parameter(ParameterSetName = 'UserPrincipalName')]
        [Parameter(ParameterSetName = 'UserObjectId')]
        [string] $Uri,

        [Parameter(Mandatory = $true)]
        [Parameter(ParameterSetName = 'UserPrincipalName')]
        [Parameter(ParameterSetName = 'UserObjectId')]
        [string] $DocumentLibrary,

        [Parameter(Mandatory = $false)]
        [Parameter(ParameterSetName = 'UserPrincipalName')]
        [Parameter(ParameterSetName = 'UserObjectId')]
        [string] $ShortcutName

        [Parameter(Mandatory = $true)]
        [Parameter(ParameterSetName = 'UserPrincipalName')]
        [string] $UserPrincipalName,

        [Parameter(Mandatory = $true)]
        [Parameter(ParameterSetName = 'UserObjectId')]
        [string] $UserObjectId
    )

    begin {

    }

    process {

    }

    end {
        
    }
}