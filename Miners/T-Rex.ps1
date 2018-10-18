$Path = '.\Bin\NVIDIA-TRex\t-rex.exe'
$Uri = 'ftp://radio.r41.ru/t-rex-0.7.0-win-cuda10.0.zip'


$Commands = [PSCustomObject]@{
	"balloon" = " -i 12" #Balloon(fastest)
	"bcd" = " " #BitcoinDiamond
	"bitcore" = " -i 21" #Bitcore(Fastest)
	"c11" = " -i 21" #C11(fastest)
	"hmq1725" = " -i 21"
	"polytimos" = " -i 21" #Poly(fastest)
	"skunk" = " -i 21" #Skunk(fastest)
	"hsr" = " -i 21" #Hsr(Testing)
	"tribus" = " -i 21" #Tribus(CryptoDredge faster)
	"x17" = " -i 21" #X17(fastest)
	"x16s" = " -i 21" #X16s(fastest)
	"x16r" = " -i 21" #X16r(fastest)
	"sonoa" = " -i 21" #SonoA(fastest)
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = " -b $($Variables.NVIDIAMinerAPITCPPort) -d $($Config.SelGPUCC) -a $_ -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Week * .99} # substract 1% devfee
        API = "Ccminer"
        Port = $Variables.NVIDIAMinerAPITCPPort
        Wrap = $false
        URI = $Uri
        User = $Pools.(Get-Algorithm($_)).User
    }
}
