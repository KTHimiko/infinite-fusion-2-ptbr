#!/usr/bin/env python3
"""Extract map/common-event dialogue from IF2 and list what portuguese.dat lacks."""
import json, re, sys
from pathlib import Path
from rubymarshal.reader import load

GAME = Path(sys.argv[1])          # .../InfiniteFusion2
DAT = Path(sys.argv[2])           # portuguese.dat to check against
OUT = Path(sys.argv[3])           # output json


def s(x):
    if x is None:
        return None
    if isinstance(x, bytes):
        return x.decode("utf-8", "replace")
    return str(x)


def attr(o, name):
    return o.attributes.get("@" + name)


def string_to_key(t):
    if re.search(r"[\r\n\t\x01]|^\s+|\s+$|\s{2,}", t):
        t = re.sub(r"^\s+", "", t)
        t = re.sub(r"\s+$", "", t)
        t = re.sub(r"\s{2,}", " ", t)
    return t


def messages_from_list(cmds):
    out = []
    i = 0
    while i < len(cmds):
        c = cmds[i]
        code = attr(c, "code")
        params = attr(c, "parameters")
        if code == 101:
            msg = s(params[0])
            j = i + 1
            while j < len(cmds) and attr(cmds[j], "code") == 401:
                t = s(attr(cmds[j], "parameters")[0])
                if t != "" and msg[-1:] != " ":
                    msg += " "
                msg += t
                j += 1
            out.append(msg)
            i = j
            continue
        if code == 102:
            for ch in params[0]:
                out.append(s(ch))
        i += 1
    return out


def event_lists(mapobj):
    events = attr(mapobj, "events")
    for ev in (events.values() if isinstance(events, dict) else events):
        for page in attr(ev, "pages") or []:
            yield attr(page, "list") or []


def ordered_hash(o):
    keys, vals = load(__import__("io").BytesIO(o._private_data))
    return {s(k): s(v) for k, v in zip(keys, vals)}


pt = load(open(DAT, "rb"))
sec0 = pt[0]


def translated(mapid, key):
    for mid in (mapid, 0):
        if mid < len(sec0) and sec0[mid] is not None:
            h = cache.setdefault(mid, ordered_hash(sec0[mid]))
            if key in h:
                return True
    return False


cache = {}
infos = load(open(GAME / "Data/MapInfos.rxdata", "rb"))
names = {int(k): s(attr(v, "name")) for k, v in infos.items()}

result = []
seen = set()
for f in sorted((GAME / "Data").glob("Map[0-9][0-9][0-9].rxdata")):
    mid = int(f.stem[3:])
    m = load(open(f, "rb"))
    for lst in event_lists(m):
        for msg in messages_from_list(lst):
            if not msg or not msg.strip():
                continue
            key = string_to_key(msg)
            if (mid, key) in seen:
                continue
            seen.add((mid, key))
            result.append({"map": mid, "mapname": names.get(mid, ""), "en": key, "done": translated(mid, key)})

common = load(open(GAME / "Data/CommonEvents.rxdata", "rb"))
for ce in common:
    if ce is None:
        continue
    for msg in messages_from_list(attr(ce, "list") or []):
        if not msg or not msg.strip():
            continue
        key = string_to_key(msg)
        if (0, key) in seen:
            continue
        seen.add((0, key))
        result.append({"map": 0, "mapname": "CommonEvents", "en": key, "done": translated(0, key)})

OUT.write_text(json.dumps(result, ensure_ascii=False, indent=1), encoding="utf-8")
todo = [r for r in result if not r["done"]]
print(f"maps: {len(names)}  messages: {len(result)}  already PT: {len(result)-len(todo)}  to translate: {len(todo)}")
print("unique EN strings to translate:", len({r['en'] for r in todo}))
print("words:", sum(len(r["en"].split()) for r in {r['en']: r for r in todo}.values()))
