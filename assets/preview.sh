#!/usr/bin/env bash
#
# Preview script for iTerm2 Karma theme screenshots.
#
# Catppuccin-style layout: small palette swatch on the left, fetch-style
# system info on the right, ANSI 0-15 numerical strip below, blank prompt
# at the bottom.
#
# Uses 24-bit true-color escape codes with exact Karma palette hex values,
# so the output is pixel-perfect regardless of which terminal profile is
# active. Designed to be piped into `freeze --window` for the macOS chrome.
#
# Usage:
#   ./assets/preview.sh dark  | freeze --output assets/karma-dark.png  --window ...
#   ./assets/preview.sh light | freeze --output assets/karma-light.png --window ...

VARIANT="${1:-dark}"

# ── Karma Dark palette ────────────────────────────────────────────────────────
D_FG_R=247;  D_FG_G=241;  D_FG_B=255   # #f7f1ff
D_RED_R=252; D_RED_G=97;  D_RED_B=141  # #fc618d
D_GRN_R=123; D_GRN_G=216; D_GRN_B=143  # #7bd88f
D_YEL_R=252; D_YEL_G=229; D_YEL_B=102  # #fce566
D_BLU_R=90;  D_BLU_G=212; D_BLU_B=230  # #5ad4e6
D_MAG_R=175; D_MAG_G=152; D_MAG_B=230  # #af98e6
D_CYA_R=90;  D_CYA_G=212; D_CYA_B=230  # #5ad4e6 (same as blue, by Karma design)
D_WHT_R=186; D_WHT_G=182; D_WHT_B=192  # #bab6c0
D_GRY_R=105; D_GRY_G=103; D_GRY_B=108  # #69676c (br.black)
D_HLT_R=168; D_HLT_G=110; D_HLT_B=253  # #a86efd (highlight)

# Bright variants
D_BR_RED_R=255; D_BR_RED_G=123; D_BR_RED_B=160  # #ff7ba0
D_BR_GRN_R=156; D_BR_GRN_G=227; D_BR_GRN_B=171  # #9ce3ab
D_BR_YEL_R=252; D_BR_YEL_G=229; D_BR_YEL_B=102  # #fce566 (same)
D_BR_BLU_R=127; D_BR_BLU_G=224; D_BR_BLU_B=238  # #7fe0ee
D_BR_MAG_R=195; D_BR_MAG_G=176; D_BR_MAG_B=240  # #c3b0f0
D_BR_CYA_R=127; D_BR_CYA_G=224; D_BR_CYA_B=238  # #7fe0ee
D_BR_WHT_R=247; D_BR_WHT_G=241; D_BR_WHT_B=255  # #f7f1ff

# ── Karma Light palette ──────────────────────────────────────────────────────
L_FG_R=10;   L_FG_G=14;   L_FG_B=20    # #0a0e14
L_RED_R=252; L_RED_G=97;  L_RED_B=141  # #fc618d
L_GRN_R=45;  L_GRN_G=151; L_GRN_B=47   # #2d972f
L_YEL_R=238; L_YEL_G=174; L_YEL_B=17   # #eeae11
L_BLU_R=86;  L_BLU_G=136; L_BLU_B=199  # #5688c7
L_MAG_R=111; L_MAG_G=66;  L_MAG_B=193  # #6f42c1
L_CYA_R=86;  L_CYA_G=136; L_CYA_B=199  # #5688c7 (same as blue)
L_WHT_R=82;  L_WHT_G=80;  L_WHT_B=83   # #525053
L_GRY_R=153; L_GRY_G=153; L_GRY_B=153  # #999999
L_HLT_R=168; L_HLT_G=110; L_HLT_B=253  # #a86efd

L_BR_RED_R=252; L_BR_RED_G=97;  L_BR_RED_B=141  # #fc618d (same)
L_BR_GRN_R=45;  L_BR_GRN_G=151; L_BR_GRN_B=47   # #2d972f (same)
L_BR_YEL_R=255; L_BR_YEL_G=170; L_BR_YEL_B=51   # #ffaa33
L_BR_BLU_R=86;  L_BR_BLU_G=136; L_BR_BLU_B=199  # #5688c7 (same)
L_BR_MAG_R=168; L_BR_MAG_G=110; L_BR_MAG_B=253  # #a86efd (highlight)
L_BR_CYA_R=86;  L_BR_CYA_G=136; L_BR_CYA_B=199  # #5688c7 (same)
L_BR_WHT_R=10;  L_BR_WHT_G=14;  L_BR_WHT_B=20   # #0a0e14

# ── Select active palette ─────────────────────────────────────────────────────
if [[ "$VARIANT" == "light" ]]; then
  FG_R=$L_FG_R;  FG_G=$L_FG_G;  FG_B=$L_FG_B
  RED_R=$L_RED_R; RED_G=$L_RED_G; RED_B=$L_RED_B
  GRN_R=$L_GRN_R; GRN_G=$L_GRN_G; GRN_B=$L_GRN_B
  YEL_R=$L_YEL_R; YEL_G=$L_YEL_G; YEL_B=$L_YEL_B
  BLU_R=$L_BLU_R; BLU_G=$L_BLU_G; BLU_B=$L_BLU_B
  MAG_R=$L_MAG_R; MAG_G=$L_MAG_G; MAG_B=$L_MAG_B
  CYA_R=$L_CYA_R; CYA_G=$L_CYA_G; CYA_B=$L_CYA_B
  GRY_R=$L_GRY_R; GRY_G=$L_GRY_G; GRY_B=$L_GRY_B
  WHT_R=$L_WHT_R; WHT_G=$L_WHT_G; WHT_B=$L_WHT_B
  HLT_R=$L_HLT_R; HLT_G=$L_HLT_G; HLT_B=$L_HLT_B
  BR_RED_R=$L_BR_RED_R; BR_RED_G=$L_BR_RED_G; BR_RED_B=$L_BR_RED_B
  BR_GRN_R=$L_BR_GRN_R; BR_GRN_G=$L_BR_GRN_G; BR_GRN_B=$L_BR_GRN_B
  BR_YEL_R=$L_BR_YEL_R; BR_YEL_G=$L_BR_YEL_G; BR_YEL_B=$L_BR_YEL_B
  BR_BLU_R=$L_BR_BLU_R; BR_BLU_G=$L_BR_BLU_G; BR_BLU_B=$L_BR_BLU_B
  BR_MAG_R=$L_BR_MAG_R; BR_MAG_G=$L_BR_MAG_G; BR_MAG_B=$L_BR_MAG_B
  BR_CYA_R=$L_BR_CYA_R; BR_CYA_G=$L_BR_CYA_G; BR_CYA_B=$L_BR_CYA_B
  BR_WHT_R=$L_BR_WHT_R; BR_WHT_G=$L_BR_WHT_G; BR_WHT_B=$L_BR_WHT_B
  THEME_NAME="Karma Light"
else
  FG_R=$D_FG_R;  FG_G=$D_FG_G;  FG_B=$D_FG_B
  RED_R=$D_RED_R; RED_G=$D_RED_G; RED_B=$D_RED_B
  GRN_R=$D_GRN_R; GRN_G=$D_GRN_G; GRN_B=$D_GRN_B
  YEL_R=$D_YEL_R; YEL_G=$D_YEL_G; YEL_B=$D_YEL_B
  BLU_R=$D_BLU_R; BLU_G=$D_BLU_G; BLU_B=$D_BLU_B
  MAG_R=$D_MAG_R; MAG_G=$D_MAG_G; MAG_B=$D_MAG_B
  CYA_R=$D_CYA_R; CYA_G=$D_CYA_G; CYA_B=$D_CYA_B
  GRY_R=$D_GRY_R; GRY_G=$D_GRY_G; GRY_B=$D_GRY_B
  WHT_R=$D_WHT_R; WHT_G=$D_WHT_G; WHT_B=$D_WHT_B
  HLT_R=$D_HLT_R; HLT_G=$D_HLT_G; HLT_B=$D_HLT_B
  BR_RED_R=$D_BR_RED_R; BR_RED_G=$D_BR_RED_G; BR_RED_B=$D_BR_RED_B
  BR_GRN_R=$D_BR_GRN_R; BR_GRN_G=$D_BR_GRN_G; BR_GRN_B=$D_BR_GRN_B
  BR_YEL_R=$D_BR_YEL_R; BR_YEL_G=$D_BR_YEL_G; BR_YEL_B=$D_BR_YEL_B
  BR_BLU_R=$D_BR_BLU_R; BR_BLU_G=$D_BR_BLU_G; BR_BLU_B=$D_BR_BLU_B
  BR_MAG_R=$D_BR_MAG_R; BR_MAG_G=$D_BR_MAG_G; BR_MAG_B=$D_BR_MAG_B
  BR_CYA_R=$D_BR_CYA_R; BR_CYA_G=$D_BR_CYA_G; BR_CYA_B=$D_BR_CYA_B
  BR_WHT_R=$D_BR_WHT_R; BR_WHT_G=$D_BR_WHT_G; BR_WHT_B=$D_BR_WHT_B
  THEME_NAME="Karma Dark"
fi

# ── Color helpers ─────────────────────────────────────────────────────────────
fg() { printf "\033[38;2;%d;%d;%dm" "$1" "$2" "$3"; }
bg() { printf "\033[48;2;%d;%d;%dm" "$1" "$2" "$3"; }
rst() { printf "\033[0m"; }
bld() { printf "\033[1m"; }

# ── ASCII art (small Karma "K" with palette dots) — left column ──────────────
# Each line is 16 chars wide. Empty leading line for vertical spacing.
art_lines=(
  "                "
  "  ██╗  ██╗      "
  "  ██║ ██╔╝      "
  "  █████╔╝       "
  "  ██╔═██╗       "
  "  ██║  ██╗      "
  "  ╚═╝  ╚═╝      "
  "                "
)

# ── Fetch-style system info — right column ───────────────────────────────────
info_lines=(
  ""
  "$(bld)$(fg $GRN_R $GRN_G $GRN_B)karma$(rst)$(fg $FG_R $FG_G $FG_B)@$(rst)$(bld)$(fg $YEL_R $YEL_G $YEL_B)iterm2$(rst)"
  "$(fg $GRY_R $GRY_G $GRY_B)──────────────────────$(rst)"
  "$(fg $RED_R $RED_G $RED_B)theme$(rst)     $(fg $FG_R $FG_G $FG_B)${THEME_NAME}$(rst)"
  "$(fg $RED_R $RED_G $RED_B)variant$(rst)   $(fg $FG_R $FG_G $FG_B)refined ANSI 16$(rst)"
  "$(fg $RED_R $RED_G $RED_B)source$(rst)    $(fg $FG_R $FG_G $FG_B)sreetamdas/karma$(rst)"
  "$(fg $RED_R $RED_G $RED_B)license$(rst)   $(fg $FG_R $FG_G $FG_B)MIT$(rst)"
  ""
)

# ── Render top section: art on left, info on right ───────────────────────────
echo
for i in "${!art_lines[@]}"; do
  printf "  $(fg $HLT_R $HLT_G $HLT_B)%s$(rst)   %b\n" "${art_lines[$i]}" "${info_lines[$i]}"
done

# ── ANSI 0-15 numerical strip (each digit in its own color) ──────────────────
echo
printf "  "
# Row of 16 colored numbers, padded for alignment
i=0
for color in \
  "$WHT_R $WHT_G $WHT_B" \
  "$RED_R $RED_G $RED_B" \
  "$GRN_R $GRN_G $GRN_B" \
  "$YEL_R $YEL_G $YEL_B" \
  "$BLU_R $BLU_G $BLU_B" \
  "$MAG_R $MAG_G $MAG_B" \
  "$CYA_R $CYA_G $CYA_B" \
  "$WHT_R $WHT_G $WHT_B" \
  "$GRY_R $GRY_G $GRY_B" \
  "$BR_RED_R $BR_RED_G $BR_RED_B" \
  "$BR_GRN_R $BR_GRN_G $BR_GRN_B" \
  "$BR_YEL_R $BR_YEL_G $BR_YEL_B" \
  "$BR_BLU_R $BR_BLU_G $BR_BLU_B" \
  "$BR_MAG_R $BR_MAG_G $BR_MAG_B" \
  "$BR_CYA_R $BR_CYA_G $BR_CYA_B" \
  "$BR_WHT_R $BR_WHT_G $BR_WHT_B"
do
  read -r r g b <<< "$color"
  if (( i < 9 )); then
    printf "$(bld)$(fg $r $g $b) %d $(rst) " "$i"
  else
    printf "$(bld)$(fg $r $g $b)%d $(rst) " "$i"
  fi
  i=$((i + 1))
done
echo
echo

# ── Empty prompt at the bottom (catppuccin-style) ────────────────────────────
printf "  $(fg $BLU_R $BLU_G $BLU_B)~$(rst)\n"
printf "$(bld)$(fg $BLU_R $BLU_G $BLU_B)λ$(rst) \n"
