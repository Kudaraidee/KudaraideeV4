if (!(IsLoaded(".\Include.ps1"))) {. .\Include.ps1; RegisterLoaded(".\Include.ps1")}

$ManualUri = "https://github.com/JayDDee/cpuminer-opt/releases"
$DevFee = 0.0
$Version = "3.9.9.1"

$Path = ".\Bin\CPU-JayDDee_$($Version)\cpuminer-$($f=$Global:GlobalCPUInfo.Features;$(if($f.avx2 -and $f.sha -and $f.aes){'zen'}elseif($f.avx2 -and $f.aes){'avx2'}elseif($f.avx -and $f.aes){'avx'}elseif($f.sse42 -and $f.aes){'aes-sse42'}else{'sse2'})).exe"
$Uri = "https://github.com/RainbowMiner/miner-binaries/releases/download/v3.9.9.1-jayddee/cpuminer-opt-3.9.9.1-windows.zip"

$Commands = [PSCustomObject]@{
	"cpupower" = " --api-remote" #CPUPower
	"lyra2z330" = " --api-remote" #Lyra2z330
    "m7m" = " --api-remote" #M7M
	"power2b" = " --api-remote" #Power2b
	"yescryptr8" = " --api-remote" #YescryptR8
    "yescryptr16" = " --api-remote" #YescryptR16
	"yescryptr32" = " --api-remote" #YescryptR32
	"yespower" = " --api-remote" #Yespower
	"yespowerr16" = " --api-remote" #YespowerR16
    
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

