if (!(IsLoaded(".\Include.ps1"))) {. .\Include.ps1; RegisterLoaded(".\Include.ps1")}

$Path = ".\Bin\CPU-Bubasik\cpuminer.exe"
$Uri = "https://github.com/bubasik/cpuminer-opt-yespower/releases/download/v3.8.8.3/cpuminer-opt-cryply-yespower-ver2.zip"

$Commands = [PSCustomObject]@{
    "yespower" = " " #Yespower
    "yespowerr8" = " " #YespowerR8
    "yespowerr16" = " " #YespowerR16
    "yespowerr24" = " " #YespowerR24
    "yespowerr32" = " " #YespowerR32
    }

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type = "CPU"
        Path = $Path
        Arguments = "-b $($Variables.CPUMinerAPITCPPort) -a $_ -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Live}
        API = "Ccminer"
        Port = $Variables.CPUMinerAPITCPPort
        Wrap = $false
        URI = $Uri
	   User = $Pools.(Get-Algorithm($_)).User
    }
}
