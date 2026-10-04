# Pokémon Infinite Fusion 2 (Hoenn) — Tradução PT-BR

Tradução fanmade para **Português do Brasil** do **Pokémon Infinite Fusion 2: Hoenn**.

| | |
|---|---|
| **Versão da tradução** | 1.1.0 |
| **Versão do jogo** | Infinite Fusion: Hoenn **1.2.2** (base 6.8.2) |
| **Plataformas** | Windows, Linux, Steam Deck, macOS (Wine) |
| **Status** | Versão para testes públicos — reporte problemas! |

> **Importante:** este é um projeto **não oficial**, feito por fã. Não é afiliado, aprovado nem endossado pelos desenvolvedores do Pokémon Infinite Fusion, Nintendo, Game Freak ou The Pokémon Company.
>
> **Sem garantia:** a tradução é oferecida como está, sem garantia de suporte ou de atualizações. Problemas podem ser reportados nas [issues](../../issues), mas não há prazo para correção.
>
> **Este repositório não inclui o jogo.** Baixe o Pokémon Infinite Fusion 2 **somente pelo Discord oficial** ([discord.gg/infinitefusion](https://discord.gg/infinitefusion)). Não baixe o jogo de sites aleatórios, vídeos "completo em português" ou reuploads: já foram relatados downloads falsos com malware.

---

## O que foi traduzido

| Traduzido | Mantido em inglês (de propósito) |
|---|---|
| Todos os diálogos da história, NPCs e missões (3.728 falas) | Nomes de Pokémon |
| Falas dos treinadores antes e depois das batalhas (1.004) | Nomes de golpes |
| Placas, TVs, reportagens, PokéChallenges, Bases Secretas, Concursos | Nomes de itens, habilidades e fitas |
| Menus, mensagens de batalha, bolsa, PC, loja, resumo do Pokémon | Nomes de lugares e personagens |
| Pokédex completa: categorias e descrições, inclusive dos Pokémon de Hoenn | Team Aqua, Team Magma, Gym Leader, Badge, Pokémon Center |
| Descrições de itens, golpes, habilidades e fitas | Textos desenhados em imagens |
| Descrições de roupas, chapéus e cabelos | |

Ainda em inglês (trabalho futuro):

- Alguns rótulos curtos de interface.
- Algumas opções do menu de configurações e links da comunidade (ex.: *"Rival's nickname?"*, faixas de BST do modo aleatório).

---

## Instalação

### Antes de começar

1. Tenha o **Pokémon Infinite Fusion 2 (Hoenn) 1.2.2** instalado, baixado do Discord oficial.
2. **Feche o jogo.**
3. (Recomendado) Faça uma cópia da sua pasta de saves: `%APPDATA%\infinitefusion` no Windows.
4. Baixe o arquivo **`InfiniteFusion2-PTBR-v1.1.0.zip`** na página de [**Releases**](../../releases).

> O instalador confere a versão do jogo. Se o seu jogo for de outra versão, ele **não instala nada** e avisa, para não quebrar o jogo.

### Windows

1. Extraia o `.zip` em qualquer lugar (por exemplo, na Área de Trabalho).
2. Dê dois cliques em **`Instalar (Windows).bat`**.
3. Na janela que abrir, escolha a **pasta do jogo** — a que tem o `InfiniteFusion2.exe`.
   - Dica: se você extrair o `.zip` **dentro** da pasta do jogo, o instalador encontra a pasta sozinho.
4. Espere a mensagem verde **"Tradução PT-BR instalada!"** e aperte qualquer tecla.

Se o Windows mostrar o aviso *"O Windows protegeu o computador"* (SmartScreen), clique em **Mais informações → Executar assim mesmo**. O instalador é só um script de texto (`instalar.ps1`) que você pode abrir e ler antes de rodar.

### Linux / Steam Deck / macOS

1. Extraia o `.zip`.
2. Abra um terminal na pasta extraída e rode:

   ```bash
   ./instalar.sh "/caminho/para/InfiniteFusion2"
   ```

   Sem o caminho, o script pergunta (você pode arrastar a pasta para o terminal).

### Instalação manual (qualquer sistema)

1. Faça backup da pasta `Data` do jogo.
2. Copie **todo o conteúdo** da pasta `payload/` do `.zip` para dentro da pasta do jogo, aceitando substituir os arquivos.

---

## Ativando o Português no jogo

- **Save novo:** o jogo pergunta o idioma no começo — escolha **Português**.
- **Save existente:** na tela de carregar o jogo, escolha **Language → Português**.

O idioma fica salvo no seu save. Saves antigos continuam no idioma em que estavam até você trocar.

---

## Desinstalação

- **Windows:** dê dois cliques em **`Desinstalar (Windows).bat`** e escolha a pasta do jogo.
- **Linux / Steam Deck / macOS:** `./instalar.sh --desinstalar "/caminho/para/InfiniteFusion2"`

O instalador guarda os arquivos originais em `PTBR_BACKUPS/original-if2-ptbr` (dentro da pasta do jogo) e os restaura na desinstalação.

> Antes de desinstalar, se o seu save estiver em Português, troque para **Language → English** na tela de carregar.

---

## Atualizações do jogo

O botão **Update** do launcher oficial e o `INSTALL_OR_UPDATE.bat` **substituem os arquivos traduzidos** pelos originais em inglês. Depois de atualizar o jogo:

- se a versão continuar a mesma (1.2.2), é só rodar o instalador da tradução de novo;
- se a versão mudar, espere uma versão nova da tradução — o instalador vai recusar instalar numa versão diferente para não quebrar o jogo.

---

## Problemas conhecidos / perguntas frequentes

**O jogo continua em inglês.** Confira se escolheu **Language → Português** na tela de carregar. Se a opção não aparece, a tradução não foi instalada na pasta certa (a que tem `InfiniteFusion2.exe`).

**Apareceu um erro de script ao abrir o jogo.** Desinstale a tradução e confira a versão do jogo. Abra uma [issue](../../issues) com uma captura de tela do erro.

**Algumas frases continuam em inglês.** Algumas estão listadas acima como trabalho futuro. Se encontrar outra, abra uma issue com captura de tela e o nome do lugar.

**Achei um erro de tradução.** Abra uma issue ou um pull request editando as tabelas em [`traducao/`](traducao/) (veja abaixo).

---

## Como contribuir

Todas as traduções ficam em tabelas de texto fáceis de revisar:

| Arquivo | Conteúdo |
|---|---|
| [`traducao/dialogos.tsv`](traducao/dialogos.tsv) | Falas dos mapas e eventos (`ingles`, `portugues`, `origem`) |
| [`traducao/treinadores_e_scripts.tsv`](traducao/treinadores_e_scripts.tsv) | Falas de treinadores e textos de scripts |

Regras:

- Não altere a coluna `ingles`.
- Mantenha **exatamente** os códigos de controle: `\PN` (nome do jogador), `\C[1]`…`\C[0]` (cores), `\V[1]` (variáveis), `\wt[10]`/`\wtnp[30]` (pausas), `{1}`, `<br>`, `<HEAD_POKEMON>` etc.
- `⏎` representa uma quebra de linha.
- Nomes de Pokémon, golpes, itens, lugares e personagens ficam em inglês.

Para gerar o `portuguese.dat` a partir das tabelas:

```bash
pip install rubymarshal
python ferramentas/gerar_dat.py          # grava em payload/Data/portuguese.dat
```

O script confere os códigos de controle de cada linha e para se encontrar algum erro. Mais detalhes em [`ferramentas/README.md`](ferramentas/README.md).

---

## Créditos

- **Pokémon Infinite Fusion / Infinite Fusion 2** — criadores e contribuidores do jogo. Todo o crédito do jogo é deles.
- **Tradução PT-BR do Infinite Fusion (Kanto)** — [ExtremestoneGG/infinite-fusion-ptbr](https://github.com/ExtremestoneGG/infinite-fusion-ptbr). Este projeto usa como base o `portuguese.dat` e os textos traduzidos dos scripts desse projeto, adaptados para a versão 6.8.2 / Hoenn.
- **Tradução dos diálogos de Hoenn, adaptação e instaladores** — este repositório. A tradução foi feita com auxílio de IA; revisões humanas da comunidade são muito bem-vindas.

Veja também [`AVISO.md`](AVISO.md).
