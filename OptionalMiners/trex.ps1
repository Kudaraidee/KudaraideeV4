if (!(IsLoaded(".\Include.ps1"))) {. .\Include.ps1;RegisterLoaded(".\Include.ps1")}

$Path = ".\Bin\NVIDIA-Trex\t-rex.exe"
$Uri = "https://github.com/trexminer/T-Rex/releases/download/0.9.2/t-rex-0.9.2-win-cuda10.0.zip"

$Commands = [PSCustomObject]@{
"astralhash" = " -a astralhash" #Astralhash(GlobalToken)
"balloon" = " -a balloon" #Balloon
"bcd" = " -a bcd" #Bcd
"bitcore" = " -a bitcore" #Bitcore
"c11" = " -a c11" #C11
"dedal" = " -a dedal" #Dedal
"geek"= " -a geek" #Geekcash
"hmq1725" = " -a hmq1725" #hmq1725
"hsr" = " -a hsr" #Hsr(Testing)
"jeonghash" = " -a jeonghash" #Jeonghash(GlobalToken)
"lyra2z" = " -a lyra2z" #Lyra2z 
"padihash" = " -a padihash" #Padihash(GlobalToken)
"pawelhash " = " -a pawelhash" #Pawelhash(GlobalToken)
"polytimos" = " -a polytimos" #Poly
"sha256t" = " -a sha256t" #Sha256t
"skunk" = " -a skunk" #Skunk
"sonoa" = " -a sonoa" #SonoA
"tribus" = " -a tribus" #Tribus
"x16r" = " -a x16r" #X16r
"x16rt" = " -a x16rt" #X16RT (GIN)
"veil" = " -a x16rt" #X16RT (VEIL)
"x16s" = " -a x16s" #X16s
"x17" = " -a x17" #X17
"x21s" = " -a x21s" #X21S
"x22i" = " -a x22i" #X22I
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = " -b 127.0.0.1:$($Variables.NVIDIAMinerAPITCPPort) -d $($Config.SelGPUCC) -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Day * .99} # substract 1% devfee
        API = "ccminer"
        Port = $Variables.NVIDIAMinerAPITCPPort
        Wrap = $false
        URI = $Uri
        User = $Pools.(Get-Algorithm($_)).User
    }
}
