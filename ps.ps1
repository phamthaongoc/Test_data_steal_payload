$token = "8392772771:AAFgffIbtVeD4xBpg0rzlGSfPsbW0GG-a0o"
$chatID = "7398435102"
$zipPath = "C:\Users\Public\Documents\SampleScript\message.zip"

$uri = "https://api.telegram.org/bot$token/sendDocument"

$form = @{
    chat_id = $chatID
    caption = "Have a nice day from PowerShell!"
    document = Get-Item $zipPath
}

$response = Invoke-RestMethod -Uri $uri -Method Post -Form $form

$response | ConvertTo-Json
