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
        [string] $DocumentLibraryName,

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
        $SiteDomain = ([uri]$Uri).Authority
        $SiteResource = ([uri]$Uri).AbsolutePath

        $SiteRequest = @{
            Resource = "$($SiteDomain):$($SiteResource)"
            Method = [Microsoft.PowerShell.Commands.WebRequestMethod]::Get
        }

        $SiteResponse = Invoke-ODSApiRequest @SiteRequest
        $SiteIdRaw = $SiteResponse.id
        $SiteIdSplit = $SiteIdRaw.split(",")
        $SiteId = $SiteIdSplit[1]
        $WebId = $SiteIdSplit[2]

        $DocumentLibraryRequest = @{
            Resource = "sites/$($SiteIdRaw)/lists?`$filter=startsWith(displayName,'$($DocumentLibraryName)')"
            Method = [Microsoft.PowerShell.Commands.WebRequestMethod]::Get
        }

        $DocumentLibraryResponse = Invoke-ODSApiRequest @DocumentLibraryRequest
        $DocumentLibraryId = $DocumentLibraryResponse.value[0].id

        if (!$ShortcutName) {
            $ShortcutName = $DocumentLibraryName
        }

        $ShortcutRequest = @{
            Resource = "drives/$($User)/root/children"
            Method = [Microsoft.PowerShell.Commands.WebRequestMethod]::Post
            Body = @{
                name = $ShortcutName
                remoteItem = @{
                    sharepointIds = @{
                        listId = $DocumentLibraryId
                        listItemUniqueId = "root"
                        siteId = $SiteId
                        siteUrl = $Uri
                        webId = $WebId
                    }
                }
                'microsoft.graph.conflictBehavior' = "rename"
            }
        }

        return (Invoke-ODSApiRequest @ShortcutRequest)
    }

    end {
        
    }
}