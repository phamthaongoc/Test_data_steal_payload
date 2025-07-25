# Tạo file văn bản
$content = "Have a nice day"
$filePath = "$env:TEMP\message.txt"
Set-Content -Path $filePath -Value $content

# Thiết lập URL API Telegram
$apiUrl = "https://api.telegram.org/bot8392772771:AAFgffIbtVeD4xBpg0rzlGSfPsbW0GG-a0o/sendDocument"

# Thêm chat_id (ID người nhận – BẮT BUỘC)
# Bạn cần thay số này bằng ID chat thật (ví dụ: 123456789)
$chat_id = "7398435102"

# Gửi tài liệu
Invoke-RestMethod -Uri $apiUrl -Method Post -Form @{
    chat_id    = $chat_id
    document   = Get-Item $filePath
}
# Caps Lock signal
$keyBoardObject = New-Object -ComObject WScript.Shell
for ($i=0; $i -lt 4; $i++) {
    $keyBoardObject.SendKeys("{CAPSLOCK}")
    Start-Sleep -Seconds 1
}

exit
