function Get-OneDriveShortcut {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'UserPrincipalName')]
        [Parameter(Mandatory = $true, ParameterSetName = 'UserObjectId')]
        [string] $ShortcutName,

        [Parameter(Mandatory = $true, ParameterSetName = 'UserPrincipalName')]
        [string] $UserPrincipalName,

        [Parameter(Mandatory = $true, ParameterSetName = 'UserObjectId')]
        [string] $UserObjectId
    )

    begin {

    }

    process {
        $User = $null

        switch ($PsCmdlet.ParameterSetName) {
            "UserPrincipalName" {
                $User = $UserPrincipalName
            }
            "UserObjectId" {
                $User = $UserObjectId
            }
        }

        $Request = @{
            Resource = "drives/$($User)/root:/$([uri]::EscapeDataString($ShortcutName))"
            Method = [Microsoft.PowerShell.Commands.WebRequestMethod]::Get
        }

        return (Invoke-ODSApiRequest @Request)
    }

    end {
        
    }
}