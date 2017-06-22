function Test-RDPConnection {
    <#
    .SYNOPSIS
    Tests if RDP connection is available.
    
    .DESCRIPTION
    Tests if RDP connection is available.
    
    .PARAMETER Server
    Server
    
    .EXAMPLE
    Test-RDPConnection -Server Server1
    
    .NOTES
    General notes
    #>
    param(
		[Parameter(Position=0,Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$Server
	)

    if(Resolve-DnsName -Name $Server -ErrorAction SilentlyContinue){
        while ((Test-NetConnection -ComputerName $Server -Port 3389).TcpTestSucceeded -ne "true") {
            Write-Output "no connection right now going to sleep for 10 secs..."
            Start-Sleep 10
        }
        $wshell = New-Object -ComObject Wscript.Shell
        $wshell.Popup("$($Server.toupper()) RDP Session available`n`n$(Get-date)",0,"Done ",0x0)
    }
    else{
        Write-Output "Server $($Server.toupper()) doesn't resolve in DNS." -ForegroundColor Yellow
    }
}