function Set-RemoteUNCLoadSettings {
    [CmdletBinding()]
    param(
        # Provide the File server path or an FQDN path e.g. \\fileserver.contoso.com\PSModuleShare
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$FileServerFQDN
    )
    $registryValue = "file"

    foreach ($zoneMapKey in @("ZoneMap\Domains", "ZoneMap\EscDomains"))
    {
        $path = Join-Path -Path (Join-Path -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -ChildPath $zoneMapKey) -ChildPath $FileServerFQDN
        if (-not (Test-Path -Path $path))
        {
            Write-Verbose -Message ("Creating key: {0}" -f $path)
            New-Item -Path $path -Force -ItemType Registry
        }

        if (-not (Get-ItemProperty -Path $path -Name $registryValue -ErrorAction SilentlyContinue))
        {
            Write-Verbose -Message ("Setting value '$registryValue'")
            New-ItemProperty -Path $path -Name $registryValue -Value 1 -Type DWORD | Out-Null
            Write-Warning -Message 'PowerShell requires a restart to reflect the changes.'
        }
    }
}