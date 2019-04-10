if (!(IsLoaded(".\Include.ps1"))) {. .\Include.ps1; RegisterLoaded(".\Include.ps1")}

$Path = '.\Bin\AMD-TeamRedMiner\teamredminer.exe'
$Uri = 'https://github.com/todxx/teamredminer/releases/download/v0.4.3/teamredminer-v0.4.3-win.zip'

$Commands = [PSCustomObject]@{
    Lyra2rev3 = ' -a lyra2rev3'
    Lyra2z = ' -a lyra2z'#lyra2z
    Phi2 = ' -a phi2'
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type = "AMD"
        Path = $Path
        Arguments = "--api_listen=127.0.0.1:$($Variables.AMDMinerAPITCPPort) -d $($Config.SelGPUSG) --platform=0 -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Live}
        API = "xgminer"
        Port = $Variables.AMDMinerAPITCPPort
        Wrap = $false
        URI = $Uri
		User = $Pools.(Get-Algorithm($_)).User
    }
}