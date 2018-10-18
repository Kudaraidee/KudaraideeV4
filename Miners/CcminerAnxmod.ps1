$Path = '.\Bin\NVIDIA-Anxmod\ccminer.exe'
$Uri = 'https://github.com/216k155/ccminer-phi-anxmod/releases/download/ccminer%2Fphi-1.0/ccminer-phi-1.0.zip'

$Commands = [PSCustomObject]@{
    "Phi" = " -i 20 --api-remote" #Phi
    
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
