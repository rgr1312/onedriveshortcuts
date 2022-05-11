function Connect-ODS {
    [CmdletBinding(DefaultParameterSetName = 'ClientSecret')]
    param(
        [Parameter(Mandatory = $true)]
        [Parameter(ParameterSetName = 'ClientSecret')]
        [Parameter(ParameterSetName = 'ClientCertificate')]
        [string] $TenantId,
    
        [Parameter(Mandatory = $true)]
        [Parameter(ParameterSetName = 'ClientSecret')]
        [Parameter(ParameterSetName = 'ClientCertificate')]
        [string] $ClientId,
    
        [Parameter(Mandatory = $true)]
        [Parameter(ParameterSetName = 'ClientSecret')]
        [securestring] $ClientSecret

        [Parameter(Mandatory = $true)]
        [Parameter(ParameterSetName = 'ClientCertificate')]
        [System.Security.Cryptography.X509Certificates.X509Certificate2] $ClientCertificate
    )

    begin {
        
    }

    process {
        switch ($PsCmdlet.ParameterSetName) {
            'ClientSecret' {
                try {
                    $Token = Get-MsalToken -ClientId $ClientId -TenantId $TenantId -ClientSecret $ClientSecret
                    $PsCmdlet.SessionState.PSVariable.Set('_ODSToken', $Token)
                } catch {
                    Write-Error "Token request using ClientSecret failed: $($_)" -ErrorAction Stop
                }
            }
            'ClientCertificate' {
                try {
                    $Token = Get-MsalToken -ClientId $ClientId -TenantId $TenantId -ClientCertificate $ClientCertificate
                    $PsCmdlet.SessionState.PSVariable.Set('_ODSToken', $Token)
                } catch {
                    Write-Error "Token request using ClientCertificate failed: $($_)" -ErrorAction Stop
                }
            }
        }
    }

    end {

    }
}