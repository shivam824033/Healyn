"""Install the generated brand assets into the Android/iOS platform folders and
the bundled Flutter asset dir. Idempotent: re-run after generate_app_icon.py.

Sources: mobile/tool/icon_gen/  (run generate_app_icon.py first)
Writes:
  Android launcher: mipmap-*/ic_launcher.png  (legacy, full-bleed)
                    mipmap-*/ic_launcher_foreground.png + ic_launcher_background.png (adaptive)
  Android splash:   drawable-*/splash_logo.png  (white card, for launch_background)
  iOS launcher:     Runner/Assets.xcassets/AppIcon.appiconset/*.png
  iOS splash:       Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage*.png
  Bundled:          assets/branding/{mark_oncard,figure_silhouette,wordmark}.png
"""
import json
import os
from PIL import Image

MOBILE = r"C:\CloudeCode\Healyn\mobile"
SRC = os.path.join(MOBILE, "tool", "icon_gen")
AND_RES = os.path.join(MOBILE, "android", "app", "src", "main", "res")
IOS = os.path.join(MOBILE, "ios", "Runner", "Assets.xcassets")

# density buckets -> scale factor
DENSITIES = {"mdpi": 1, "hdpi": 1.5, "xhdpi": 2, "xxhdpi": 3, "xxxhdpi": 4}


def load(name):
    return Image.open(os.path.join(SRC, name))


def fit(img, px, rgb=False):
    out = img.resize((px, px), Image.LANCZOS)
    return out.convert("RGB") if rgb else out


def fit_w(img, w):
    h = round(img.size[1] * w / img.size[0])
    return img.resize((w, h), Image.LANCZOS)


def ensure(d):
    os.makedirs(d, exist_ok=True)
    return d


written = []


def save(img, path):
    ensure(os.path.dirname(path))
    img.save(path)
    written.append(os.path.relpath(path, MOBILE))


# --- Android launcher icons ---
full = load("ic_full_square.png").convert("RGB")
fg = load("ic_adaptive_fg.png")
bg = load("ic_adaptive_bg.png").convert("RGB")
LEGACY = {"mdpi": 48, "hdpi": 72, "xhdpi": 96, "xxhdpi": 144, "xxxhdpi": 192}
ADAPTIVE = {"mdpi": 108, "hdpi": 162, "xhdpi": 216, "xxhdpi": 324, "xxxhdpi": 432}
for d, px in LEGACY.items():
    save(fit(full, px, rgb=True), os.path.join(AND_RES, f"mipmap-{d}", "ic_launcher.png"))
for d, px in ADAPTIVE.items():
    save(fit(fg, px), os.path.join(AND_RES, f"mipmap-{d}", "ic_launcher_foreground.png"))
    save(fit(bg, px, rgb=True), os.path.join(AND_RES, f"mipmap-{d}", "ic_launcher_background.png"))

# --- Android splash logo (white card) for launch_background ---
splash = load("splash_logo.png")
SPLASH_DP = 152
for d, scale in DENSITIES.items():
    save(fit(splash, round(SPLASH_DP * scale)), os.path.join(AND_RES, f"drawable-{d}", "splash_logo.png"))

# --- iOS launcher icons (opaque, no alpha) ---
appicon = os.path.join(IOS, "AppIcon.appiconset")
meta = json.load(open(os.path.join(appicon, "Contents.json")))
for entry in meta["images"]:
    side = float(entry["size"].split("x")[0])
    scale = int(entry["scale"].rstrip("x"))
    px = round(side * scale)
    save(fit(full, px, rgb=True), os.path.join(appicon, entry["filename"]))

# --- iOS launch image (white card, transparent around -> storyboard indigo bg) ---
launch = os.path.join(IOS, "LaunchImage.imageset")
for fname, scale in (("LaunchImage.png", 1), ("LaunchImage@2x.png", 2), ("LaunchImage@3x.png", 3)):
    save(fit(splash, 150 * scale), os.path.join(launch, fname))

# --- Bundled Flutter assets for the in-app splash ---
branding = os.path.join(MOBILE, "assets", "branding")
for name in ("mark_oncard.png", "figure_silhouette.png", "wordmark.png"):
    save(load(name), os.path.join(branding, name))

print(f"installed {len(written)} files:")
for w in written:
    print("  ", w.replace("\\", "/"))
