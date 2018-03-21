$Path = '.\Bin\NVIDIA-Alexishsr\ccminer-hsr.exe'
$Uri = 'http://ccminer.org/preview/ccminer-hsr-alexis-x86-cuda8.7z'

$Commands = [PSCustomObject]@{
    #Lyra2z = ''#lyra2z
    #Equihash = '' #equihash
    #Sia = ''#sia
    #Yescrypt = ''#yescrypt
    #BlakeVanilla = ''#vanilla
    #Lyra2RE2 = ''#lyra2v2
    #Skein = ''#skein
    #Qubit = ''#qubit
    #NeoScrypt = ''#neoscrypt
    #X11 = ''#x11
    #MyriadGroestl = ''
    #Groestl = ''
    #Keccak = ''
    #Bitcore = ''
    #Blake2s = ''
    #Sib = ''
    X17 = ''
    #Quark = ''
    #Hmq1725 = ''
    #Veltor = ''
    #X11evo = ''
    #Timetravel = ''
    #Blakecoin = ''
    #Lbry = ''
    #C11 = ''
    Nist5 = ''
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
