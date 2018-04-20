$Path = '.\Bin\NVIDIA-Suprminer\ccminer.exe'
$Uri = 'https://github.com/ocminer/suprminer/releases/download/1.6/suprminer-1.6.7z'


$Commands = [PSCustomObject]@{
    Lyra2z = ' --api-remote --api-allow=0/0'
    #Cryptonight = ' --api-remote --api-allow=0/0'
    #Sia = ''
    #Yescrypt = ''
    #BlakeVanilla = ''
    lyra2v2 = ' -i 19'
    Skein = ''
    Qubit = ''
    #NeoScrypt = ' -i 19'
    MyriadGroestl = ''
    Groestl = ''
    Keccakc = ' '
    #Bitcore = ' --api-remote --api-allow=0/0'
    Blake2s = ' '
    Sib = ''
    X16R = ' '
    X16S = ' '
    X17 = ' '
    Quark = ''
    Hmq1725 = ',d=128  -i 20 --api-remote --api-allow=0/0'
    Veltor = ''
    X11evo = ''
    Timetravel = ' --api-remote --api-allow=0/0'
    Blakecoin = ''
    Lbry = ''
    Jha = ' --api-remote --api-allow=0/0'
    Skunk = ' --api-remote --api-allow=0/0'
    Tribus = ' --api-remote --api-allow=0/0'
    Phi = ' --api-remote --api-allow=0/0'
    Hsr = ' --api-remote --api-allow=0/0'
    
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
