#$creds = Get-Credential

function Get-LoggedOnUser {
    <#
    .SYNOPSIS
    Search for logged on users across one or multiple servers.    
    
    .DESCRIPTION
    Search for logged on users across one or multiple servers.
    
    .PARAMETER User
    Specific user you want to search for.
    
    .PARAMETER Computer
    Computer(s) you want to search.
    
    .EXAMPLE
    (Get-MailboxServer Servers*).Name | Get-LoggedOnUser -User User1 

    .EXAMPLE
    Get-LoggedOnUser -User User1 -Computer Server1
    
    .NOTES
    General notes
    #>
    [CmdletBinding()] 
    Param (  
        [Parameter(Position=0,Mandatory=$false)]
        [string]$User,

        [Parameter(Position=1,Mandatory=$true,ValueFromPipeline=$true)]
        [string[]]$Computer
    ) 

    Begin {}
    Process {
        $data1 = Invoke-Command -ComputerName $Computer -Credential ($creds) -ScriptBlock {  quser | Select-Object -Skip 1 }

        $output = $data1 | Foreach-Object {
            $parts = $_ -split "\s+" 

            if(($_ | select-string "Disc") -ne $null){
                $parts = ($parts[0..1],"",$parts[2..($parts.Length -1)]) -split "\s+"
            }
            New-Object -Type PSObject -Property @{
                    Username = $parts[1]
                    Sessionname = ($parts[2])
                    Id = $parts[3]
                    State = $parts[4]
                    IdleTime = $parts[5]
                    LogonTime= $parts[6] + " " + $parts[7]
                    Computer = $_.PSComputerName
            }
        }
        if ($user){
            $output | Where-Object Username -EQ "$User" | Select-Object Computer, Username, Sessionname, Id, State, IdleTime, LogonTime 
        }
        else {
            $output | Select-Object Computer, Username, Sessionname, Id, State, IdleTime, LogonTime
        }    
    }
    End {}
}