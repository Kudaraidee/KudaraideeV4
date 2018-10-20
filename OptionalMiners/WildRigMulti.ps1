if (!(IsLoaded(".\Include.ps1"))) {. .\Include.ps1; RegisterLoaded(".\Include.ps1")}

$Path = '.\Bin\AMD-WildRigMulti\wildrig.exe'
$Uri = 'https://github.com/andru-kun/wildrig-multi/releases/download/0.12.1/wildrig-multi-0.12.1.1-beta.7z'

$Commands = [PSCustomObject]@{
    bcd = '' #BitcoinDiamond
    bitcore = '' #Bitcore
	c11 = '' #C11
	geek = '' #GeekCash
	hex = '' #XDNA
	hmq1725 = '' #Hmq1725
	phi = '' #Phi
	renesis = '' #renesis
	sonoa = '' #sonoa
	timetravel = '' #timetravel
	timetravel10 = '' #Bitcore
	tribus = '' #Tribus
	x16r = '' #x16r
	x16s = '' #x16s
	x17 = '' #x17
	x22i = '' #x22i
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type = "AMD"
        Path = $Path
        Arguments = "--api-port=$($Variables.AMDMinerAPITCPPort) --algo $_ --url=$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) --user=$($Pools.(Get-Algorithm($_)).User) --pass=$($Pools.(Get-Algorithm($_)).Pass) $($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Live}
        API = "Xmrig"
        Port = $Variables.AMDMinerAPITCPPort
        Wrap = $false
        URI = $Uri
		User = $Pools.(Get-Algorithm($_)).User
    }
}