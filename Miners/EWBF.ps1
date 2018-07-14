$Path = '.\Bin\NVIDIA-EWBF\miner.exe'
$Uri = 'http://nemos.dx.am/opt/nemos/EWBFEquihashv0.3.7z'


$Commands = [PSCustomObject]@{
    Equihash144 = ' --algo 144_5 --pers sngemPoW'
    Equihash192 = ' --algo 192_7 --pers ZERO_PoW'
    
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = "--api --server $($Pools.(Get-Algorithm($_)).Host) --port $($Pools.(Get-Algorithm($_)).Port) --user $($Pools.(Get-Algorithm($_)).User) --pass $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Live}
        API = "EWBF"
        Port = 42000
        Wrap = $false
        URI = $Uri
		User = $Pools.(Get-Algorithm($_)).User
    }
}
