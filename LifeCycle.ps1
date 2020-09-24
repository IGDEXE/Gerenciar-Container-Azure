# Instala modulo
Install-Module Az.Storage -Confirm:$false -Force -AllowClobber
Import-Module Az.Storage -Force

# Configuracoes
$data = Get-Date -Format ddMMyyyy-hhmm
$nome = "container-$data"
$contaStorage = ""
$chaveStorage = ''

try {
    # Conecta no Azure
    $contexto = New-AzStorageContext -StorageAccountName "$contaStorage" -StorageAccountKey $chaveStorage
    # Cria o container novo
    Write-Host "Criando Container: $nome"
    New-AzStorageContainer -Name "$nome" -Context $contexto 
    # Remove o mais antigo
    $containerAntigo = Get-AzStorageContainer -Name container* -Context $contexto
    $containerAntigo = $containerAntigo[0].Name
    Write-Host "Removendo o container: $containerAntigo"
    Remove-AzStorageContainer -Name "$containerAntigo" -Context $contexto 

}
catch {
    # Mostra mensagem de erro
    Write-Host "Erro ao fazer o procedimento"
    Write-Host "Erro: $_.Exception.Message"
}