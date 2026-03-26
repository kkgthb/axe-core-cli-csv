function Assert-NpmInstalled {
    if (-not (Get-Command "npm" -ErrorAction SilentlyContinue)) {
        Write-Error "ERROR: npm is not installed on this computer. Please ask your help desk for support installing Node.js and NPM properly onto your computer."
        exit 1 # Stops the script immediately
    }
    Write-Host "Confirmed that NPM is installed; current version number is $(npm -v)" -ForegroundColor 'Green'
}
function Assert-AxeCliInstalled {
    $npm_package_name = '@axe-core/cli'
    Write-Host "Checking for $npm_package_name..." -NoNewline
    $axeCheck = npm list -g $npm_package_name --depth=0 -ErrorAction SilentlyContinue # --depth=0 makes this much faster by only looking at top-level global packages
    if ($axeCheck -match "empty") {
        Write-Host " [NOT FOUND]" -ForegroundColor Red
        Write-Error "ERROR: $npm_package_name is not installed globally."
        Write-Host "To fix this, run: the following command:" -ForegroundColor Yellow
        Write-Host "npm install -g $npm_package_name" -ForegroundColor Yellow
        exit 1
    }
    Write-Host " [OK]" -ForegroundColor Green
}


# --- Main Script below ---
Assert-NpmInstalled
Assert-AxeCliInstalled
$wcag_scan_types_i_care_about = @(
    'wcag2a'
    'wcag2aa'
    'wcag21a'
    'wcag21aa'
)
$comma_separated_wcag_types = $wcag_scan_types_i_care_about -Join ','
# $my_desired_report_output_folder_path = [System.IO.Path]::GetFullPath("$PSScriptRoot/axe_output") # COMMENTED OUT FOR NOW
# $output_path_resolved = [System.IO.Path]::GetFullPath($my_desired_report_output_folder_path) # COMMENTED OUT FOR NOW
$my_input_csv_file_path = "$PSScriptRoot\data\example_urls.csv" # TODO:  CHANGE ME TO WHERE YOUR ACTUAL DATA FILE LIVES ON YOUR HARD DRIVE!
# $my_input_csv_file_path = 'C:\example\my_urls.csv" # EXAMPLE:  LIKE THIS!
$csv_path_resolved = [System.IO.Path]::GetFullPath($my_input_csv_file_path)
$my_data = Import-Csv -Path $csv_path_resolved
$list_of_urls_to_scan = $my_data.URL
Write-Host "Beginning Axe scan (note -- this will take a while if you provided a long list of URLs.  You will see another green message after it is done.)" -ForegroundColor 'Green'
# (axe --dir "$output_path_resolved" --tags "$comma_separated_wcag_types" @list_of_urls_to_scan) # THIS ACTUALLY RUNS THE SCAN BUT DUMPS TO JSON # COMMENTED OUT FOR NOW
(axe --tags "$comma_separated_wcag_types" @list_of_urls_to_scan) # THIS ACTUALLY RUNS THE SCAN, and is concise, but takes forever.  Comment out if you hate that and uncomment the lines below.
# ForEach ($url in $list_of_urls_to_scan) { 
#     Write-Host "Scanning URL $url now." -ForegroundColor 'Cyan'
#     (axe --tags "$comma_separated_wcag_types" $url) # THIS ACTUALLY RUNS THE SCAN
#     Write-Host "Scan of URL $url completed." -ForegroundColor 'Cyan'
# } # THIS TAKES LESS TIME PER URL TO SHOW UP, BUT IS MORE VERBOSE TO READ WHEN SCROLLING BACK UP, SO COMMENTED OUT FOR NOW.
Write-Host "Finished Axe scan.  Scroll back up to see what happened." -ForegroundColor 'Green'
# --- Main Script above ---

# I think I prefer native PowerShell output and scrolling back up, since there is no free HTML beautifier of a bulk operation's JSON output available from Deque Axe.
# ($45/month/user, yikes!)
# Various community folks have made equivalents, but some enterprise folks might not be allowed to use them, so this demo does not.