
##############################
#.SYNOPSIS
# Test-port com range como parametro simples
#
#.DESCRIPTION
#Long description
#
#.PARAMETER ComputerName
#Parameter description
#
#.PARAMETER TcpPort
#Parameter description
#
#.PARAMETER MsTimeOut
#Parameter description
#
#.PARAMETER Progress
#Parameter description
#
#.EXAMPLE
#An example
#
#.NOTES
#General notes
###############################
function Test-Port {
[cmdletBinding()]
Param(
    [ValidateScript({
        if(Test-Connection $_ -count 1 -Quiet){$true} else {throw "Server is not responding"}
    })]
    [string]$ComputerName,
    [int[]]$TcpPort,
    [int]$MsTimeOut = 100,
    [switch]$Progress
)
PROCESS {

    $count = 0
    $output = @()
    $TcpPort | ForEach-Object { 
        if ($Progress) { 
            Write-Progress -Activity "Connecting to $ComputerName" ` -Status "Progress: $([int]($count/$TcpPort.count * 100))%" ` -PercentComplete $($count/$TcpPort.count * 100) 
            $count++ 
        }
        $tcpClient = New-Object System.Net.Sockets.TcpClient
        $connection = $tcpClient.BeginConnect($ComputerName,$_,$null,$null)
        $asyncResult = $connection.AsyncWaitHandle.WaitOne($MsTimeOut,$false)
        
        $item = "" | Select-Object ComputerName,Port,isOpen
        $item.ComputerName = $ComputerName
        $item.Port = $_
        $item.isOpen = $asyncResult
        
        $output += $item
    }

    $output
}
}

##############################
#.SYNOPSIS
# Test-Port com parametro dinamico
# adicionado parametersetname para ocultar parametros em diferentes modos de execucao
#
#.DESCRIPTION
#Long description
#
#.EXAMPLE
#An example
#
#.NOTES
#General notes
##############################
function Test-PortAdv {
    [cmdletBinding()]
    Param(
        [ValidateScript({
            if(Test-Connection $_ -count 1 -Quiet){$true} else {throw "Server is not responding"}
        })]
        [ValidateNotNull()]
        [ValidateLength(2,50)]
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias("Name")]
        [Alias("DNSHostName")]
        [string]$ComputerName,
        
        [Parameter(Mandatory,ParameterSetName=”NoRange”)]
        [ValidateRange(1,65535)]
        [int[]]$TcpPort,
        
        [Parameter(ParameterSetName=”NoRange”)]
        [Parameter(ParameterSetName=”Range”)]
        [ValidateRange(100,10000)]
        [int]$MsTimeOut = 100,
        
        [Parameter(ParameterSetName=”Range”)]
        [switch]$Range,

        [switch]$Progress
        
    )
    
        DynamicParam{
            if ($Range) { 
                $attributes = new-object System.Management.Automation.ParameterAttribute 
                $attributes.ParameterSetName = "Range"
                $attributes.Mandatory = $true 
                $attributes.HelpMessage = "StartPort and EndPort parameters appear if -Range switch parameter is specified" 
                $attributeCollection = New-Object -TypeName System.Collections.ObjectModel.Collection[System.Attribute] 
                $attributeCollection.Add($attributes) 
                $startPort = new-object -TypeName System.Management.Automation.RuntimeDefinedParameter("StartPort", [int], $attributeCollection) 
                $endPort = new-object -TypeName System.Management.Automation.RuntimeDefinedParameter("EndPort", [int], $attributeCollection) 
                $paramDictionary = new-object -TypeName System.Management.Automation.RuntimeDefinedParameterDictionary 
                $paramDictionary.Add("StartPort", $startPort) 
                $paramDictionary.Add("EndPort", $endPort) 
                return $paramDictionary 
            } 
        }
        PROCESS {
    
        $count = 0
        $output = @()
        if($Range){
            for($i=$StartPort.value;$i -lt $EndPort.value;$i++){
                if ($Progress) { 
                    Write-Progress -Activity "Connecting to $ComputerName" ` -Status "Progress: $([int]($count/($endPort.value - $startPort.value) * 100))%" ` -PercentComplete $($count/($endport.value - $startport.value) * 100) 
                    $count++ 
                }
                $tcpClient = New-Object System.Net.Sockets.TcpClient
                $connection = $tcpClient.BeginConnect($ComputerName,$i,$null,$null)
                $asyncResult = $connection.AsyncWaitHandle.WaitOne($MsTimeOut,$false)
                
                $item = "" | Select-Object ComputerName,Port,isOpen
                $item.ComputerName = $ComputerName
                $item.Port = $i
                $item.isOpen = $asyncResult
                $output += $item
            }

        } else {
            $TcpPort | ForEach-Object { 
                if ($Progress) { 
                    Write-Progress -Activity "Connecting to $ComputerName" ` -Status "Progress: $([int]($count/$TcpPort.count * 100))%" ` -PercentComplete $($count/$TcpPort.count * 100) 
                    $count++ 
                }
                $tcpClient = New-Object System.Net.Sockets.TcpClient
                $connection = $tcpClient.BeginConnect($ComputerName,$_,$null,$null)
                $asyncResult = $connection.AsyncWaitHandle.WaitOne($MsTimeOut,$false)
                
                $item = "" | Select-Object ComputerName,Port,isOpen
                $item.ComputerName = $ComputerName
                $item.Port = $_
                $item.isOpen = $asyncResult
                
                $output += $item
            }
        }

        $output
    }
    }