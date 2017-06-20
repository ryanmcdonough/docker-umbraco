#
# Powershell script for adding and removing entries in the Windows hosts file.
#
# Known limitations:
# - does not handle entries with comments afterwards ("<ip>    <host>    # comment")
#
# Origin: https://gist.github.com/markembling/173887/

$file = "C:\Windows\System32\drivers\etc\hosts"

function Add-Host([string]$ip, [string]$hostname, [string]$filename = $file) {
	Remove-Host $filename $hostname
	$ip + "`t`t" + $hostname | Out-File -encoding ASCII -append $filename
}

function Remove-Host([string]$filename, [string]$hostname) {
	$c = Get-Content $filename
	$newLines = @()
	
	foreach ($line in $c) {
		$bits = [regex]::Split($line, "\t+")
		if ($bits.count -eq 2) {
			if ($bits[1] -ne $hostname) {
				$newLines += $line
			}
		} else {
			$newLines += $line
		}
	}
	
	# Write file
	Clear-Content $filename
	foreach ($line in $newLines) {
		$line | Out-File -encoding ASCII -append $filename
	}
}