$token = & 'C:\Users\chris\StitchMCP\google-cloud-sdk\bin\gcloud.cmd' auth application-default print-access-token

$body = @{
    jsonrpc = "2.0"
    method = "initialize"
    params = @{
        protocolVersion = "2024-11-05"
        capabilities = @{}
        clientInfo = @{
            name = "test"
            version = "1.0"
        }
    }
    id = 1
} | ConvertTo-Json -Depth 10 -Compress

Write-Host "Sending request to Stitch MCP..."
Write-Host "Body: $body"

$response = curl.exe -s -X POST 'https://stitch.googleapis.com/mcp' `
    -H "Authorization: Bearer $token" `
    -H 'X-Goog-User-Project: stitch-mcp-chris-001' `
    -H 'Content-Type: application/json' `
    -d $body

Write-Host "Response:"
Write-Host $response
