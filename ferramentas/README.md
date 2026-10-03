# Ferramentas

Scripts usados para montar a tradução. Precisam de Python 3 e, os que leem arquivos do jogo, do pacote `rubymarshal` (`pip install rubymarshal`).

| Script | O que faz |
|---|---|
| `gerar_dat.py` | Gera `payload/Data/portuguese.dat` a partir de `portuguese_base.dat` + tabelas em `traducao/`. Confere os códigos de controle de cada linha. |
| `extrair_dialogos.py JOGO DAT SAIDA.json` | Lê os `MapXXX.rxdata` e `CommonEvents.rxdata` do jogo e lista as falas que o `DAT` ainda não traduz. Útil quando sair uma versão nova do jogo. |
| `extrair_descricoes.py JOGO DAT` | Lista as descrições por ID (Pokédex, itens, habilidades, fitas) que o `DAT` ainda não traduz e avisa se o inglês de algum ID de `traducao/descricoes.tsv` mudou no jogo. Grava `descricoes_todo.tsv`. |
| `extrair_treinadores_scripts.py JOGO DAT` | Lista falas de treinadores (`trainers.dat`) e textos `_INTL("...")` dos scripts de Hoenn que o `DAT` ainda não traduz. Grava `extra_todo.json`. |
| `portar_scripts.py ORIGEM JOGO BACKUP [--apply]` | Copia os textos traduzidos dos scripts da tradução do Kanto (6.7.2) para os scripts da 6.8.2, trocando só o texto entre aspas em linhas cujo código é idêntico. Sem `--apply`, só mostra o que mudaria. |

Arquivos de dados:

| Arquivo | Conteúdo |
|---|---|
| `portuguese_base.dat` | `portuguese.dat` da tradução do Kanto (ExtremestoneGG), com as descrições cujo ID mudou em Hoenn removidas (voltam para o inglês). |
| `mapas_dialogos.json` | Em qual mapa aparece cada fala de `traducao/dialogos.tsv` (o jogo procura a tradução por mapa). |

## Como o jogo procura as traduções

O `portuguese.dat` é um `Marshal` do Ruby com 27 seções (veja `MessageTypes` em `Data/Scripts/001_Technical/003_Intl_Messages.rb`):

- **Seção 0:** falas de eventos, um hash `inglês → português` por ID de mapa (o mapa 0 vale para todos).
- **Seções 15/23:** falas de treinadores antes da batalha e de derrota (hash global).
- **Seção 24:** textos `_INTL("...")` dos scripts (hash global).
- **Seções 6/9/11/2/3/26:** descrições de golpes, itens, habilidades, Pokédex (categoria e entrada) e fitas, por **ID numérico**. As traduções novas ou corrigidas ficam em `traducao/descricoes.tsv` (`secao<TAB>id<TAB>ingles<TAB>portugues`); o inglês fica na tabela só para conferência.

A chave é o texto em inglês com espaços normalizados (`Messages.stringToKey`). Se não houver tradução, o jogo usa o texto original, então uma linha faltando nunca quebra o jogo.

## Nova versão do jogo

1. Rode `extrair_dialogos.py`, `extrair_treinadores_scripts.py` e `extrair_descricoes.py` na versão nova para ver o que falta. Corrija ou remova as linhas de `descricoes.tsv` que `extrair_descricoes.py` apontar como mudadas.
2. Traduza as linhas novas nas tabelas de `traducao/` (e atualize `mapas_dialogos.json`).
3. Refaça o payload de scripts com `portar_scripts.py` a partir dos scripts da versão nova. Reaplique as linhas marcadas com `# PT-BR` em `012_Overworld/002_Battle triggering/001_Overworld_BattleStarting.rb` (falas de derrota passadas pelos eventos).
4. Rode `gerar_dat.py` e atualize `VERSAO_JOGO`/`VERSAO_HOENN` nos instaladores.
