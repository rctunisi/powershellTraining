## assinando scripts

#obtendo certificado para assinatura de scripts OBS: cert auto-assinado
$cert = get-childitem Certs:\ -recurse –CodeSigningCert

#assinando scripts
Set-AuthenticodeSignature -Certificate $cert -FilePath <CAMINHO_DO_SCRIPT>

