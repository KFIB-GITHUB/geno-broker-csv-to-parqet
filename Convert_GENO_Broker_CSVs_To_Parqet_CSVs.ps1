# Convert GENO Broker CSVs To Parqet CSVs
# A PowerShell script to convert transaction CSV files from GENO Broker into CSVs files that can be imported as activities into Parqet.
# License: Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)
# Attribution: kfib@heidoetting.de

function Select-Files {  

  # Function to present the user with a files selector that enables the selection of multiple files.
  # Snippet: https://stackoverflow.com/a/64481315
  # License: Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)
  # Attribution: https://stackoverflow.com/users/13496918/peter; https://stackoverflow.com/users/9898643/theo

  [CmdletBinding()]  
  Param (   
    [Parameter(Mandatory = $false)]  
    [string]$WindowTitle = 'Select File(s)',

    [Parameter(Mandatory = $false)]
    [string]$InitialDirectory,  

    [Parameter(Mandatory = $false)]
    [string]$Filter = '*All files (*.*)|*.*',

    [switch]$AllowMultiSelect
  ) 
  Add-Type -AssemblyName System.Windows.Forms

  $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
  $openFileDialog.Title = $WindowTitle
  $openFileDialog.Filter = $Filter
  $openFileDialog.CheckFileExists = $true
  if (![string]::IsNullOrWhiteSpace($InitialDirectory)) { $openFileDialog.InitialDirectory = $InitialDirectory }
  if ($AllowMultiSelect) { $openFileDialog.MultiSelect = $true }

  if ($openFileDialog.ShowDialog().ToString() -eq 'OK') {
    if ($AllowMultiSelect) { 
      $selected = @($openFileDialog.Filenames)
    } 
    else { 
      $selected = $openFileDialog.Filename
    }
  }
  # clean-up
  $openFileDialog.Dispose()

  return $selected
}

# Present the user with a files selector that enables the selectin of multiple *.csv files, defaulting to 'My Documents'
# Snippet: https://stackoverflow.com/a/64481315
# License: Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)
# Attribution: https://stackoverflow.com/users/13496918/peter; https://stackoverflow.com/users/9898643/theo

$CSVfiles = Select-Files `
  -WindowTitle 'Bitte zu konvertierende CSVs von GENO Broker auswählen / Please select GENO Broker CSVs for conversion' `
  -Filter 'All files (*.csv)|*.csv' `
  -InitialDirectory ([Environment]::GetFolderPath("MyDocuments")) `
  -AllowMultiSelect

$CSVfiles | Foreach-Object {

  $FileContent = Get-Content -Path $_
  $CSVContent = $FileContent | select-string -pattern @('^[^;\n]*((;[^;\n]*){10,}$)') -encoding ASCII
  $CSVRecords = ConvertFrom-CSV $CSVContent -Delimiter ';'

  $New = $CSVRecords | Select-Object `
  @{N = 'broker'; E = { 'GENO Broker GmbH' } }, `
  @{N = 'currency'; E = { $_.Währung } }, `
  @{N = 'date'; E = { ([Datetime]::ParseExact($_.Datum, 'dd.MM.yyyy', $null)).tostring(“yyyy-MM-dd”) } }, `
  @{N = 'fee'; E = { $_.Spesen } }, `
  @{N = 'assetType'; E = { 'Security' } }, `
  @{N = 'price'; E = { $_.'Ausf. kurs' -replace ('^0,0000$', '0,0001') } }, `
  @{N = 'shares'; E = { [System.Convert]::ToDecimal($_.'Stück/Nominal', [cultureinfo]::GetCultureInfo('de-DE')) } }, `
  @{N = 'tax'; E = { $_.Steuern } }, `
  @{N = 'type'; E = { $_.Geschäftsart -replace ('^Kauf$', 'Buy') -replace ('^Verkauf$', 'Sell') -replace ('^Einlieferung$', 'TransferIn') -replace ('^Auslieferung$', 'TransferOut') -replace ('^Dividende$', 'Dividend') } }, `
  @{N = 'wkn'; E = { $_.WKN } }, `
  @{N = 'description'; E = { $_.Wertpapierbezeichnung } }

  $counter = 0

  $Path = $(Split-Path -Path $_)

  $New | Sort-Object -Property date  | Foreach-Object {

    $FileContentname = "$Path\$($_.date)_$($_.type)_$($_.wkn)_$(($_.description) -Replace('[^A-Za-z]',''))_$((++$counter)).csv"

    $_ | Export-Csv -Path $FileContentname -Delimiter ";" -NoTypeInformation

  }

}



