# Convert GENO Broker CSVs To Parqet CSVs
A PowerShell script to convert transaction CSV files from [GENO Broker](https://www.genobroker.de/) into CSVs files that can be imported as activities into [Parqet](https://www.parqet.com/).

## Background

[Parqet](https://www.parqet.com/) does not support importing transaction CSVs from [GENO Broker](https://www.genobroker.de/) but provides a [CSV template](https://www.parqet.com/blog/csv) to enable users to transform their transactions into a supported format.

The objective of this PowerShell script is to convert transaction CSVs from [GENO Broker](https://www.genobroker.de/) into CSVs files that can be imported as activities into [Parqet](https://www.parqet.com/).

## Attention

The are some deficiencies you should know before importing into Parqet.

* The transactions in the [GENO Broker](https://www.genobroker.de/) CSV only have dates but not time
* The transactions in the [GENO Broker](https://www.genobroker.de/) have, in rare cases, incorrect tax values (e.g., Transfer In of non € shares after Spin-off).
* The transactions in the [GENO Broker](https://www.genobroker.de/) can have prices of '0,0000', which is not supported by [Parqet](https://www.parqet.com/) and will be replaced by '0,0001'.

## Prerequisites
Before you begin, ensure you have met the following requirements:

### [GENO Broker](https://www.genobroker.de/)
* You have a brokerage account with [GENO Broker](https://www.genobroker.de/)
* You have downloaded a transaction CSV file from [GENO Broker](https://www.genobroker.de/)
  * Brokerage Classic => Depot => Depotumsätze => Liste als CSV exportieren

### [Parqet](https://www.parqet.com/)
* You have registered for a Basis/Plus/Investor account with [Parqet](https://www.parqet.com/)
* You have created a portfolio at [Parqet](https://www.parqet.com/) ready for importing transactions

### Microsoft Windows / PowerShell
* You have a Windows 10 machine.
* You have Windows PowerShell 5.1 installed.

## Installation
* Transfer the 'Convert_GENO_Broker_CSVs_To_Parqet_CSVs.ps1' to your machine.

## Usage
* Run 'Convert_GENO_Broker_CSVs_To_Parqet_CSVs.ps1' by right-clicking and selecting 'Run with Powershell'

## Contributing
To contribute, follow these steps:

1. Fork this repository.
2. Create a branch: `git checkout -b <branch_name>`.
3. Make your changes and commit them: `git commit -m '<commit_message>'`
4. Push to the original branch: `git push origin <project_name>/<location>`
5. Create the pull request.

Alternatively, see the GitHub documentation on [creating a pull request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request).

## Attribution

Thanks to the following people whose work I have been able to use in this project:

[Selecting multiple documents in folder via powershell](https://stackoverflow.com/a/64481315)
* License: Attribution-ShareAlike 4.0 International ([CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/))
* Attribution: [peter](https://stackoverflow.com/users/13496918/peter); [theo](https://stackoverflow.com/users/9898643/theo)

## Contact

If you want to contact me, you can reach me at kfib@heidoetting.de.

## License

This project uses the following license: Attribution-ShareAlike 4.0 International ([CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/))