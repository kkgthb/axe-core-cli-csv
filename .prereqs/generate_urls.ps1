$list_of_ids = ForEach ($i in 1..199) { "{0:D3}" -f $i }
$list_of_objects = $list_of_ids | ForEach-Object {
    [PSCustomObject]@{
        "Note" = "Site $_"
        "URL" = "https://www.example.com/$_"
    }
}
$list_of_objects | Export-CSV -Path "$PSScriptRoot/../data/example_urls.csv" -NoTypeInformation