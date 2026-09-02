#!/usr/bin/env bash
# ideavimrc 제거 — IDE 설정(Settings → Keymap)은 건드리지 않으므로
# 이 스크립트만으로 IDE는 순정 상태로 돌아간다.
set -euo pipefail
DEST="$HOME/.ideavimrc"

if [ -L "$DEST" ]; then
  rm "$DEST"; echo "  ✓ 제거했습니다: $DEST"
elif [ -e "$DEST" ]; then
  mv "$DEST" "$DEST.off"; echo "  ✓ 비활성화했습니다: $DEST.off"
else
  echo "  · 설치돼 있지 않습니다"
fi
echo "  IdeaVim 자체를 끄려면: IDE 메뉴 → Tools → Vim (체크 해제)"
