#!/usr/bin/env python3
"""Extract trainer speech (sections 15/23) and Hoenn script _INTL texts (24)
missing from portuguese.dat. Writes extra_todo.json: [{sec, en}]"""
import io, json, re, sys
from pathlib import Path
from rubymarshal.reader import load

GAME = Path(sys.argv[1]); DAT = Path(sys.argv[2])


def s(x):
    return None if x is None else (x.decode("utf-8", "replace") if isinstance(x, bytes) else str(x))


def oh(o):
    if o is None:
        return {}
    k, v = load(io.BytesIO(o._private_data))
    return {s(a) for a in k}


def key(t):
    if re.search(r"[\r\n\t\x01]|^\s+|\s+$|\s{2,}", t):
        t = re.sub(r"\s{2,}", " ", t.strip())
    return t


KEY = [0x4A, 0x8F, 0x2C, 0xE1, 0x73, 0xB5, 0x96, 0x0D, 0x5E, 0xA2, 0x3F, 0xC7, 0x81, 0x14, 0x6B, 0xD9]
pt = load(open(DAT, "rb"))
have = {sec: oh(pt[sec]) for sec in (15, 23, 24)}
todo = {}

# --- trainers
BEGIN = ["battleText", "preRematchText", "preRematchText_caught", "preRematchText_evolved",
         "preRematchText_fused", "preRematchText_unfused", "preRematchText_reversed", "preRematchText_gift"]
LOSE = ["real_lose_text", "loseText_rematch"]
for fn in ("trainers.dat", "trainers_expert.dat", "trainers_remix.dat"):
    p = GAME / "Data" / fn
    if not p.exists():
        continue
    raw = p.read_bytes()
    if not raw.startswith(b"\x04\x08"):
        raw = bytes(b ^ KEY[i % 16] for i, b in enumerate(raw))
    data = load(io.BytesIO(raw))
    objs = data.values() if isinstance(data, dict) else data
    for o in objs:
        a = getattr(o, "attributes", None)
        if not a:
            continue
        for sec, names in ((15, BEGIN), (23, LOSE)):
            for n in names:
                t = s(a.get("@" + n))
                if t and t.strip() and key(t) not in have[sec]:
                    todo[(sec, key(t))] = 1

# --- Hoenn-specific scripts: _INTL("...") literals
INTL = re.compile(r'_INTL\(\s*"((?:[^"\\]|\\.)*)"')
for f in (GAME / "Data/Scripts/053_PIF_Hoenn").rglob("*.rb"):
    for m in INTL.finditer(f.read_text(encoding="utf-8", errors="replace")):
        lit = m.group(1)
        if "#{" in lit:
            continue
        # ruby double-quoted unescape (common cases)
        t = lit.replace('\\"', '"').replace("\\\\", "\\").replace("\\n", "\n")
        if t.strip() and key(t) not in have[24]:
            todo[(24, key(t))] = 1

out = [{"sec": k[0], "en": k[1]} for k in todo]
json.dump(out, open("extra_todo.json", "w"), ensure_ascii=False, indent=0)
from collections import Counter
print(Counter(r["sec"] for r in out), "words:", sum(len(r["en"].split()) for r in out))
