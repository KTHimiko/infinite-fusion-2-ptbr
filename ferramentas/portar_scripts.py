#!/usr/bin/env python3
"""Port PT-BR string literals from 6.7.2 translated scripts into 6.8.2 scripts.

A line is changed only when, with all string literals masked out, the 6.8.2
line and the translated line are identical (same code, different text).
"""
import difflib, re, shutil, sys
from pathlib import Path

payload = Path(sys.argv[1])          # payload/files/Data/Scripts
game = Path(sys.argv[2])             # game Data/Scripts
backup = Path(sys.argv[3])           # backup Data/Scripts
apply = "--apply" in sys.argv

MOVED = {
    "016_UI/002_UI_Pokedex_Menu.rb": "016_UI/Pokedex/002_UI_Pokedex_Menu.rb",
    "016_UI/003_UI_Pokedex_Main.rb": "016_UI/Pokedex/003_UI_Pokedex_Main.rb",
    "016_UI/004_UI_Pokedex_Entry.rb": "016_UI/Pokedex/004_UI_Pokedex_Entry.rb",
    "052_InfiniteFusion/System/GameOptions.rb": "052_InfiniteFusion/System/Game Options/GameOptions.rb",
    "052_InfiniteFusion/Fusion/FusionMenu.rb": "052_InfiniteFusion/Fusion/Menus/FusionMenu.rb",
}
SKIP = {"001_Settings.rb", "DownloadedSettings.rb"}  # LANGUAGES handled separately; the other is fetched online

STR = re.compile(r'"(?:[^"\\]|\\.)*"|\'(?:[^\'\\]|\\.)*\'')

INTL = re.compile(r'_INTL\(|_ISPRINTF\(|_MAPINTL\(')
PATHLIKE = re.compile(r'Graphics/|Audio/|Data/|^[\w/.-]+$')

def is_text(eng, in_intl):
    """True if the English literal is player-facing text, not a path/identifier."""
    body = eng[1:-1]
    if PATHLIKE.search(body) and " " not in body and not in_intl:
        return False
    if re.fullmatch(r'[\w./-]+', body) and ('/' in body or '_' in body):
        return False
    return in_intl or " " in body

def mask(line):
    return STR.sub('""', line.strip())

def read(p):
    raw = p.read_bytes().decode("utf-8-sig")
    nl = "\r\n" if "\r\n" in raw else "\n"
    return raw.split(nl), nl, raw.startswith("﻿") or p.read_bytes().startswith(b"\xef\xbb\xbf")

total_lines = total_files = 0
for src in sorted(payload.rglob("*.rb")):
    rel = src.relative_to(payload).as_posix()
    if rel in SKIP:
        continue
    dst = game / MOVED.get(rel, rel)
    if not dst.is_file():
        print("NO TARGET:", rel); continue
    new, _, _ = read(src)
    old, nl, bom = read(dst)
    new_s = [l.rstrip("\r") for l in new]
    out = list(old)
    changed = 0
    sm = difflib.SequenceMatcher(None, [mask(l) for l in old], [mask(l) for l in new_s], autojunk=False)
    for tag, i1, i2, j1, j2 in sm.get_opcodes():
        if tag != "equal":
            continue
        for k in range(i2 - i1):
            o, n = old[i1 + k], new_s[j1 + k]
            pairs = iter(STR.findall(n))
            intl = INTL.search(o) is not None
            def swap(m):
                eng, pt = m.group(0), next(pairs)
                if not is_text(eng, intl):
                    return eng
                # placeholders/interpolations must match exactly, else 6.8.2 changed the args
                if sorted(re.findall(r'#\{[^}]*\}', eng)) != sorted(re.findall(r'#\{[^}]*\}', pt)):
                    return eng
                if sorted(set(re.findall(r'\{\d+[^}]*\}', eng))) != sorted(set(re.findall(r'\{\d+[^}]*\}', pt))):
                    return eng
                return pt
            line = STR.sub(swap, o)
            if line != o:
                out[i1 + k] = line
                changed += 1
    if changed:
        total_files += 1; total_lines += changed
        print(f"{changed:4d}  {MOVED.get(rel, rel)}")
        if apply:
            b = backup / MOVED.get(rel, rel)
            if not b.exists():
                b.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(dst, b)
            data = nl.join(out)
            dst.write_bytes((b"\xef\xbb\xbf" if bom else b"") + data.encode("utf-8"))
print(f"TOTAL: {total_lines} lines in {total_files} files", "(applied)" if apply else "(dry run)")
