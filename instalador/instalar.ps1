# Instalador da tradução PT-BR do Pokémon Infinite Fusion 2 (Hoenn) - Windows
#
#   instalar.ps1 [-Pasta <pasta do jogo>]               instala ou atualiza a tradução
#   instalar.ps1 -Desinstalar [-Pasta <pasta do jogo>]  restaura os arquivos originais
#   -Forcar                                             instala mesmo em outra versão do jogo (pode quebrar!)
param(
    [string]$Pasta = "",
    [switch]$Desinstalar,
    [switch]$Forcar
)
$ErrorActionPreference = "Stop"

$VersaoJogo  = "6.8.2"
$VersaoHoenn = "1.2.2"
$BackupNome  = "PTBR_BACKUPS\original-if2-ptbr"

$Aqui = Split-Path -Parent $PSCommandPath
$Payload = Join-Path $Aqui "payload"
if (-not (Test-Path -LiteralPath $Payload)) { $Payload = Join-Path (Split-Path -Parent $Aqui) "payload" }
$Payload = (Resolve-Path -LiteralPath $Payload).Path

function Escolher-Pasta {
    $pai = Split-Path -Parent $Aqui
    if (Test-Path -LiteralPath (Join-Path $pai "InfiniteFusion2.exe")) { return $pai }
    Add-Type -AssemblyName System.Windows.Forms
    $dlg = New-Object System.Windows.Forms.FolderBrowserDialog
    $dlg.Description = "Escolha a pasta do Pokémon Infinite Fusion 2 (a que tem InfiniteFusion2.exe)"
    $dlg.ShowNewFolderButton = $false
    if ($dlg.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) { throw "Cancelado pelo usuário." }
    return $dlg.SelectedPath
}

function Ler-Versao([string]$arquivo, [string]$nome) {
    $m = Select-String -LiteralPath $arquivo -Pattern ($nome + '\s*=\s*"([^"]+)"') | Select-Object -First 1
    if ($m) { return $m.Matches[0].Groups[1].Value } else { return "?" }
}

function Escrever-Linha([string]$arquivo, [string]$texto) {
    [System.IO.File]::AppendAllText($arquivo, $texto + "`n", (New-Object System.Text.UTF8Encoding($false)))
}

try {
    if ([string]::IsNullOrWhiteSpace($Pasta)) { $Pasta = Escolher-Pasta }
    $Jogo = (Resolve-Path -LiteralPath $Pasta).Path
    $Settings = Join-Path $Jogo "Data\Scripts\001_Settings.rb"
    if (-not (Test-Path -LiteralPath $Settings)) {
        throw "'$Jogo' não parece ser a pasta do Infinite Fusion 2 (falta Data\Scripts\001_Settings.rb)."
    }
    $Backup = Join-Path $Jogo $BackupNome
    $Manifesto = Join-Path $Backup "manifesto.txt"

    if ($Desinstalar) {
        if (-not (Test-Path -LiteralPath $Manifesto)) { throw "Nenhum backup da tradução encontrado em $Backup." }
        $n = 0
        foreach ($linha in [System.IO.File]::ReadAllLines($Manifesto)) {
            $partes = $linha.Split("`t", 2)
            if ($partes.Count -lt 2) { continue }
            $rel = $partes[1].Replace("/", [System.IO.Path]::DirectorySeparatorChar)
            $alvo = Join-Path $Jogo $rel
            if ($partes[0] -eq "restaurar") {
                New-Item -ItemType Directory -Force -Path (Split-Path -Parent $alvo) | Out-Null
                Copy-Item -LiteralPath (Join-Path (Join-Path $Backup "arquivos") $rel) -Destination $alvo -Force
                $n++
            } elseif ($partes[0] -eq "apagar") {
                if (Test-Path -LiteralPath $alvo) { Remove-Item -LiteralPath $alvo -Force }
                $n++
            }
        }
        Remove-Item -LiteralPath $Backup -Recurse -Force
        Write-Host "Tradução removida: $n arquivo(s) restaurado(s). O jogo voltou ao inglês." -ForegroundColor Green
        Write-Host "Dica: se um save estava em Português, escolha Language > English na tela de carregar."
        exit 0
    }

    $vJogo = Ler-Versao $Settings "GAME_VERSION_NUMBER"
    $vHoenn = Ler-Versao $Settings "HOENN_VERSION_NUMBER"
    if ($vJogo -ne $VersaoJogo -or $vHoenn -ne $VersaoHoenn) {
        Write-Host "ATENÇÃO: esta tradução é para Hoenn $VersaoHoenn (base $VersaoJogo), mas o seu jogo é Hoenn $vHoenn (base $vJogo)." -ForegroundColor Yellow
        if (-not $Forcar) {
            throw "Instalação cancelada para não quebrar o jogo. Procure uma versão da tradução para a sua versão do jogo."
        }
    }

    $versaoTag = "versao`t$vJogo-$vHoenn"
    if ((Test-Path -LiteralPath $Manifesto) -and -not ([System.IO.File]::ReadAllLines($Manifesto) -contains $versaoTag)) {
        Write-Host "Backup antigo de outra versão do jogo encontrado; ele será substituído."
        Remove-Item -LiteralPath $Backup -Recurse -Force
    }
    New-Item -ItemType Directory -Force -Path (Join-Path $Backup "arquivos") | Out-Null
    if (-not (Test-Path -LiteralPath $Manifesto)) { Escrever-Linha $Manifesto $versaoTag }
    $jaNoBackup = @{}
    foreach ($linha in [System.IO.File]::ReadAllLines($Manifesto)) {
        $p = $linha.Split("`t", 2); if ($p.Count -eq 2) { $jaNoBackup[$p[1]] = $true }
    }

    $copiados = 0
    foreach ($arq in Get-ChildItem -LiteralPath $Payload -Recurse -File) {
        $rel = $arq.FullName.Substring($Payload.Length).TrimStart("\", "/")
        $relManifesto = $rel.Replace([System.IO.Path]::DirectorySeparatorChar, "/")
        $alvo = Join-Path $Jogo $rel
        if (-not $jaNoBackup.ContainsKey($relManifesto)) {
            if (Test-Path -LiteralPath $alvo) {
                $dest = Join-Path (Join-Path $Backup "arquivos") $rel
                New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dest) | Out-Null
                Copy-Item -LiteralPath $alvo -Destination $dest -Force
                Escrever-Linha $Manifesto "restaurar`t$relManifesto"
            } else {
                Escrever-Linha $Manifesto "apagar`t$relManifesto"
            }
        }
        New-Item -ItemType Directory -Force -Path (Split-Path -Parent $alvo) | Out-Null
        Copy-Item -LiteralPath $arq.FullName -Destination $alvo -Force
        $copiados++
    }

    Write-Host "Tradução PT-BR instalada! $copiados arquivo(s) copiado(s)." -ForegroundColor Green
    Write-Host "Backup dos originais: $Backup"
    Write-Host "No jogo: tela de carregar > Language > Português (em save novo o jogo pergunta o idioma)."
} catch {
    Write-Host ("ERRO: " + $_.Exception.Message) -ForegroundColor Red
    exit 1
}
