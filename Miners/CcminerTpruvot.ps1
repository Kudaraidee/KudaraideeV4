$Path = '.\Bin\NVIDIA-TPruvot\ccminer-x64.exe'
$Uri = 'https://github.com/tpruvot/ccminer/releases/download/2.3-tpruvot/ccminer-2.3-cuda9.7z'


$Commands = [PSCustomObject]@{
    Lyra2z = ' '
    #Cryptonight = ' '
    #Sia = ''
    #Yescrypt = ''
    #BlakeVanilla = ''
    lyra2v2 = ' -i 20'
    Skein = ''
    Qubit = ''
    #NeoScrypt = ' -i 20'
    MyriadGroestl = ''
    Groestl = ''
    Keccak = ' -i 20'
    Keccakc = ' -i 20'
    #Bitcore = ' '
    Blake2s = ''
    Sib = ''
    X16R = ' -i 20'
    X16S = ' -i 20'
    X17 = ' -i 20'
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
    Phi = ' -i 20'
    Phi2 = ' -i 20'
    Hsr = ' '
    
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = "-a $_ -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass),stats$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Live}
        API = "Ccminer"
        Port = 4068
        Wrap = $false
        URI = $Uri
		User = $Pools.(Get-Algorithm($_)).User
    }
}
