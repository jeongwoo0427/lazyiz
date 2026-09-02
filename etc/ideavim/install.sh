#!/usr/bin/env bash
# ideavimrc 설치 — JetBrains 계열 IDE(Android Studio, IntelliJ 등) 공용
#
#   ./install.sh          설치
#   ./install.sh --check  현재 상태만 확인
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/ideavimrc"
DEST="$HOME/.ideavimrc"

info() { printf '  %s\n' "$*"; }
ok()   { printf '  \033[32m✓\033[0m %s\n' "$*"; }
warn() { printf '  \033[33m!\033[0m %s\n' "$*"; }

echo
echo "ideavimrc 설치"
echo "────────────────────────────────────────────"

[ -f "$SRC" ] || { echo "  ✗ ideavimrc 를 찾을 수 없습니다: $SRC"; exit 1; }
ok "설정 파일: $SRC"

# --- IdeaVim 플러그인 확인 -------------------------------------------------
found=0
for d in "$HOME"/Library/Application\ Support/Google/*/plugins/IdeaVIM \
         "$HOME"/Library/Application\ Support/JetBrains/*/plugins/IdeaVIM \
         "$HOME"/.local/share/Google/*/IdeaVIM \
         "$HOME"/.local/share/JetBrains/*/IdeaVIM; do
  [ -d "$d" ] || continue
  ide=$(basename "$(dirname "$(dirname "$d")")")
  ok "IdeaVim 설치됨: $ide"
  found=1
done
[ "$found" -eq 1 ] || warn "IdeaVim 플러그인이 안 보입니다 → IDE의 Settings → Plugins → Marketplace 에서 'IdeaVim' 설치"

if [ "${1:-}" = "--check" ]; then
  [ -L "$DEST" ] && ok "링크 상태: $DEST -> $(readlink "$DEST")" || warn "아직 설치되지 않음"
  echo; exit 0
fi

# --- 링크 걸기 --------------------------------------------------------------
if [ -L "$DEST" ] && [ "$(readlink "$DEST")" = "$SRC" ]; then
  ok "이미 올바르게 연결돼 있습니다"
elif [ -e "$DEST" ] || [ -L "$DEST" ]; then
  BACKUP="$DEST.backup.$(date +%Y%m%d%H%M%S)"
  mv "$DEST" "$BACKUP"
  warn "기존 파일을 백업했습니다: $BACKUP"
  ln -s "$SRC" "$DEST"
  ok "새로 연결했습니다"
else
  ln -s "$SRC" "$DEST"
  ok "연결했습니다: $DEST -> $SRC"
fi

echo "────────────────────────────────────────────"
echo "  다음: IDE 재시작, 또는 에디터 노멀 모드에서"
echo "        :source ~/.ideavimrc"
echo
