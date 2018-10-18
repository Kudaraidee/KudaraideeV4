$Path = ".\Bin\CPU-JayDDee\cpuminer-aes-sse42.exe"
$Uri = "https://github.com/JayDDee/cpuminer-opt/files/1822931/cpuminer-opt-3.8.4-windows.zip"

$Commands = [PSCustomObject]@{
    #"hmq1725" = " --api-remote" #HMQ1725
    #"lyra2z330" = " --api-remote" #Lyra2z330
    #"yescryptr16" = " --api-remote" #YescryptR16
    #"yescrypt" = " --api-remote" #Yescrypt
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type = "CPU"
        Path = $Path
        Arguments = "-b $($Variables.CPUMinerAPITCPPort) -a $_ -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Live}
        API = "Ccminer"
        Port = $Variables.CPUMinerAPITCPPort
        Wrap = $false
        URI = $Uri
	   User = $Pools.(Get-Algorithm($_)).User
    }
}
