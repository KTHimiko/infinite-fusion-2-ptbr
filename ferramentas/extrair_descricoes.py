#!/usr/bin/env python3
"""Lista as descrições por ID (Pokédex, itens, habilidades, fitas) que o DAT ainda não
traduz e confere se o inglês de traducao/descricoes.tsv ainda bate com o jogo.

Uso (na raiz do repositório):
    python ferramentas/extrair_descricoes.py JOGO DAT

Grava descricoes_todo.tsv (secao<TAB>id<TAB>ingles<TAB>) pronto para traduzir e colar em
traducao/descricoes.tsv. IDs cujo inglês mudou numa versão nova aparecem como AVISO: a
tradução antiga iria para o Pokémon/item errado, então revise ou remova a linha.
"""
import io
import re
import sys
from pathlib import Path

from rubymarshal.reader import load

ROOT = Path(__file__).resolve().parent.parent
GAME = Path(sys.argv[1]); DAT = Path(sys.argv[2])
SECOES_ID = {"categoria_pokedex": 2, "entrada_pokedex": 3, "descricao_item": 9,
             "descricao_habilidade": 11, "descricao_fita": 26}
KEY = [0x4A, 0x8F, 0x2C, 0xE1, 0x73, 0xB5, 0x96, 0x0D, 0x5E, 0xA2, 0x3F, 0xC7, 0x81, 0x14, 0x6B, 0xD9]


def s(x):
    return None if x is None else (x.decode("utf-8", "replace") if isinstance(x, bytes) else str(x))


def norm(t):
    return re.sub(r"\s+", " ", t.replace("⏎", "\n")).strip()


raw = (GAME / "Data/messages.dat").read_bytes()
if not raw.startswith(b"\x04\x08"):
    raw = bytes(b ^ KEY[i % 16] for i, b in enumerate(raw))
en = load(io.BytesIO(raw))
pt = load(open(DAT, "rb"))

avisos = 0
for i, ln in enumerate((ROOT / "traducao/descricoes.tsv").read_text(encoding="utf-8").splitlines()[1:], 2):
    if not ln.strip():
        continue
    sec, num, ingles, _ = ln.split("\t")
    num = int(num)
    lista = en[SECOES_ID[sec]]
    atual = s(lista[num]) if num < len(lista) else None
    if not atual or norm(atual) != norm(ingles):
        avisos += 1
        print(f"AVISO descricoes.tsv linha {i} ({sec} {num}): o inglês mudou\n  TSV  {ingles!r}\n  JOGO {atual!r}")

todo = []
for nome, sec in SECOES_ID.items():
    lista_pt = pt[sec] if isinstance(pt[sec], list) else []
    for n, t in enumerate(en[sec]):
        t = s(t)
        if t and t.strip() and not (n < len(lista_pt) and s(lista_pt[n])):
            todo.append(f"{nome}\t{n}\t{t.strip().replace(chr(10), '⏎')}\t")
Path("descricoes_todo.tsv").write_text("secao\tid\tingles\tportugues\n" + "\n".join(todo) + "\n", encoding="utf-8")
print(f"{len(todo)} descrição(ões) sem tradução em descricoes_todo.tsv; {avisos} aviso(s).")
