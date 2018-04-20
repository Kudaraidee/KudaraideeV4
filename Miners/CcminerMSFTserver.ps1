. .\Include.ps1

$Path = ".\Bin\NVIDIA-MSFTserver\ccminer-x64.exe"
$Uri = "https://github.com/MSFTserver/ccminer/releases/download/2.2.5-rvn/ccminer-x64-2.2.5-rvn-cuda9.7z"

$Commands = [PSCustomObject]@{
    #"phi" = " " #Phi
    #"bitcore" = " " #Bitcore
    #"jha" = " " #Jha
    #"blake2s" = " " #Blake2s
    #"blakecoin" = " " #Blakecoin
    #"vanilla" = "" #BlakeVanilla
    #"cryptonight" = " -i 10.5 -l 8x120 --bfactor=8  --api-remote" #Cryptonight
    #"decred" = "" #Decred
    #"equihash" = "" #Equihash
    #"ethash" = "" #Ethash
    #"groestl" = " " #Groestl
    #"hmq1725" = ",d=128 -i 20" #hmq1725
    #"keccak" = "" #Keccak
    #"lbry" = " " #Lbry
    #"lyra2v2" = "" #Lyra2RE2
    #"lyra2z" = "  --api-remote --submit-stale" #Lyra2z
    #"myr-gr" = "" #MyriadGroestl
    #"neoscrypt" = " " #NeoScrypt
    #"nist5" = "" #Nist5
    #"pascal" = "" #Pascal
    #"qubit" = "" #Qubit
    #"scrypt" = "" #Scrypt
    #"sia" = "" #Sia
    #"sib" = "" #Sib
    #"skein" = "" #Skein
    #"skunk" = " " #Skunk
    #"timetravel" = " " #Timetravel
    #"tribus" = " " #Tribus
    #"x11" = "" #X11
    #"veltor" = "" #Veltor
    #"x11evo" = " " #X11evo
    #"x17" = " " #X17
    "x16r" = "  --api-remote --api-allow=0/0" #X16r
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = "-a $_ -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Live}
        API = "Ccminer"
        Port = 4068
        Wrap = $false
        URI = $Uri
		User = $Pools.(Get-Algorithm($_)).User
    }
}
