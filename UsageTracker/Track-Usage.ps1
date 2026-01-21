Add-Type @"
  using System;
  using System.Runtime.InteropServices;
  using System.Text;

  public class Win32 {
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();

    [DllImport("user32.dll")]
    public static extern int GetWindowText(IntPtr hWnd, StringBuilder text, int count);

    [DllImport("user32.dll")]
    public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);
  }
"@

$usage = @{}
$intervalSeconds = 1
$saveInterval = 10 # Save every 10 iterations
$outputFile = Join-Path $PSScriptRoot "usage_report.csv"

Write-Host "Tracking active window usage... Press Ctrl+C to stop."
Write-Host "Data will be saved to $outputFile"

$iteration = 0

try {
    while ($true) {
        $hwnd = [Win32]::GetForegroundWindow()
        if ($hwnd -ne [IntPtr]::Zero) {
            $pidOut = 0
            [Win32]::GetWindowThreadProcessId($hwnd, [ref]$pidOut) | Out-Null
            
            try {
                $process = Get-Process -Id $pidOut -ErrorAction Stop
                $processName = $process.ProcessName
                
                $sb = New-Object System.Text.StringBuilder 256
                [Win32]::GetWindowText($hwnd, $sb, 256) | Out-Null
                $windowTitle = $sb.ToString()

                # Logic to determine if it's a specific site or app
                # If browser, include Title. If generic app, just ProcessName.
                $isBrowser = $processName -match "chrome|msedge|firefox|opera|brave"
                
                if ($isBrowser) {
                     # Clean up title for browsers to get "Site Name" roughly
                     # E.g. "GitHub - My Repo - Google Chrome" -> "GitHub - My Repo"
                     # This is a heuristic.
                     $key = "$processName : $windowTitle"
                } else {
                    $key = $processName
                }

                if (-not $usage.ContainsKey($key)) {
                    $usage[$key] = 0
                }
                $usage[$key] += $intervalSeconds
                
                # Simple progress indicator
                Write-Host "." -NoNewline
            } catch {
                # Process access error handling
            }
        }

        Start-Sleep -Seconds $intervalSeconds
        $iteration++

        if ($iteration % $saveInterval -eq 0) {
            $results = $usage.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 20 | Select-Object @{N='Program/Site';E={$_.Key}}, @{N='Seconds';E={$_.Value}}
            $results | Export-Csv -Path $outputFile -NoTypeInformation
        }
    }
} finally {
    Write-Host "`nStopping..."
    $results = $usage.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 20 | Select-Object @{N='Program/Site';E={$_.Key}}, @{N='Seconds';E={$_.Value}}
    
    Write-Host "`nTop 20 Usage:"
    $results | Format-Table -AutoSize
    
    $results | Export-Csv -Path $outputFile -NoTypeInformation
    Write-Host "Saved top 20 to $outputFile"
}
