. .\Include.ps1

try {
    $PhiPhiPool_Request = Invoke-WebRequest "http://www.phi-phi-pool.com/api/status" -UseBasicParsing -Headers @{"Cache-Control" = "no-cache"} | ConvertFrom-Json 
}
catch { return }

if (-not $PhiPhiPool_Request) {return}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Location = "ASIA"

$PhiPhiPool_Request | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
    $PhiPhiPool_Host = "pool1.phi-phi-pool.com"
    $PhiPhiPool_Port = $PhiPhiPool_Request.$_.port
    $PhiPhiPool_Algorithm = Get-Algorithm $PhiPhiPool_Request.$_.name
    $PhiPhiPool_Coin = ""

    $Divisor = 1000000000
	
    switch ($PhiPhiPool_Algorithm) {
        "equihash" {$Divisor /= 1000}
        "blake2s" {$Divisor *= 1000}
        "blakecoin" {$Divisor *= 1000}
        "decred" {$Divisor *= 1000}
        "keccak" {$Divisor *= 1000}
	"keccakc" {$Divisor *= 1000}
    }

    if ((Get-Stat -Name "$($Name)_$($PhiPhiPool_Algorithm)_Profit") -eq $null) {$Stat = Set-Stat -Name "$($Name)_$($PhiPhiPool_Algorithm)_Profit" -Value ([Double]$PhiPhiPool_Request.$_.actual_last24h / $Divisor * (1 - ($PhiPhiPool_Request.$_.fees / 100)))}
    else {$Stat = Set-Stat -Name "$($Name)_$($PhiPhiPool_Algorithm)_Profit" -Value ([Double]$PhiPhiPool_Request.$_.actual_last24h / $Divisor * (1 - ($PhiPhiPool_Request.$_.fees / 100)))}
	
    if ($Wallet) {
        [PSCustomObject]@{
            Algorithm     = $PhiPhiPool_Algorithm
            Info          = $PhiPhiPool_Coin
            Price         = $Stat.Live
            StablePrice   = $Stat.Week
            MarginOfError = $Stat.Week_Fluctuation
            Protocol      = "stratum+tcp"
            Host          = $PhiPhiPool_Host
            Port          = $PhiPhiPool_Port
            User          = "$Wallet.$WorkerName"
            Pass          = "c=$Passwordcurrency"
            Location      = $Location
            SSL           = $false
        }
    }
}
