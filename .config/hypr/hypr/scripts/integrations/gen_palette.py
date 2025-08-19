#!/usr/bin/env python3
import json, os, re, sys

HOME = os.path.expanduser("~")
OUT_DEFAULT = os.path.join(HOME, ".config", "waybar", "temas", "integrations", "palette.css")

def from_wal():
    p = os.path.join(HOME, ".cache", "wal", "colors.json")
    if not os.path.isfile(p): return None
    data = json.load(open(p, "r", encoding="utf-8"))
    spec, col = data.get("special", {}), data.get("colors", {})
    return dict(
        bg=spec.get("background", "#111111"),
        fg=spec.get("foreground", "#e5e5e5"),
        accent=col.get("color5") or col.get("color4") or "#7aa2f7",
        warn=col.get("color3") or "#f59e0b",
        crit=col.get("color1") or "#ef4444",
        secondary=col.get("color6") or "#22d3ee",
    )

def from_wallust():
    for path in (os.path.join(HOME,".cache","wallust","colors.toml"), os.path.join(HOME,".config","wallust","colors.toml")):
        if os.path.isfile(path):
            d={}
            for line in open(path,"r",encoding="utf-8"):
                m=re.match(r'^\s*(background|foreground|cursor|color\d+)\s*=\s*"(#?[0-9A-Fa-f]{6,8})"', line)
                if m: d[m.group(1)]=m.group(2)
            if d:
                return dict(
                    bg=d.get("background","#0b0b10"),
                    fg=d.get("foreground","#e5e7eb"),
                    accent=d.get("color5", d.get("color4","#60a5fa")),
                    warn=d.get("color3","#f59e0b"),
                    crit=d.get("color1","#ef4444"),
                    secondary=d.get("color6","#22d3ee"),
                )
    return None

def write_css(pal, out_file):
    os.makedirs(os.path.dirname(out_file), exist_ok=True)
    css = f"""@define-color wb_bg {pal['bg']};
@define-color wb_fg {pal['fg']};
@define-color wb_accent {pal['accent']};
@define-color wb_warn {pal['warn']};
@define-color wb_crit {pal['crit']};
@define-color wb_secondary {pal['secondary']};
"""
    open(out_file,"w",encoding="utf-8").write(css)
    return out_file

def main():
    out = sys.argv[1] if len(sys.argv)>1 else OUT_DEFAULT
    pal = from_wal() or from_wallust() or dict(bg="#1e222a", fg="#e5e9f0", accent="#88c0d0", warn="#ebcb8b", crit="#bf616a", secondary="#81a1c1")
    print(write_css(pal, out))

if __name__ == "__main__":
    main()
