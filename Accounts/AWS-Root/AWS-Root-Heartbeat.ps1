$email="afalahi@live.com"
$loginUrl = "https://console.aws.amazon.com"
#initiate internet explorer object
$ie = New-Object -ComObject "internetexplorer.application"
$ie.visible = $true
$ie.navigate2($loginUrl)
$document=$ie.Document
while ($ie.Busy -eq $true) { Start-Sleep -Seconds 1; }
if($ie.LocationURL -like "*awsemail*")
{
    $document=$ie.Document
    ($document.GetElementById("aws-login-switchaccount-link")).click();
}
while ($ie.Busy -eq $true) { Start-Sleep -Seconds 1; }
$document=$ie.Document
#get the first  form fields that are relevant to sign in
$fields= $document.GetElementsByTagName("input")
#pass the values to the form fields
$fields[0].value=$email
($document.getElementsByTagName("button") | where {$_.innerText -eq "Next"}).click();
Start-Sleep -Seconds 2; 
($document.GetElementById("ap_password")| select -First 1).value="mo%/J2xCL*}TMGj3";
#Sign In
($document.GetElementById("signInSubmit-input")).click();
while ($ie.Busy -eq $true) { Start-Sleep -Seconds 2; }
($document.GetElementById("aws-console-logout")).click();
while ($ie.Busy -eq $true) { Start-Sleep -Seconds 2; }
$ie.Quit();
