$Path = '.\Bin\NVIDIA-TPruvot\ccminer.exe'
$Uri = 'https://github.com/tpruvot/ccminer/releases/download/2.2.4-tpruvot/ccminer-x64-2.2.4-cuda9.7z'


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
    Keccakc = ''
    #Bitcore = ' --api-remote --api-allow=0/0'
    Blake2s = ''
    Sib = ''
    X17 = ''
    Quark = ''
    Hmq1725 = ' --api-remote --api-allow=0/0'
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
        Arguments = "-b $($Variables.MinerAPITCPPort) -a $_ -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Live}
        API = "Ccminer"
        Port = $Variables.MinerAPITCPPort #4068
        Wrap = $false
        URI = $Uri
		User = $Pools.(Get-Algorithm($_)).User
    }
}
