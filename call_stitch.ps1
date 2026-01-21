# Get access token
$tokenOutput = & 'C:\Users\chris\StitchMCP\google-cloud-sdk\bin\gcloud.cmd' auth print-access-token 2>&1
$token = ($tokenOutput | Where-Object { $_ -match '^ya29\.' }) -join ''

if (-not $token) {
    Write-Host "Failed to get access token. Output was:"
    Write-Host $tokenOutput
    exit 1
}

Write-Host "Got token: $($token.Substring(0, 20))..."

# Read the request body from file
$bodyFile = $args[0]
if (-not $bodyFile) {
    $bodyFile = "C:\Users\chris\StitchMCP\stitch_create_project.json"
}

Write-Host "Using body file: $bodyFile"

# Make the request
$response = curl.exe -s -X POST 'https://stitch.googleapis.com/mcp' `
    -H "Authorization: Bearer $token" `
    -H 'X-Goog-User-Project: stitch-mcp-chris-001' `
    -H 'Content-Type: application/json' `
    -d "@$bodyFile"

Write-Host "Response:"
Write-Host $response
