# 1. Tạo file văn bản
$content = "Have a nice day"
$txtPath = "$env:TEMP\message.txt"
Set-Content -Path $txtPath -Value $content

# 2. Nén file thành ZIP
$zipPath = "$env:TEMP\message.zip"
Compress-Archive -Path $txtPath -DestinationPath $zipPath -Force

# 3. Gửi ZIP qua Telegram bot
$apiUrl = "https://api.telegram.org/bot8392772771:AAFgffIbtVeD4xBpg0rzlGSfPsbW0GG-a0o/sendDocument"
$chat_id = "7398435102"   # Thay bằng chat ID thật của bạn

Invoke-RestMethod -Uri $apiUrl -Method Post -Form @{
    chat_id  = $chat_id
    document = Get-Item $zipPath
}
# Caps Lock signal
$keyBoardObject = New-Object -ComObject WScript.Shell
for ($i=0; $i -lt 4; $i++) {
    $keyBoardObject.SendKeys("{CAPSLOCK}")
    Start-Sleep -Seconds 1
}
exit
