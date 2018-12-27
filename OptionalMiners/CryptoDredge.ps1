if (!(IsLoaded(".\Include.ps1"))) {. .\Include.ps1; RegisterLoaded(".\Include.ps1")}

$Path = ".\Bin\NVIDIA-CryptoDredge\CryptoDredge.exe"
$Uri = "https://github.com/technobyl/CryptoDredge/releases/download/v0.15.0/CryptoDredge_0.15.0_cuda_10.0_windows.zip"

$Commands = [PSCustomObject]@{
    "allium"            = " " #Allium (fastetst)
	"blake2s"			= " "
	"bcd"				= " "
	"c11"				= " "
    "dedal"				= " " #Dedal (New Algorithm Numus)
    "exosis"			= " "
	"hmq1725"			= " "
	"lyra2v2"           = " " #Lyra2RE2 (fastest)
    "lyra2v3"           = " " #Lyra2V3 (New Algorithm Vertcoin)
    "lyra2vc0ban"       = " " #Lyra2vc0banHash (fastest)
    "lyra2z"            = " " #Lyra2z (fastest)
    "mtp"            	= " " #MTP (fastest)
    "neoscrypt"         = " " #NeoScrypt (fastest)
    "phi"               = " " #Phi
    "phi2"              = " " #Phi2 (fastest)
    "pipe"              = " " #Pipe (fastest)
    "lbk3"              = " " #Lbk3(test)
    "skein"             = " " #Skein
    "skunk"             = " " #Skunk
    "x16r"				= " " #X16R
	"x16s"				= " " #X16S
	"x21s"				= " " #X21S RITO
	"x22i"              = " " #X22i SUQA
    "cryptonightheavy"  = " " # CryptoNightHeavy(fastest)
    "cryptonightv7"     = " " # CryptoNightV7(fastest)
    "cryptonightmonero" = " " # Cryptonightmonero(fastest)
    "tribus"            = " " #Tribus (fastest)
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type      = "NVIDIA"
        Path      = $Path
        Arguments = " --retry-pause 1 -b 127.0.0.1:$($Variables.NVIDIAMinerAPITCPPort) -d $($Config.SelGPUCC) --no-watchdog -a $_ -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_) -R 1 -q -N 1"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Week * .99} # substract 1% devfee
        API       = "ccminer"
        Port      = $Variables.NVIDIAMinerAPITCPPort
        Wrap      = $false
        URI       = $Uri
        User      = $Pools.(Get-Algorithm($_)).User
    }
}
