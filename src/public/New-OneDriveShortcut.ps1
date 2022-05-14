function New-OneDriveShortcut {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'UserPrincipalName')]
        [Parameter(Mandatory = $true, ParameterSetName = 'UserObjectId')]
        [string] $Uri,

        [Parameter(Mandatory = $true, ParameterSetName = 'UserPrincipalName')]
        [Parameter(Mandatory = $true, ParameterSetName = 'UserObjectId')]
        [string] $DocumentLibraryName,

        [Parameter(Mandatory = $false, ParameterSetName = 'UserPrincipalName')]
        [Parameter(Mandatory = $false, ParameterSetName = 'UserObjectId')]
        [string] $FolderPath,

        [Parameter(Mandatory = $false, ParameterSetName = 'UserPrincipalName')]
        [Parameter(Mandatory = $false, ParameterSetName = 'UserObjectId')]
        [string] $ShortcutName,

        [Parameter(Mandatory = $true, ParameterSetName = 'UserPrincipalName')]
        [string] $UserPrincipalName,

        [Parameter(Mandatory = $true, ParameterSetName = 'UserObjectId')]
        [string] $UserObjectId
    )

    begin {

    }

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'UserPrincipalName' {
                $User = $UserPrincipalName
            }
            'UserObjectId' {
                $User = $UserObjectId
            }
        }
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

        $ItemUniqueId = 'root'

        if ($FolderPath) {
            $ItemUniqueIdUri = "$($Uri)/$($DocumentLibraryName)/$($FolderPath)"
            $ItemUniqueIdUri = $ItemUniqueUri.replace('%', '%25')
            $ItemUniqueIdRequest = @{
                Resource = "sites/$($SiteIdRaw)/lists/$($DocumentLibraryId)/items?$expand=fields&$filter=contains(webUrl,'$($ItemUniqueIdUri)')"
                Method = [Microsoft.PowerShell.Commands.WebRequestMethod]::Get
            }

            $ItemUniqueIdResponse = Invoke-ODSApiRequest @$ItemUniqueIdRequest
            $ItemUniqueId = $ItemUniqueIdResponse.value[0].id
        }

        if (!($ShortcutName)) {
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
                        listItemUniqueId = $ItemUniqueId
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