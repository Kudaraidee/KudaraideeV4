$Path = '.\Bin\NVIDIA-EWBF\miner.exe'
$Uri = 'http://nemos.dx.am/opt/nemos/EWBFEquihashminerv0.6.7z'


$Commands = [PSCustomObject]@{
	"equihash96" = " --cuda_devices $($Config.SelGPUDSTM) --algo 96_5 --pers auto" #Equihash96
	"equihash144" = " --cuda_devices $($Config.SelGPUDSTM) --algo 144_5 --pers auto" #Equihash144
	"equihash192" = " --cuda_devices $($Config.SelGPUDSTM) --algo 192_7 --pers ZERO_PoW" #Equihash192
	"equihash-btg" = "--cuda_devices $($Config.SelGPUDSTM) --algo 144_5 --pers BgoldPoW" # Equihash-btg
    
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = "--api 127.0.0.1:$($Variables.NVIDIAMinerAPITCPPort) --server $($Pools.(Get-Algorithm($_)).Host) --port $($Pools.(Get-Algorithm($_)).Port) --user $($Pools.(Get-Algorithm($_)).User) --pass $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Live}
        API = "EWBF"
        Port = $Variables.NVIDIAMinerAPITCPPort
        Wrap = $false
        URI = $Uri
		User = $Pools.(Get-Algorithm($_)).User
    }
}
