# ---- BEGIN HELPER FUNCTION CODE ----
function Start-AxeScanFromCsv {
    Param(
        [string]$InputCsvPath,
        [string]$OutputDir = "$PSScriptRoot\axe_output",
        [string[]]$WcagTags = @('wcag2a', 'wcag2aa', 'wcag21a', 'wcag21aa')
    )

    Begin {
        function Assert-NpmInstalled {
            if (-not (Get-Command "npm" -ErrorAction SilentlyContinue)) {
                Write-Error "ERROR: npm is not installed. Please install Node.js + npm."
                exit 1
            }
            Write-Host "Confirmed that NPM is installed; version: $(npm -v)" -ForegroundColor Green
        }
        function Assert-AxeCliInstalled {
            $pkg = '@axe-core/cli'
            Write-Host "Checking for $pkg..." -NoNewline
            $axeCheck = npm list -g $pkg --depth=0 -ErrorAction SilentlyContinue
            if ($axeCheck -match "empty") {
                Write-Host " [NOT FOUND]" -ForegroundColor Red
                Write-Error "ERROR: $pkg is not installed globally."
                Write-Host "To fix: npm install -g $pkg" -ForegroundColor Yellow
                exit 1
            }
            Write-Host " [OK]" -ForegroundColor Green
        }
        # Make sure NPM is installed
        Assert-NpmInstalled
        Assert-AxeCliInstalled
    } # end BEGIN

    Process {
        ForEach ($incsv in $InputCsvPath) {
            # Build tag string (e.g., "wcag2a,wcag2aa,...")
            $tagString = ($Tags | Where-Object { $_ }) -join ','
            # Resolve paths and prepare output directory
            $inputResolved = [System.IO.Path]::GetFullPath($incsv)
            $outputResolved = [System.IO.Path]::GetFullPath($OutputDir)
            if (-not (Test-Path $outputResolved)) { New-Item -ItemType 'Directory' -Path $outputResolved | Out-Null }
            # Load URLs
            if (-not (Test-Path $inputResolved)) {
                Write-Error "Input CSV not found: $inputResolved"
                exit 1
            }
            $csv = Import-Csv -Path $inputResolved
            $url_column_name = 'URL'
            if (-not $csv -or -not ($csv | Get-Member -Name $url_column_name -MemberType 'NoteProperty')) {
                Write-Error "CSV must contain a '$url_column_name' column."
                exit 1
            }
            $urls = $csv.URL | Where-Object { $_ } | Sort-Object -Unique
            if ($urls.Count -eq 0) {
                Write-Error "No URLs found in CSV."
                exit 1
            }
            Write-Host "Beginning Axe scan of $($urls.Count) URL(s)..." -ForegroundColor 'Green'
            $start = Get-Date
            # Bulk run: all URLs in one axe invocation
            axe --dir "$outputResolved" --tags "$tagString" @urls

            $end = Get-Date
            $duration = New-TimeSpan -Start $start -End $end
            Write-Host "Finished Axe scan in $($duration.ToString()). Reports in: $outputResolved" -ForegroundColor 'Green'
        }
    } # end PROCESS

    End {} # end END
}
# ---- END HELPER FUNCTION CODE ----

# ---- BEGIN EXAMPLE (OF A MAIN SCRIPT THAT CALLS THE HELPER FUNCTION) ----
# NOTE TO READER:  YOU SHOULD CHANGE THE VALUE OF "InputCsv" and perhaps of "OutputDir" in the following line of code, before running it!
Start-AxeScanFromCsv -InputCsv "$PSScriptRoot\data\example_urls.csv" -OutputDir "$PSScriptRoot\axe_output"
# ---- BEGIN EXAMPLE ----