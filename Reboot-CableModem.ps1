function Restart-CableModem {
    <#
    .SYNOPSIS
    Restarts Arris cable modem is failed url percentange reaches a certain threshold.
    
    .DESCRIPTION
    Restarts Arris cable modem is failed url percentange reaches a certain threshold.
    
    .PARAMETER UrlPercentRestartThreshold
    Threshold percentage at which the script will attempt to restart the modem.
    
    .EXAMPLE
    Restart-CableModem -UrlPercentRestartThreshold 100
    
    .NOTES
    General notes
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$false,Position=0)]
        [int]$UrlPercentRestartThreshold
    )    

    $testurls = "www.twitter.com","www.ibm.com", "gmail.com", "yahoo.com", "profootballtalk.com"
    $uri = "http://192.168.100.1/reset.htm?reset_modem=Restart+Cable+Modem"
    $stats = 0
    
        foreach ($url in $testurls){
            try {
                if ((Invoke-WebRequest -Uri $url).statuscode -eq "200"){
                    Write-Host "Success $url"
                    $stats+=$stats.count
                }
            }
            catch {
                Write-Host "Failure $url"
            }
        }

    $urlsuccess = [int]($stats/$($testurls.count)*100) -f {0:2}

    if ($urlsuccess -le $UrlPercentRestartThreshold) {
        Invoke-WebRequest -Uri $uri
    }
}