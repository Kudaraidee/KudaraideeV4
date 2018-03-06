. .\Include.ps1

try
{
    $AHashPoolCoins_Request = Invoke-RestMethod "http://www.ahashpool.com/api/wallet?address=$Wallet" -UseBasicParsing -TimeoutSec 20 -ErrorAction Stop
    $AHashPool_Request = Invoke-WebRequest -Uri "http://www.ahashpool.com/api/status" -UseBasicParsing | ConvertFrom-Json
}
catch
{
    return
}

if(-not $AHashPool_Request){return}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Location = "asia"

$AHashPool_Request | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | foreach {
    $AHashPool_Host = "$_.mine.ahashpool.com"
    $AHashPool_Port = $AHashPool_Request.$_.port
    $AHashPool_Algorithm = Get-Algorithm $AHashPool_Request.$_.name
    $AHashPool_Coin = $AHashPool_Request.$_.coins
    $AHashPool_Fees = $AHashPool_Request.$_.fees
    $AHashPool_Workers = $AHashPool_Request.$_.workers
    $AHashPool_Hashrate = $AHashPool_Request.$_.hashrate
    $AHashPool_Balance = $AHashPoolCoins_Request.$_.balance
    $AHashPool_Unpaid = $AHashPoolCoins_Request.$_.unpaid
    $AHashPool_Total = $AHashPoolCoins_Request.$_.total

    $Divisor = 1000000
	
    switch($AHashPool_Algorithm)
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

    if((Get-Stat -Name "$($Name)_$($AHashPool_Algorithm)_Profit") -eq $null){$Stat = Set-Stat -Name "$($Name)_$($AHashPool_Algorithm)_Profit" -Value ([Double]$AHashPool_Request.$_.estimate_last24h/$Divisor)}
    else{$Stat = Set-Stat -Name "$($Name)_$($AHashPool_Algorithm)_Profit" -Value ([Double]$AHashPool_Request.$_.estimate_current/$Divisor)}
	
    if($Wallet)
    {
        [PSCustomObject]@{
            Algorithm = $AHashPool_Algorithm
            Info = $AHashPool_Coin
            Price = $Stat.Live
            StablePrice = $Stat.Week
            PoolHashrate = $AHashPool_Hashrate
            PoolFees = $AHashPool_Fees
            MarginOfError = $Stat.Fluctuation
            Workers = "$AHashPool_Workers"
            Protocol = "stratum+tcp"
            Host = $AHashPool_Host
            Port = $AHashPool_Port
            User = "$Wallet.$Workername"
            Pass = "ID=$Workername,c=BTC"
            Balance = "$AHashPool_Balance"
            Unpaid = "$AHashPool_Unpaid"
            Total = "$AHashPool_Total"
            Location = $Location
            SSL = $false
        }
    }
}
