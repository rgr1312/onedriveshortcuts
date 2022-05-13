function Invoke-ODSApiRequest {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string] $Resource,

        [Parameter(Mandatory = $true)]
        [Microsoft.PowerShell.Commands.WebRequestMethod] $Method,

        [Parameter(Mandatory = $false)]
        [string] $Body
    )

    begin {
        $Token = $PsCmdlet.SessionState.PSVariable.GetValue('_ODSToken')

        if ((!$Token.ExpiresOn) -or 
        (!$Token.AccessToken) -or
        ($Token.ExpiresOn -le (Get-Date))) {
            Write-Error "Please run Connect-ODS first."
        }
    }

    process {
        $Request = @{
            Uri = "https://graph.microsoft.com/beta/$($Resource)"
            ContentType = "application/json"
            Headers = @{
                Authorization = "Bearer $($Token.AccessToken)"
                Prefer = "apiversion=2.1"
            }
            Method = $Method
        }

        if ($Body) {
            Request.Body = $Body
        }

        $Response = $null

        try {
            $Response = Invoke-WebRequest @Request
            $Response = ConvertFrom-Json $([string]::new($Response.Content))
        } catch {
            Write-Error "Error querying Microsoft Graph: $($_)"
        }

        return $Response
    }

    end {
        
    }
}