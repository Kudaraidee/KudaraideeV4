if (!(IsLoaded(".\Include.ps1"))) {. .\Include.ps1;RegisterLoaded(".\Include.ps1")}

$Path = ".\Bin\NVIDIA-Trex\t-rex.exe"
$Uri = "https://github.com/trexminer/T-Rex/releases/download/0.8.9/t-rex-0.8.9-win-cuda10.0.zip"

$Commands = [PSCustomObject]@{
"astralhash" = "" #Astralhash(GlobalToken)
"balloon" = "" #Balloon
"bcd" = "" #Bcd
"bitcore" = "" #Bitcore
"c11" = "" #C11
"dedal" = "" #Dedal
"geek"= "" #Geekcash
"hmq1725" = "" #hmq1725
"hsr" = "" #Hsr(Testing)
"jeonghash" = "" #Jeonghash(GlobalToken)
"lyra2z" = "" #Lyra2z 
"padihash" = "" #Padihash(GlobalToken)
"pawelhash " = "" #Pawelhash(GlobalToken)
"polytimos" = "" #Poly
"sha256t" = "" #Sha256t
"skunk" = "" #Skunk
"sonoa" = "" #SonoA
"tribus" = "" #Tribus
"x16r" = "" #X16r
"x16s" = "" #X16s
"x17" = "" #X17
"x21s" = "" #X21S
"x22i" = "" #X22I
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = " -b 127.0.0.1:$($Variables.NVIDIAMinerAPITCPPort) -d $($Config.SelGPUCC) -a $_ -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Day * .99} # substract 1% devfee
        API = "ccminer"
        Port = $Variables.NVIDIAMinerAPITCPPort
        Wrap = $false
        URI = $Uri
        User = $Pools.(Get-Algorithm($_)).User
    }
}
