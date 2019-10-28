if (!(IsLoaded(".\Include.ps1"))) {. .\Include.ps1; RegisterLoaded(".\Include.ps1")}

$ManualUri = "https://github.com/JayDDee/cpuminer-opt/releases"
$DevFee = 0.0
$Version = "4.2b"

$Path = ".\Bin\CPU-RKZ_$($Version)\cpuminer.exe"
$Uri = "https://github.com/RickillerZ/cpuminer-RKZ/releases/download/V4.2b/cpuminer-RKZ.zip"

$Commands = [PSCustomObject]@{
	"cpupower" = " --api-remote" #CPUPower
	"m7m" = " --api-remote" #M7M
	"power2b" = " " #Yespower2b
	"yescryptr8" = " --api-remote" #YescryptR8
    "yescryptr16" = " --api-remote" #YescryptR16
	"yescryptr32" = " --api-remote" #YescryptR32
	
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

