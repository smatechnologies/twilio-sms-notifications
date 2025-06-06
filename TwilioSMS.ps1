# PowerShell script to send SMS using Twilio API

Param(
    [Parameter(Mandatory=$true)]
    [string]$TwilioAccountSid,
    [Parameter(Mandatory=$true)]
    [string]$TwilioAuthToken,
    [Parameter(Mandatory=$true)]
    [string]$TwilioFromNumber,
    [Parameter(Mandatory=$true)]
    [string]$toNumber, #This can be a single number, or multiple in a comma separated list.
    [Parameter(Mandatory=$true)]
    [string]$SMSMessageBody, #The SMS Body message will be trimmed to 160 character max.
    [Parameter(Mandatory=$true)]
    [string]$TwilioURL
)

#############It is the responsibility of the client to make sure that all federal regulations in regards to Application to Person (A2P) SMS messaging are met.###############

# Create a credential object for HTTP basic auth
$secureString = $TwilioAuthToken | ConvertTo-SecureString -asPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($TwilioAccountSid, $secureString)

#Check if the $SMSMessageBody is greater than 160 characters. If it is, then trim it down to 160.
If($SMSMessageBody.Length -gt 160){
    $SMSMessageBody = $SMSMessageBody.Substring(0, 159).Trim()
}

#Split out Comma Separated toNumbers into an Array (if there are multiple)
$toNumbersArray = $toNumber -split ","

Foreach($number in $toNumbersArray){
    #Trim any white spaces in the array
    $number = $number.Trim()

    #Build the Params object to pass to the API.
    $params = @{ To = $number ; From = $TwilioFromNumber ; Body = $SMSMessageBody }

    # Send the SMS
    try {
        #Call the Twilio REST API to send the Text Message
        $response = Invoke-WebRequest $TwilioURL -Method Post -Credential $credential -Body $params -UseBasicParsing -ContentType "application/json"

        #Read the status code in the response from the API, and if it's 201, then output a successful message to the console/log. 
        if($response.StatusCode -eq 201){
            Write-Host "Message successfully sent to TWilio for $number"
        }Else{Write-Error "Failed to send message to Twilio for $number"}

    } catch {
          Write-Error "Failed to send message: $_"
          exit 1
}
  
}