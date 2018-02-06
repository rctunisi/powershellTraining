## assinando scripts

#obtendo certificado para assinatura de scripts OBS: cert auto-assinado
$cert = get-childitem Certs:\ -recurse –CodeSigningCert

#assinando scripts
Set-AuthenticodeSignature -Certificate $cert -FilePath <CAMINHO_DO_SCRIPT>

## supportShouldProcess
Function Kill-Process{
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Medium')]
    Param(
        [String]$ProcessName
    )
    PROCESS{
        $p = Get-Process -Name $ProcessName
        #funcao para suportar acao do WHATIF e CONFIRM
        if($PSCmdlet.ShouldProcess($ProcessName,"Terminate process")){
            $p.kill()
        }
    }
}

## opcoes de parametros
Function Kill-Process{
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Medium')]
    Param(
        [ValidateNotNullOrEmpty()] #nao permite nulo nem vazio
        [ValidateScript({if( (Get-Process -name $_) -ne $null){ $true } else { throw "Processo nao esta em execução"}})] #Script para validar o parametro.. no caso verifica se o processo esta em execucao
        [parameter(Mandatory=$true)] #obrigatoriedade
        [String]$ProcessName
    )
    PROCESS{
        $p = Get-Process -Name $ProcessName
        #funcao para suportar acao do WHATIF e CONFIRM
        if($PSCmdlet.ShouldProcess($ProcessName,"Terminate process")){
            $p.kill()
        }
    }
}

#concatenacao com sub-expression

$var = "World"
$var2 = "Hello $($var)"
Write-host $var2