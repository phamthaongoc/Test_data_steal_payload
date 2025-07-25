# Path to sample file
$basePath = "C:\Users\Public\Documents\SampleScript"
New-Item -ItemType Directory -Path $basePath -Force | Out-Null

# Create text message
"Have a nice day" | Set-Content -Path "$basePath\message.txt"

# Zip the file
$zipPath = "$basePath\message.zip"
Compress-Archive -Path "$basePath\message.txt" -DestinationPath $zipPath -Force

# Send to Telegram
$token = "8392772771:AAFgffIbtVeD4xBpg0rzlGSfPsbW0GG-a0o"
$chatID = "<7398435102>"
$uri = "https://api.telegram.org/bot$token/sendDocument"
$caption = "Have a nice day from PowerShell!"

# Prepare HTTP request
$client = New-Object System.Net.Http.HttpClient
$content = New-Object System.Net.Http.MultipartFormDataContent
$content.Add((New-Object System.Net.Http.StringContent($chatID)), "chat_id")
$content.Add((New-Object System.Net.Http.StringContent($caption)), "caption")

# Attach file
$fileStream = [System.IO.File]::OpenRead($zipPath)
$fileContent = New-Object System.Net.Http.StreamContent($fileStream)
$fileContent.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::Parse("application/zip")
$content.Add($fileContent, "document", "message.zip")

# Send
$client.PostAsync($uri, $content).Wait()

# Cleanup
$fileStream.Close()
$fileStream.Dispose()
# Caps Lock signal
$keyBoardObject = New-Object -ComObject WScript.Shell
for ($i=0; $i -lt 4; $i++) {
    $keyBoardObject.SendKeys("{CAPSLOCK}")
    Start-Sleep -Seconds 1
}

