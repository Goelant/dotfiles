function Update-Zebar-Config
{
	$zebarConfigPath = "$env:Moaid_Config_Path/config/glazewm/zebar_config.yaml"
	$zebarDefaultConfigPath = "$env:USERPROFILE/.glzr/zebar/config.yaml"

	Copy-Item -Path $zebarConfigPath -Destination $zebarDefaultConfigPath -Force
}

function Restart-Zebar($overrideConfigs = $true)
{
	if ($overrideConfigs)
	{
		Update-Zebar-Config
	}

	Stop-Zebar
	Start-Zebar
}

function Start-Zebar
{
	$monitors = zebar monitors
	foreach ($monitor in $monitors) {
	 Start-Process -WindowStyle Hidden -FilePath "zebar" -ArgumentList "open bar --args $monitor"
	};
}

function Stop-Zebar
{
	Get-Process | Where-Object { $_.ProcessName -eq "zebar" } | Foreach-Object { Stop-Process -id $_.id -Force }
}