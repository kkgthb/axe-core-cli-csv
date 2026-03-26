# Quick accessibility scan guide

The PowerShell code within the file "[running_axe_example.ps1](running_axe_example.ps1)" can help you loop over the rows of a CSV file that includes a column named "URL" _(search the code for "`$url_column_name`" and change the right side of the `=` from `'URL'` to `'TYPE_SOMETHING_ELSE_HERE'` if you called it something else)_, and will run the "@axe-core/cli" command-line tool against each URL from the CSV file, so as to validate them against WCAG accessibility standards.

NOTE:  the rest of this README file is LLM-generated.  So take it for what it's worth.  I'm not an accessibility expert; I have no idea if the "triage" ideas are correct.  Etc.

**What this does**
- Runs automated accessibility checks against many URLs, showing you results as it goes along.
- Produces one or more JSON-formatted result files in `axe_output/` that list potential accessibility issues.

**Before you start (very short)**
- Use a Windows PC with PowerShell (the default terminal on most Windows machines).
- Put the list of web addresses (URLs) you want scanned into a CSV-formatted file on your hard drive.  You can use my file [data/example_urls.csv](data/example_urls.csv) as a template.
- Make sure you have an internet connection while the scan runs.

**Quick start — run the scan**
1. Open PowerShell in the repository folder (where this README and `running_axe_example.ps1` live).
2. Allow the script to run for this session and start it with these commands:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\running_axe_example.ps1
```

The script will read the URLs from `data/example_urls.csv` and write results into the `axe_output/` folder.

**Where to look for results**
- Running this script will also display results into the command-line interface terminal from which you ran `running_axe_example.ps1`, so you can just scroll up and see what the results were.  This is probably cleaner and easier to read than the JSON-formatted output.
- However, if you want, after the run, you can also open the  `axe_output` folder. Files are named like `axe-results-<timestamp>.json`.  Each JSON file contains a list of pages and the accessibility issues found for each page.

**Simple triage**
- Priority 1: Fix any **violations** _(they will include a short description, a note about which page it applies to, and examples of where the problem appears)_ marked as "critical" or affecting keyboard users and screen readers.
- Priority 2: Fix color contrast and missing labels.
- Share the JSON files with your developer or vendor and point them to the top 5 most frequent or highest-severity issues.

**If something goes wrong**
- If PowerShell refuses to run scripts, re-run the `Set-ExecutionPolicy` command above (it only affects the current window).
- If nothing appears in `axe_output`, check that `data/example_urls.csv` has valid web addresses (one per line or as in the example file).
- If the script stops on a specific site, that page may be blocking automated checks — try removing that URL and re-running.
