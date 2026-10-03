#!/usr/bin/env python3
"""Gera o Data/portuguese.dat do Infinite Fusion 2 a partir das tabelas em traducao/.

Uso (na raiz do repositório):
    pip install rubymarshal
    python ferramentas/gerar_dat.py [saida.dat]

Entradas:
    ferramentas/portuguese_base.dat   tradução do Kanto (ExtremestoneGG) ajustada para os IDs de Hoenn
    ferramentas/mapas_dialogos.json   em qual mapa aparece cada fala (extraído dos .rxdata do jogo)
    traducao/dialogos.tsv             falas dos mapas (ingles<TAB>portugues<TAB>origem)
    traducao/treinadores_e_scripts.tsv falas de treinadores e textos de scripts (secao<TAB>ingles<TAB>portugues)

"⏎" nas tabelas representa uma quebra de linha real.
"""
import io
import json
import re
import sys
from pathlib import Path

from rubymarshal.classes import RubyString, UserDef
from rubymarshal.reader import load
from rubymarshal.writer import writes

ROOT = Path(__file__).resolve().parent.parent
OUT = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "payload/Data/portuguese.dat"
SECOES = {"fala_antes_batalha": 15, "fala_derrota": 23, "texto_script": 24}

# códigos de controle das mensagens; precisam aparecer igual no inglês e no português
CODE = re.compile(r'\\[A-Za-z]+\[[^\]]*\]|\\(?:PN|PM|op|cl|wu|wm|wd|G|n|r|b|i|u)|\\[.|!^<>]|\{\d+\}|<[^>]*>')


def codigos(t):
    return sorted(m.lower() for m in CODE.findall(t))


def tsv(path):
    linhas = path.read_text(encoding="utf-8").splitlines()[1:]
    return [[c.replace("⏎", "\n") for c in ln.split("\t")] for ln in linhas if ln.strip()]


def ler_hash(o):
    if o is None:
        return [], []
    k, v = load(io.BytesIO(o._private_data))
    return list(k), list(v)


def gravar_hash(keys, vals):
    oh = UserDef("OrderedHash")
    oh._load(writes([keys, vals]))
    return oh


def mesclar(obj, entradas):
    keys, vals = ler_hash(obj)
    pos = {str(k): n for n, k in enumerate(keys)}
    for en, pt in entradas.items():
        if en in pos:
            vals[pos[en]] = RubyString(pt, {"E": True})
        else:
            keys.append(RubyString(en, {"E": True}))
            vals.append(RubyString(pt, {"E": True}))
    return gravar_hash(keys, vals)


erros = 0


def checar(en, pt, onde):
    global erros
    if codigos(en) != codigos(pt):
        erros += 1
        print(f"ERRO de código em {onde}:\n  EN {en!r}\n  PT {pt!r}")
        return False
    return True


dat = load(open(ROOT / "ferramentas/portuguese_base.dat", "rb"))

# falas dos mapas -> seção 0, um hash por mapa
dialogos = {}
for i, (en, pt, *_) in enumerate(tsv(ROOT / "traducao/dialogos.tsv"), 2):
    if checar(en, pt, f"dialogos.tsv linha {i}"):
        dialogos[en] = pt
por_mapa = {}
for r in json.load(open(ROOT / "ferramentas/mapas_dialogos.json", encoding="utf-8")):
    if r["en"] in dialogos:
        por_mapa.setdefault(r["map"], {})[r["en"]] = dialogos[r["en"]]
sec0 = dat[0]
for mid, entradas in por_mapa.items():
    while len(sec0) <= mid:
        sec0.append(None)
    sec0[mid] = mesclar(sec0[mid], entradas)

# treinadores e scripts -> seções 15/23/24 (hash global)
por_secao = {}
for i, (sec, en, pt) in enumerate(tsv(ROOT / "traducao/treinadores_e_scripts.tsv"), 2):
    if checar(en, pt, f"treinadores_e_scripts.tsv linha {i}"):
        por_secao.setdefault(SECOES[sec], {})[en] = pt
for sec, entradas in por_secao.items():
    dat[sec] = mesclar(dat[sec], entradas)

if erros:
    sys.exit(f"{erros} erro(s) de código de controle; corrija antes de gerar.")
OUT.write_bytes(writes(dat))
print(f"OK: {OUT} ({len(dialogos)} falas de mapa, {sum(map(len, por_secao.values()))} de treinadores/scripts)")
