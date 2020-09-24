# Instala modulo
Install-Module Azure.Storage -Confirm:$false -Force -AllowClobber
Import-Module Azure.Storage -Force

# Configuracoes
$data = Get-Date -Format ddMMyyyy-hhmm
$prefixo = ""
$nome = "$prefixo-$data"
$contaStorage = ""
$chaveStorage = ''
[int]$indice = 0

try {
    # Conecta no Azure
    $contexto = New-AzureStorageContext -StorageAccountName "$contaStorage" -StorageAccountKey $chaveStorage
    # Cria o container novo
    Write-Host "Criando Container: $nome"
    New-AzureStorageContainer -Name "$nome" -Context $contexto
    # Calcula um indice para remover o 2 mais antigo
    $containerAntigo = Get-AzureStorageContainer -Name "$prefixo*" -Context $contexto
    $totalContainers = $containerAntigo.count
    [int]$indice = $totalContainers - 2
    # Remove o mais antigo
    if ($indice -ge 0) {
        $containerAntigo = $containerAntigo[$indice].Name
        Write-Host "Removendo o container: $containerAntigo"
        Remove-AzureStorageContainer -Name "$containerAntigo" -Context $contexto
    } else {
        Write-Host "Nao existem containers suficientes para uma remocao"
    }
}
catch {
    # Mostra mensagem de erro
    Write-Host "Erro ao fazer o procedimento"
    Write-Host "Erro: $_.Exception.Message"
}