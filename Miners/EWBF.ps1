$Path = '.\Bin\NVIDIA-EWBF\miner.exe'
$Uri = 'http://nemos.dx.am/opt/nemos/EWBFEquihashminerv0.5.7z'

# Automatically add Equihash coins if Equihash in algo list
If ("equihash" -in $Config.Algorithm) {
	(Get-Content .\Algorithms.txt | ConvertFrom-Json) | Get-Member -MemberType noteproperty | Where {$_.Name -like "equihash*"} | Foreach {
		If ($_.Name -notin $Config.Algorithm) {
			$Config.Algorithm += $_.Name
		}
	}
}

$Commands = [PSCustomObject]@{
    "equihash144" = " --cuda_devices $($Config.SelGPUDSTM) --algo 144_5 --pers auto" #Equihash144
    "equihash192" = " --cuda_devices $($Config.SelGPUDSTM) --algo 192_7 --pers ZERO_PoW" #Equihash192
    "equihash-btg" = "--cuda_devices $($Config.SelGPUDSTM) --algo 144_5 --pers BgoldPoW" # Equihash-btg
}


$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = "--templimit 95 --api --server $($Pools.(Get-Algorithm($_)).Host) --port $($Pools.(Get-Algorithm($_)).Port) --user $($Pools.(Get-Algorithm($_)).User) --pass $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Live}
        API = "EWBF"
        Port = 42000
        Wrap = $false
        URI = $Uri
		User = $Pools.(Get-Algorithm($_)).User
    }
}
