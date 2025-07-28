$botToken = "8392772771:AAFgffIbtVeD4xBpg0rzlGSfPsbW0GG-a0o"
$chatID = "7398435102"
$message = "Have a nice day"

$uri = "https://api.telegram.org/bot$botToken/sendMessage?chat_id=$chatID&text=$message"



# Caps Lock signal
$keyBoardObject = New-Object -ComObject WScript.Shell
for ($i=0; $i -lt 4; $i++) {
    $keyBoardObject.SendKeys("{CAPSLOCK}")
    Start-Sleep -Seconds 1
}

Invoke-RestMethod -Uri $uri -Method Get
