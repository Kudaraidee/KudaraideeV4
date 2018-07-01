$Path = '.\Bin\NVIDIA-TPruvot\ccminer-x64.exe'
$Uri = 'https://github.com/tpruvot/ccminer/releases/download/2.3-tpruvot/ccminer-2.3-cuda9.7z'


$Commands = [PSCustomObject]@{
    Lyra2z = ' '
    #Cryptonight = ' '
    #Sia = ''
    #Yescrypt = ''
    #BlakeVanilla = ''
    lyra2v2 = ' -i 19'
    Skein = ''
    Qubit = ''
    #NeoScrypt = ' -i 19'
    MyriadGroestl = ''
    Groestl = ''
    Keccak = ',d=1024 '
    Keccakc = ''
    #Bitcore = ' '
    Blake2s = ''
    Sib = ''
    X16R = ' '
    X16S = ' '
    X17 = ''
    Quark = ''
    Hmq1725 = ',d=128 -i 20 '
    Veltor = ''
    X11evo = ''
    Timetravel = ' '
    Blakecoin = ''
    Lbry = ''
    Jha = ' '
    Skunk = ' '
    Tribus = ' '
    Phi = ' '
    Phi2 = ' '
    Hsr = ' '
    
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
