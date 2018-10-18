. .\Include.ps1

$PlusPath = ((split-path -parent (get-item $script:MyInvocation.MyCommand.Path).Directory) + "\BrainPlus\blockmasterplus\blockmasterplus.json")
Try {
$blockmaster_Request = Invoke-WebRequest -Uri "http://blockmasters.co/api/status" -UseBasicParsing | ConvertFrom-Json
}
catch { return }
 
if (-not $blockmaster_Request) {return}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Locations = "ASIA", "US", "Europe"

$Locations | ForEach {
    $Location = $_

    $blockmaster_Request | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | foreach {
        $blockmaster_Host = "blockmasters.co"
        $blockmaster_Port = $blockmaster_Request.$_.port
        $blockmaster_Algorithm = Get-Algorithm $blockmaster_Request.$_.name
        $blockmaster_Coin = ""
        $PwdCurr = if ($PoolConf.PwdCurrency) {$PoolConf.PwdCurrency}else {$Config.Passwordcurrency}
        $Divisor = 1000000000

        switch ($blockmaster_Algorithm) {
                "blake2s" {$Divisor *= 1000}
	        "blakecoin" {$Divisor *= 1000}
        	"decred" {$Divisor *= 1000}
        	"equihash" {$Divisor /= 1000}
        	"keccak" {$Divisor *= 1000}
        	"keccakc" {$Divisor *= 1000}
        }

        if ((Get-Stat -Name "$($Name)_$($blockmaster_Algorithm)_Profit") -eq $null) {$Stat = Set-Stat -Name "$($Name)_$($blockmaster_Algorithm)_Profit" -Value ([Double]$blockmaster_Request.$_.actual_last24h / $Divisor)}
        else {$Stat = Set-Stat -Name "$($Name)_$($blockmaster_Algorithm)_Profit" -Value ([Double]$blockmaster_Request.$_.actual_last24h / $Divisor)}
		
        $ConfName = if ($Config.PoolsConfig.$Name -ne $Null) {$Name}else {"default"}
	
        if ($Config.PoolsConfig.default.Wallet) {
            [PSCustomObject]@{
                Algorithm     = $blockmaster_Algorithm
                Info          = $phiphipool
                Price         = $Stat.Live * $Config.PoolsConfig.$ConfName.PricePenaltyFactor
                StablePrice   = $Stat.Week
                MarginOfError = $Stat.Fluctuation
                Protocol      = "stratum+tcp"
                Host          = $blockmaster_Host
                Port          = $blockmaster_Port
                User          = "$($Config.PoolsConfig.$ConfName.Wallet).$($Config.PoolsConfig.$ConfName.WorkerName)"
                Pass          = "c=$($PwdCurr)"
                Location      = $Location
                SSL           = $false
            }
        }
    }
}