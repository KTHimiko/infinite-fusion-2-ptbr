# Changelog

## 1.1.0 — 2026-10-03

Para Pokémon Infinite Fusion: Hoenn 1.2.2 (base 6.8.2).

- Pokédex dos 70 Pokémon novos de Hoenn traduzida: categorias e descrições de Poochyena a Gastrodon, com as formas de Castform, Shellos e Gastrodon, mais Telemauv, Solminiatone e Luvbrufisk (79 entradas).
- Traduzidas as 38 descrições de itens que tinham ficado em inglês (HMs de Hoenn, Devon Parts, Acro Bike, Mach Bike, néctares, uniformes da Team Aqua e da Team Magma etc.) e a descrição da habilidade Simple.
- Traduzidas as descrições das 80 fitas (Ribbons).
- Traduzidas 9 frases escritas direto nos scripts dos mapas: placas de Littleroot Town e da Route 110, *"What would you like to do?"* nos Gyms de Rustboro, Dewford e Mauville, a pergunta do Pokémon Day Care e falas do rival depois da batalha.
- Falas de derrota passadas direto pelos eventos (Team Magma no Petalburg Woods e no Rusturf Tunnel, rival na Route 103) agora usam a tradução. Isso exigiu incluir `001_Overworld_BattleStarting.rb` no payload, com 3 linhas alteradas e marcadas com `# PT-BR`.
- Corrigidas as entradas da Pokédex das fusões triplas herdadas da tradução do Kanto, que tinham pedaços em inglês (*"máquina de fusão Team Rocket's"*, *"As melhorias do Further"*, *"Este émon Pok"*), e as categorias erradas de Totoritaquil e Baylavanaw.
- Corrigidas 5 entradas da Pokédex com frases em inglês misturadas (Nidorino, Fletchinder, Stunfisk, Oricorio, Chesnaught).
- Removidos espaços invisíveis que apareciam em 9 entradas da Pokédex.

## 1.0.0 — 2026-10-03

Primeira versão, para Pokémon Infinite Fusion: Hoenn 1.2.2 (base 6.8.2).

- Tradução de todos os 3.728 diálogos dos mapas e eventos de Hoenn.
- Tradução de 1.003 falas de treinadores (antes da batalha, revanches e derrota).
- Tradução de 460 textos de scripts: TV, reportagens, PokéChallenges, Bases Secretas, Concursos, hinos da Team Aqua e da Team Magma.
- Adaptação para a 6.8.2 dos textos de interface da tradução do Kanto (ExtremestoneGG): menus, batalha, bolsa, PC, loja e resumo.
- `portuguese.dat` ajustado aos IDs de Hoenn: descrições de itens, habilidades e Pokédex cujo ID mudou voltam para o inglês em vez de mostrar o texto errado.
- Descrições de roupas, chapéus e cabelos traduzidas.
- Instaladores para Windows (`.bat` + PowerShell) e Linux/macOS/Steam Deck (`.sh`), com conferência de versão, backup automático e desinstalação.
