$dllPath="C:\Program Files (x86)\Microsoft.NET\Primary Interop Assemblies\Microsoft.mshtml.dll"
try
    {
        $checkDll=Get-Item -Path $dllPath -ErrorAction SilentlyContinue
        if($checkDll.Exists)
            {
                Add-Type -Path $dllPath
            }
        else
            {
                throw "Could not load Microsoft.mshtml.dll please make sure that it exist in C:\Program Files (x86)\Microsoft.NET\Primary Interop Assemblies\"
            }
     }
catch
    {
        throw "Error: " + $Error[0].Exception.Message
    }

$email=""
$password=""
$loginUrl ="https://signin.aws.amazon.com/signin?client_id=arn%3Aaws%3Aiam%3A%3A015428540659%3Auser%2Fhomepage&redirect_uri=https%3A%2F%2Fconsole.aws.amazon.com%2Fconsole%2Fhome%3Fstate%3DhashArgs%2523%26isauthcode%3Dtrue&page=resolve"
#initiate internet explorer object
$ie = New-Object -ComObject "internetexplorer.application"
$ie.visible = $true
$ie.navigate2($loginUrl)
try
    {
        while ($ie.Busy -eq $true) { Start-Sleep -Seconds 2; }
        $document=$ie.Document
        #get the first  form fields that are relevant to sign in
        $document.GetElementById("resolving_input").value=$email
        #pass the values to the form fields
        ($document.getElementsByTagName("button") | where {$_.innerText -eq "Next"}).click();
        Start-Sleep -Seconds 5;
        #enter password
        ($document.GetElementById("ap_password")| select -First 1).value=$password;
        #Sign In
        ($document.GetElementById("signInSubmit-input")).click();
        while ($ie.Busy -eq $true) { Start-Sleep -Seconds 2; }
        if($ie.LocationName -ne "AWS Management Console")
            {
                throw "Error heartbeating account"
            }
        else
            {
                ($document.GetElementById("aws-console-logout")).click();
                return $true
            }
    }
catch
    {

        throw 'Error "{0}"' -f $_

    }
finally
    {
        while ($ie.Busy -eq $true) { Start-Sleep -Seconds 2; }
        $ie.Quit();
    }
