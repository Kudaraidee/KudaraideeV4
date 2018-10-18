$Path = '.\Bin\NVIDIA-Yescrypt\ccminer.exe'
$Uri = 'https://github.com/nemosminer/ccminerKlausT-r11-fix/releases/download/r11-fix/ccminerKlausTr11.7z'

$Commands = [PSCustomObject]@{
 
	"skein" = " -d $($Config.SelGPUCC)" #Skein
	"yescryptR8" = " -d $($Config.SelGPUCC)"
    "yescryptR16" = " -d $($Config.SelGPUCC)" #YescryptR16 #Yenten
    "yescryptR32" = " -d $($Config.SelGPUCC)" #YescryptR32 
    "yescryptR16v2" = " -d $($Config.SelGPUCC)" #PPN

}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = "-b $($Variables.NVIDIAMinerAPITCPPort) -a $_ -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Live}
        API = "Ccminer"
        Port = $Variables.NVIDIAMinerAPITCPPort
        Wrap = $false
        URI = $Uri
		User = $Pools.(Get-Algorithm($_)).User
    }
}
