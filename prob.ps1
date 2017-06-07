Start-Process -NoNewWindow powershell.exe -argument "-command Start-Sleep -m 250; Remove-Item $env:temp\ews.dll -Force"
exit