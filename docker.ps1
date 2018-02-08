function Connect-DockerEndpoint {
[cmdletBinding()]
Param(
    [Parameter(Mandatory)]
    [string]$Uri
)
PROCESS{
    ## test connection to endpoint
    try{
        Invoke-RestMethod -method Get -Uri ($uri + "/containers/json") | Out-Null
        $global:dockerendpoint = $uri
        Write-host "Connected to endpoint $($uri)"
    } catch {
        Write-Error "Could not connect to docker endpoint $($uri): $($_.exception.message)"
        $global:dockerendpoint = ""
    }
}
}

Function Get-DockerContainer{
[CmdletBinding()]
Param(

)
BEGIN{
    if(-not(Test-DockerEndpointconnection)){
        throw "Docker endpoint is invalid $($global:dockerendpoint)"
    }
}
PROCESS{

    $content = Invoke-RestMethod -Method GET -Uri ($global:dockerendpoint + "/containers/json?all=1")
    
    if($content -eq $null){
        Write-host "no containers found on $($global:dockerendpoint)"
    }
    
    $content
}
}

Function Get-DockerImage{
[CmdletBinding()]
Param(

)   
BEGIN{
    if(-not(Test-DockerEndpointconnection)){
        throw "Docker endpoint is invalid $($global:dockerendpoint)"
    }
}
PROCESS{
    $content = Invoke-RestMethod -Method GET -Uri ($global:dockerendpoint + "/images/json?all=1")
    
    if($content -eq $null){
        Write-host "no images found on $($global:dockerendpoint)"
    }
    
    $content
} 
}

Function Test-DockerEndpointconnection{

if(($global:dockerendpoint -ne $null) -or ($global:dockerendpoint -ne "")){
    return $true
} else {
    return $false
}
}

Function Disconnect-DockerEndpoint {
[cmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Medium')]
Param(
    
)
PROCESS{
    $endpoint = $global:dockerendpoint
    if($PSCmdlet.ShouldProcess($endpoint,"Disconnect Session")){
        if(($global:dockerendpoint -eq $null) -or($global:dockerendpoint -eq "")){
            Write-host "Docker endpoint is already disconnected"
        } else {
            $global:dockerendpoint = $null
            write-host "Disconnected from $($endpoint)"
        }
    }
}
}