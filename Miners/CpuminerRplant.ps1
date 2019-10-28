if (!(IsLoaded(".\Include.ps1"))) {. .\Include.ps1; RegisterLoaded(".\Include.ps1")}

$ManualUri = "https://github.com/rplant8/cpuminer-opt-rplant/releases"
$DevFee = 0.0
$Version = "4.0.20"

$Path = ".\Bin\CPU-Rplant_$($Version)\cpuminer-$($f = $Global:GlobalCPUInfo.Features;$(if($f.avx2 -and $f.sha -and $f.aes){'ryzen'}elseif($f.avx2 -and $f.aes){'avx2'}elseif($f.avx -and $f.aes){'avx'}elseif($f.aes){'aes'}elseif($f.sse42){'sse42'}else{'sse2'})).exe"
$Uri = "https://github.com/RainbowMiner/miner-binaries/releases/download/v4.0.20-rplant/cpuminer-rplant-4.0.20-win.zip"



$Commands = [PSCustomObject]@{
    	"argon2ad" = " " #Argon2ad (URX)
    	"argon2d500" = " " #Argon2d500 (DYN)
    	"argon2d4096" =" " #Argon2d4096 (UIS)
    	"argon2d-glt" = " " #Argon2d (GLT)
    	"argon2i-glt" = " " #Argon2i (GLT)
    	"argon2m" = " " #Argon2m (Merge)
		"cpupower" = " "  #CpuPower
    	"cryptovantaa" = " " #IOtE
    	"honeycomb" = " " #Honeycomb
    	"lyra2cz" = " " #Lyra2cz
		"lyra2z330" = " " #Lyra2z330
    	"power2b" = " " #Yespower2b
		"yescryptr16" = "" #YescryptR16
    	"yescryptr16v2" = " " #YescryptR16v2
		"yescryptr16v2glt" = "" 
    "yescryptr24" = " " #YescryptR24
	"yescryptr24glt" = " " 
    "yescryptr32" = " " #YescryptR32
	"yescryptr32glt" = " " 
    "yescryptr8" = " " 
	"yescryptr8glt" = " " #YescryptR8
    "yescryptr8g" = " " #YescryptR8g (KOTO)
    "yespower" = " " #Yespower
    "yespowerr16" = " " #YespowerR16
    "yespowerLITB" = " " #Yespower LightBit (LITB)y
    "yespowerLTNCG" = " " #Yespower LighningCash-Gold v3 (LTNCG)
    "yespowerRES" = " " #Yespower Resistance (RES)
    "yespowerSUGAR" = " " #Yespower SugarChain (SUGAR)
    "yespowerURX" = " " #Yespower Uranium-X (URX)
    "Binarium_hash_v1" = " " #Binarium
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