$Path = '.\Bin\NVIDIA-Alexis\ccminer.exe'
$Uri = 'https://github.com/nemosminer/ccminerAlexis78/releases/download/3%2F3%2F2018/ccminer-Alexis78.zip'

$Commands = [PSCustomObject]@{
    "hsr" = " --api-remote" #Hsr
    #"bitcore" = "" #Bitcore
    "blake2s" = " --api-remote" #Blake2s
    #"blakecoin" = " --api-remote" #Blakecoin
    #"vanilla" = "" #BlakeVanilla
    #"cryptonight" = "" #Cryptonight
    "veltor" = " -i 23 --api-remote" #Veltor
    #"decred" = "" #Decred
    #"equihash" = "" #Equihash
    #"ethash" = "" #Ethash
    #"groestl" = "" #Groestl
    #"hmq1725" = "" #hmq1725
    "keccak" = ",d=2048 -i 20" #Keccak
    "lbry" = " --api-remote" #Lbry
    "lyra2v2" = " -i 20 --api-remote" #Lyra2RE2
    #"lyra2z" = "" #Lyra2z
    #"myr-gr" = " --api-remote" #MyriadGroestl
    #"neoscrypt" = " -i 15 -d $SelGPUCC" #NeoScrypt
    "nist5" = " --api-remote" #Nist5
    #"pascal" = "" #Pascal
    #"qubit" = "" #Qubit
    #"scrypt" = "" #Scrypt
    #"sia" = "" #Sia
    #"sib" = " -i 21 --api-remote" #Sib
    "skein" = " --api-remote" #Skein
    #"timetravel" = "" #Timetravel
    "c11" = " -i 21 --api-remote" #C11
    #"x11evo" = "" #X11evo
    "x11gost" = " -i 21 --api-remote" #X11gost
    #"x17" = " -i 20 --api-remote" #X17
    #"yescrypt" = "" #Yescrypt
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
