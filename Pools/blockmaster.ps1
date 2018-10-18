. .\Include.ps1

try {
    $blockmaster_Request = Invoke-WebRequest "http://blockmasters.co/api/status" -UseBasicParsing -Headers @{"Cache-Control" = "no-cache"} | ConvertFrom-Json 
}
catch { return }

if (-not $blockmaster_Request) {return}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Locations = "US", "Europe"

$Locations | ForEach {
    $Location = $_

    $blockmaster_Request | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | foreach {
        $blockmaster_Host = "blockmasters.co"
        $blockmaster_Port = $blockmaster_Request.$_.port
        $blockmaster_Algorithm = Get-Algorithm $blockmaster_Request.$_.name
        $blockmaster_Coin = ""
	$PwdCurr = if ($PoolConf.PwdCurrency) {$PoolConf.PwdCurrency}else {$Config.Passwordcurrency}
        
        $Divisor = 1000000

        switch ($blockmaster_Algorithm) {
            "balloon" {$Divisor /= 1000}
            "blake2s" {$Divisor *= 1000}
            "blakecoin" {$Divisor *= 1000}
            "decred" {$Divisor *= 1000}
            "equihash" {$Divisor /= 1000}
            "equihash144" {$Divisor /= 1000}
            "equihash192" {$Divisor /= 1000}
            "hex" {$Divisor *= 1000}
            "keccak" {$Divisor *= 1000}
            "keccakc" {$Divisor *= 1000}
        }

        if ((Get-Stat -Name "$($Name)_$($blockmaster_Algorithm)_Profit") -eq $null) {$Stat = Set-Stat -Name "$($Name)_$($blockmaster_Algorithm)_Profit" -Value ([Double]$blockmaster_Request.$_.estimate_last24h / $Divisor)}
        else {$Stat = Set-Stat -Name "$($Name)_$($blockmaster_Algorithm)_Profit" -Value ([Double]$blockmaster_Request.$_.estimate_current / $Divisor)}

        $ConfName = if ($Config.PoolsConfig.$Name -ne $Null) {$Name}else {"default"}
	
        if ($Config.PoolsConfig.default.Wallet) {
            [PSCustomObject]@{
                Algorithm     = $blockmaster_Algorithm
                Info          = $zergpool
                Price         = $Stat.Live * $Config.PoolsConfig.$ConfName.PricePenaltyFactor
                StablePrice   = $Stat.Week
                MarginOfError = $Stat.Fluctuation
                Protocol      = "stratum+tcp"
                Host          = $blockmaster_Host
                Port          = $blockmaster_Port
                User          = $Config.PoolsConfig.$ConfName.Wallet
                Pass          = "$($Config.PoolsConfig.$ConfName.WorkerName),c=$($PwdCurr)"
                Location      = $Location
                SSL           = $false
            }
        }
    }
}
