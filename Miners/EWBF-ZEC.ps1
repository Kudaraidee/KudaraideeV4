$Path = '.\Bin\NVIDIA-EWBF(ZEC)\miner.exe'
$Uri = 'https://github.com/nanopool/ewbf-miner/releases/download/v0.3.4b/Zec.miner.0.3.4b.zip'


$Commands = [PSCustomObject]@{
    Equihash = ' '
    
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = "--templimit 95 --api 127.0.0.1:$($Variables.NVIDIAMinerAPITCPPort) --server $($Pools.(Get-Algorithm($_)).Host) --port $($Pools.(Get-Algorithm($_)).Port) --user $($Pools.(Get-Algorithm($_)).User) --pass $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Live}
        API = "EWBF"
        Port = $Variables.NVIDIAMinerAPITCPPort
        Wrap = $false
        URI = $Uri
	User = $Pools.(Get-Algorithm($_)).User
    }
}
