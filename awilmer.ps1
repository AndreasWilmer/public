Function New-Password {
	<#
	.SYNOPSIS
		This function will create a secure password .	
	.DESCRIPTION
		This function will create a secure password.
		The Dictionary will be loaded from https://raw.githubusercontent.com/dwyl/english-words/master/words_alpha.txt 	
		ASCII characters used
		65-90  (A-Z)
		97-122 (a-z)
		33-38  (!"#$%&)
		40-57  (()*+,-./0-9)
		64     (@)
	.PARAMETER Length
		Specifies the number of characters for the password	
	.PARAMETER Words
		Specifies the number of words used as a password, joined with "-"	
	.PARAMETER CopyToClipboard
		This Parameter will copy the new password to the clipboard
	.PARAMETER SpecialCharacters
		Specifies the number of special characters in a password. Default Value is 4	
	.PARAMETER Numbers
		Specifies the number of numbers in a password. Default Value is 2	
	.EXAMPLE
		new-password -Length 10
		x}[xz).1g{	
	.EXAMPLE
		new-password -length 10 -CopyToClipboard
		x}[xz).1g{	
	.EXAMPLE
		new-password -Length 20 -SpecialCharacters 2 -Numbers 3
		zTt!DKy0rLE.Pg6sm5Yd		
	.EXAMPLE
		new-password -Words 4
		Outsigh-Simarouba-Cockle-Holometer	
#>
	
	Param
	(
		[Parameter(ParameterSetName = 'characters', Mandatory = $true, Position = 0)][INT]$Length,
		[Parameter(ParameterSetName = 'words', Mandatory = $true, Position = 0)][INT]$Words,
		[Parameter(ParameterSetName = 'words', Mandatory = $false)][Parameter(ParameterSetName = 'characters')][switch]$CopyToClipboard,
		[Parameter(ParameterSetName = 'characters')][int]$SpecialCharacters = 4,
		[Parameter(ParameterSetName = 'characters')][int]$Numbers = 2
	)
	$Global:NewPassword = $null
	If ($length) {
		$ToRandomize = @()
		$ToRandomize += ((33 .. 38) + (40 .. 47) + (64) | Get-Random -Count $SpecialCharacters | ForEach-Object {
				[char]$_
			})
		$ToRandomize += -join ((48 .. 57) | Get-Random -Count $numbers | ForEach-Object {
				[char]$_
			})
		$ToRandomize += ((65 .. 90) + (97 .. 122) | Get-Random -Count ($length - ($SpecialCharacters + $numbers)) | ForEach-Object {
				[char]$_
			})
		$Global:NewPassword = ($torandomize |Sort-Object {
				get-random
			}) -join ""
	}
	If ($words) {
		$temp = (Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/dwyl/english-words/master/words_alpha.txt').content.Split([Environment]::NewLine, [System.StringSplitOptions]::RemoveEmptyEntries);
		$Global:NewPassword = (get-random -InputObject $temp -count $words | ForEach-Object{
				$_.substring(0, 1).toupper() + $_.substring(1)
			}) -join "-"
	}
	If ($CopyToClipboard) {
		$Global:NewPassword | clip
	}
	Return $Global:NewPassword
}
