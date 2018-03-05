. .\Include.ps1

try
{
    $phiphipoolCoins_Request = Invoke-RestMethod "http://www.phi-phi-pool.com/api/wallet?address=$Wallet" -UseBasicParsing -TimeoutSec 20 -ErrorAction Stop
    $phiphipool_Request = Invoke-WebRequest -Uri "http://phi-phi-pool.com/api/status" -UseBasicParsing | ConvertFrom-Json
}
catch
{
    return
}

if(-not $phiphipool_Request){return}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Location = "asia"

$phiphipool_Request | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | foreach {
    $phiphipool_Host = "pool1.phi-phi-pool.com"
    $phiphipool_Port = $phiphipool_Request.$_.port
    $phiphipool_Algorithm = Get-Algorithm $phiphipool_Request.$_.name
    $phiphipool_Coin = $phiphipool_Request.$_.coins
    $phiphipool_Fees = $phiphipool_Request.$_.fees
    $phiphipool_Workers = $phiphipool_Request.$_.workers
    $phiphipool_Hashrate = $phiphipool_Request.$_.hashrate
    $phiphipool_Balance = $phiphipoolCoins_Request.$_.balance
    $phiphipool_Unpaid = $phiphipoolCoins_Request.$_.unpaid
    $phiphipool_Total = $phiphipoolCoins_Request.$_.total

    $Divisor = 1000000
	
    switch($phiphipool_Algorithm)
    {
        "sha256"{$Divisor *= 1000000}
        "sha256t"{$Divisor *= 1000000}
        "blake"{$Divisor *= 1000}
        "blake2s"{$Divisor *= 1000}
        "blakecoin"{$Divisor *= 1000}
        "decred"{$Divisor *= 1000}
        "keccak"{$Divisor *= 1000}
        "keccakc"{$Divisor *= 1000}
        "lbry"{$Divisor *= 1000}
        "myr-gr"{$Divisor *= 1000}
        "quark"{$Divisor *= 1000}
        "qubit"{$Divisor *= 1000}
        "vanilla"{$Divisor *= 1000}
        "x11"{$Divisor *= 1000}
        "equihash"{$Divisor /= 1000}
        "yescrypt"{$Divisor /= 1000}
    }

    if((Get-Stat -Name "$($Name)_$($phiphipool_Algorithm)_Profit") -eq $null){$Stat = Set-Stat -Name "$($Name)_$($phiphipool_Algorithm)_Profit" -Value ([Double]$phiphipool_Request.$_.estimate_last24h/$Divisor)}
    else{$Stat = Set-Stat -Name "$($Name)_$($phiphipool_Algorithm)_Profit" -Value ([Double]$phiphipool_Request.$_.estimate_current/$Divisor)}
	
    if($Wallet)
    {
        [PSCustomObject]@{
            Algorithm = $phiphipool_Algorithm
            Info = $phiphipool_Coin
            Price = $Stat.Live
            StablePrice = $Stat.Week
            PoolHashrate = $phiphipool_Hashrate
            MarginOfError = $Stat.Fluctuation
            Workers = "$phiphipool_Workers"
            Protocol = "stratum+tcp"
            Host = $phiphipool_Host
            Port = $phiphipool_Port
            User = "$Wallet.$Workername"
            Pass = "c=BTC"
            Balance = "$phiphipool_Balance"
            Unpaid = "$phiphipool_Unpaid"
            Total = "$phiphipool_Total"
            Location = $Location
            SSL = $false
        }
    }
}
