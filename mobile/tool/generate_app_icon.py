"""Generate clean launcher-icon source images from the composed brand icon.

Input : mobile/healyn_app_icon.png  (rounded indigo square + mark on white margin)
Output: mobile/tool/icon_gen/
  - ic_full_square.png   1024  full-bleed indigo gradient + mark  (iOS + legacy Android)
  - ic_adaptive_fg.png   1024  transparent, mark inset to the adaptive safe zone
  - ic_adaptive_bg.png   1024  indigo gradient (adaptive background layer)

The mark (white figure + lavender heart + "healyn" wordmark) is lifted off the
source's indigo background by colour distance, then re-composited so the result
has a true full-bleed background with no baked rounded corners or white margin.
Run: python tool/generate_app_icon.py
"""
import os
from collections import deque
from PIL import Image, ImageDraw, ImageFilter

BASE = r"C:\CloudeCode\Healyn\mobile"
OUT = os.path.join(BASE, "tool", "icon_gen")
os.makedirs(OUT, exist_ok=True)

src = Image.open(os.path.join(BASE, "healyn_app_icon.png")).convert("RGB")
W, H = src.size
px = src.load()


def near_white(c, t=235):
    return c[0] >= t and c[1] >= t and c[2] >= t


# --- locate the indigo rounded-square inside the white margin ---
cy, cx = H // 2, W // 2
left = next(x for x in range(W) if not near_white(px[x, cy]))
right = next(x for x in range(W - 1, -1, -1) if not near_white(px[x, cy]))
top = next(y for y in range(H) if not near_white(px[cx, y]))
bottom = next(y for y in range(H - 1, -1, -1) if not near_white(px[cx, y]))
sq = src.crop((left, top, right + 1, bottom + 1))
sw, sh = sq.size
sqpx = sq.load()


# --- sample the indigo gradient endpoints (just inside the straight edges) ---
def strip_median(y):
    xs = range(int(sw * 0.30), int(sw * 0.70))
    cols = [sqpx[x, y] for x in xs]
    cols.sort(key=lambda c: c[0] + c[1] + c[2])
    return cols[len(cols) // 2]


top_color = strip_median(12)
bottom_color = strip_median(sh - 13)
print("indigo top", top_color, "bottom", bottom_color)
bg_ref = top_color  # reference for keying the background out


# --- 1) flood the white margin (incl. rounded corners) from the four corners.
# The figure's white is enclosed by indigo, so it is never reached. ---
def is_light(c, t=205):
    return c[0] >= t and c[1] >= t and c[2] >= t


margin = Image.new("L", sq.size, 0)
mpx = margin.load()
q = deque()
for sx, sy in ((0, 0), (sw - 1, 0), (0, sh - 1), (sw - 1, sh - 1)):
    if is_light(sqpx[sx, sy]) and mpx[sx, sy] == 0:
        mpx[sx, sy] = 255
        q.append((sx, sy))
while q:
    x, y = q.popleft()
    for nx, ny in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
        if 0 <= nx < sw and 0 <= ny < sh and mpx[nx, ny] == 0 and is_light(sqpx[nx, ny]):
            mpx[nx, ny] = 255
            q.append((nx, ny))
# Dilate the margin a few px to swallow the indigo<->white anti-alias ring.
margin = margin.filter(ImageFilter.MaxFilter(9))
mpx = margin.load()


# --- 2) inside the square, lift the mark off the indigo by colour distance ---
def dist(c, r):
    return ((c[0] - r[0]) ** 2 + (c[1] - r[1]) ** 2 + (c[2] - r[2]) ** 2) ** 0.5


T0, T1 = 80.0, 140.0  # <T0 => background (transparent), >T1 => mark (opaque)
fg = Image.new("RGBA", sq.size, (0, 0, 0, 0))
fgpx = fg.load()
minx, miny, maxx, maxy = sw, sh, 0, 0
for y in range(sh):
    for x in range(sw):
        if mpx[x, y]:  # white margin / corner — never part of the mark
            continue
        c = sqpx[x, y]
        d = dist(c, bg_ref)
        if d <= T0:
            a = 0
        elif d >= T1:
            a = 255
        else:
            a = int(round((d - T0) / (T1 - T0) * 255))
        if a:
            fgpx[x, y] = (c[0], c[1], c[2], a)

# --- 3) drop hairline/speck components (source compression dust); keep the
# figure, heart and each wordmark glyph. ---
seen = [[False] * sw for _ in range(sh)]
for y in range(sh):
    for x in range(sw):
        if seen[y][x] or fgpx[x, y][3] == 0:
            continue
        comp = []
        bx0, by0, bx1, by1 = x, y, x, y
        stack = [(x, y)]
        seen[y][x] = True
        while stack:
            px_, py_ = stack.pop()
            comp.append((px_, py_))
            bx0, by0 = min(bx0, px_), min(by0, py_)
            bx1, by1 = max(bx1, px_), max(by1, py_)
            for nx, ny in ((px_ + 1, py_), (px_ - 1, py_), (px_, py_ + 1), (px_, py_ - 1)):
                if 0 <= nx < sw and 0 <= ny < sh and not seen[ny][nx] and fgpx[nx, ny][3] > 0:
                    seen[ny][nx] = True
                    stack.append((nx, ny))
        if len(comp) < 400 or (bx1 - bx0) < 10 or (by1 - by0) < 10:
            for px_, py_ in comp:
                fgpx[px_, py_] = (0, 0, 0, 0)

minx, miny, maxx, maxy = sw, sh, 0, 0
for y in range(sh):
    for x in range(sw):
        if fgpx[x, y][3]:
            minx, maxx = min(minx, x), max(maxx, x)
            miny, maxy = min(miny, y), max(maxy, y)
fg = fg.crop((minx, miny, maxx + 1, maxy + 1))
print("mark bbox in square:", (minx, miny, maxx, maxy), "=> size", fg.size)
print("mark fraction of square:", round(fg.size[0] / sw, 3), round(fg.size[1] / sh, 3))


def trim(img):
    bbox = img.split()[-1].getbbox()
    return img.crop(bbox) if bbox else img


# Split the mark into the upper cluster (figure + heart) and the lower wordmark
# at the widest fully-transparent horizontal gap in the lower half. The figure +
# heart is the mask-safe mark used for the adaptive icon and the splash card; the
# full mark (with wordmark) is kept for the iOS / legacy square icon.
fw, fh = fg.size
fgp = fg.load()
row_has = [any(fgp[x, y][3] > 30 for x in range(fw)) for y in range(fh)]
gaps, y = [], 0
while y < fh:
    if not row_has[y]:
        start = y
        while y < fh and not row_has[y]:
            y += 1
        gaps.append((start, y))
    else:
        y += 1
lower_gaps = [g for g in gaps if (g[0] + g[1]) / 2 > fh * 0.45]
split = max(lower_gaps, key=lambda g: g[1] - g[0]) if lower_gaps else None
split_y = (split[0] + split[1]) // 2 if split else int(fh * 0.72)
upper = trim(fg.crop((0, 0, fw, split_y)))  # figure + heart
wordmark = trim(fg.crop((0, split_y, fw, fh)))  # the "healyn" wordmark, as drawn
wordmark.save(os.path.join(OUT, "wordmark.png"))
print("wordmark split at y", split_y, "-> figure+heart", upper.size, "wordmark", wordmark.size)


def gradient(size, c0, c1):
    """Diagonal top-left -> bottom-right gradient, matching HealynColors.brandGradient."""
    img = Image.new("RGB", (size, size))
    p = img.load()
    for y in range(size):
        for x in range(size):
            t = (x + y) / (2 * (size - 1))
            p[x, y] = (
                round(c0[0] + (c1[0] - c0[0]) * t),
                round(c0[1] + (c1[1] - c0[1]) * t),
                round(c0[2] + (c1[2] - c0[2]) * t),
            )
    return img


def place(canvas, mark, frac):
    """Paste mark centred on canvas, scaled so its longest side == frac*canvas."""
    cw = canvas.size[0]
    target = cw * frac
    s = target / max(mark.size)
    m = mark.resize((max(1, round(mark.size[0] * s)), max(1, round(mark.size[1] * s))), Image.LANCZOS)
    canvas = canvas.convert("RGBA")
    canvas.alpha_composite(m, ((cw - m.size[0]) // 2, (cw - m.size[1]) // 2))
    return canvas


SIZE = 1024
# Full-bleed icon: reproduce the source proportions (mark ~ its share of the square).
full_frac = max(fg.size) / sw
full = place(gradient(SIZE, top_color, bottom_color), fg, full_frac)
full.convert("RGB").save(os.path.join(OUT, "ic_full_square.png"))

# Adaptive: background is the gradient; foreground is the figure + heart only
# (no wordmark — text clips under a circular launcher mask), kept inside the
# 66/108 safe zone so every mask shape shows it whole.
gradient(SIZE, top_color, bottom_color).save(os.path.join(OUT, "ic_adaptive_bg.png"))
adaptive_fg = place(Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0)), upper, 0.58)
adaptive_fg.save(os.path.join(OUT, "ic_adaptive_fg.png"))

# A transparent trimmed mark, handy for reference.
fg.save(os.path.join(OUT, "mark.png"))


# ---------------------------------------------------------------------------
# Splash assets: the reference splash shows the figure + heart on a WHITE card
# (figure recoloured to brand indigo), the "healyn" wordmark + tagline beneath,
# and a faint figure silhouette in the corner. Recolour the figure+heart cluster
# (`upper`, split out above) and compose the white card.
# ---------------------------------------------------------------------------
BRAND_INDIGO = (59, 74, 160)  # HealynColors.brandPrimary #3B4AA0


def recolor_figure(img, drop_heart):
    """Heart pixels (bluish, b-r large) are kept or dropped; the rest (the white
    figure) is repainted brand indigo (drop_heart=False) or white (drop_heart=True)."""
    img = img.convert("RGBA")
    p = img.load()
    w, h = img.size
    for yy in range(h):
        for xx in range(w):
            r, g, b, a = p[xx, yy]
            if a == 0:
                continue
            is_heart = (b - r) > 35
            if is_heart:
                if drop_heart:
                    p[xx, yy] = (0, 0, 0, 0)
                # else keep the heart's own lavender
            elif drop_heart:
                p[xx, yy] = (255, 255, 255, a)  # ghost silhouette: white figure
            else:
                p[xx, yy] = (*BRAND_INDIGO, a)   # on-card: indigo figure
    return img


mark_oncard = recolor_figure(upper, drop_heart=False)
mark_oncard.save(os.path.join(OUT, "mark_oncard.png"))
figure_silhouette = trim(recolor_figure(upper, drop_heart=True))
figure_silhouette.save(os.path.join(OUT, "figure_silhouette.png"))


def make_card(content, card_px=768, radius_frac=0.255, content_frac=0.60):
    """White rounded-square card with `content` centred, transparent outside."""
    mask = Image.new("L", (card_px, card_px), 0)
    ImageDraw.Draw(mask).rounded_rectangle(
        [0, 0, card_px - 1, card_px - 1], radius=int(card_px * radius_frac), fill=255
    )
    white = Image.new("RGBA", (card_px, card_px), (255, 255, 255, 255))
    card = Image.composite(white, Image.new("RGBA", (card_px, card_px), (0, 0, 0, 0)), mask)
    s = (card_px * content_frac) / max(content.size)
    c = content.resize((round(content.size[0] * s), round(content.size[1] * s)), Image.LANCZOS)
    card.alpha_composite(c, ((card_px - c.size[0]) // 2, (card_px - c.size[1]) // 2))
    return card


make_card(mark_oncard).save(os.path.join(OUT, "splash_logo.png"))
print("wrote:", sorted(os.listdir(OUT)))
