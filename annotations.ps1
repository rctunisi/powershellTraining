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

