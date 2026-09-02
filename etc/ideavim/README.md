# ideavimrc — JetBrains IDE를 LazyVim 손버릇으로

Android Studio / IntelliJ 등 JetBrains 계열 IDE의 IdeaVim을
`~/.config/nvim` 설정과 같은 조작감으로 맞춘 설정입니다.
nvim 설정 저장소 안에 `etc/ideavim` 으로 함께 관리됩니다.

**IDE 키맵(Settings → Keymap)은 건드리지 않습니다.** 전부 이 파일 하나로만 동작하므로,
지우면 IDE는 즉시 순정 상태로 돌아갑니다.

```
ideavimrc      설정 본체
install.sh     설치 (심볼릭 링크 + 사전 조건 확인)
uninstall.sh   제거
README.md      이 문서
```

---

## 새 PC에 설치

**1. IdeaVim 플러그인 설치** — IDE에서 `Settings → Plugins → Marketplace → "IdeaVim"`

**2. nvim 설정 저장소를 클론** — 이 폴더는 그 안에 함께 들어 있습니다

```bash
git clone https://github.com/jeongwoo0427/lazyiz ~/.config/nvim
```

**3. 설치 스크립트 실행**

```bash
~/.config/nvim/etc/ideavim/install.sh
```

**4. IDE 재시작**

설치 전에 상태만 보고 싶으면 `install.sh --check`.
기존 `~/.ideavimrc` 가 있으면 타임스탬프를 붙여 자동 백업합니다.

nvim 설정과 IDE 설정이 한 저장소에 있으므로, 클론 한 번이면 둘 다 따라옵니다.
다른 위치에 두고 싶으면 폴더째 옮긴 뒤 그 자리의 `install.sh` 를 실행하면 됩니다
(스크립트가 자기 위치를 기준으로 링크를 겁니다).

---

## 수정 후 반영

IDE 재시작 없이, **에디터 노멀 모드**에서:

```
:source ~/.ideavimrc
```

> 셸이 아니라 IDE 에디터 안에서 칩니다. `:` 를 누르면 편집기 하단에 vim 명령줄이 생깁니다.

---

## 키맵

### 창 이동

| 키 | 동작 |
|---|---|
| `Ctrl+h` | 프로젝트 트리 |
| `Ctrl+j` | 터미널 |
| `Ctrl+k` `Ctrl+l` | 에디터로 복귀 |
| `Esc` | 툴 윈도우 → 에디터 (IDE 기본) |
| `Ctrl+w` + `h/j/k/l` | 에디터 분할 간 이동 |
| `<leader>wv` `<leader>ws` | 세로 / 가로 분할 |
| `<leader>wd` | 분할 닫기 |

### 편집 (nvim keymaps.lua 이식)

| 키 | 동작 |
|---|---|
| `;j` | Esc |
| `<leader>j` `<leader>k` | 10줄 아래 / 위 |
| `T` | 탭 닫기 |
| `<leader>l` | 포맷 + import 정리 |
| `<leader><CR>` | 코드 액션 |
| `<leader>.` | 시그니처 도움말 |
| `<leader>h` | 호버 (문서) |
| `<leader>r` | 이름 바꾸기 |
| `d` `x` `D` | 삭제 (클립보드 안 건드림) |
| visual `x` | 잘라내기 |

### 이동 · 검색

| 키 | 동작 |
|---|---|
| `H` `L` | 이전 / 다음 탭 |
| `<leader>ff` | 파일 찾기 |
| `<leader>fg` `<leader>/` | 전체 검색 |
| `<leader>,` | 최근 파일 |
| `gd` `gI` | 정의 / 구현 |
| `gr` `gR` | 사용처 (팝업 / 창) |
| `]d` `[d` | 다음 / 이전 에러 |

### 툴 윈도우 · 실행

| 키 | 동작 |
|---|---|
| `<leader>e` `<leader>t` | 프로젝트 / 터미널 |
| `<leader>xx` `<leader>gg` | 문제 / 버전 관리 |
| `<leader>rr` `<leader>rd` | 실행 / 디버그 |
| `Ctrl+s` | 저장 |
| `<leader>ur` | 검색 하이라이트 끄기 |

### 프로젝트 트리 (NERDTree 확장)

트리에 포커스가 있을 때 vim 키가 그대로 먹습니다.

| 키 | 동작 |
|---|---|
| `j` `k` | 아래 / 위 |
| `h` `l` | 접기 / 펼치기 |
| `o` `Enter` | 열기 |
| `gg` `G` | 처음 / 끝 |
| `q` | 트리 닫기 |

### 확장

`surround` `commentary` `highlightedyank` `matchit` `argtextobj`
`textobj-entire` `ReplaceWithRegister` `exchange` `sneak` `NERDTree`

---

## 되돌리기

| 범위 | 방법 |
|---|---|
| 이 설정만 끄기 | `~/.config/nvim/etc/ideavim/uninstall.sh` |
| IdeaVim 자체 끄기 | IDE 메뉴 → Tools → Vim (체크 해제) |
| 완전 삭제 | `uninstall.sh` 실행 후 `rm -rf ~/.config/nvim/etc/ideavim` |

---

## 커스터마이즈

### 액션 ID 찾기

새 매핑을 추가하려면 IDE 액션 이름이 필요합니다. 에디터에서:

```
:actionlist Reformat
```

검색어에 맞는 액션 ID 목록이 나옵니다. 그걸로:

```vim
nmap <leader>x <Action>(액션ID)
```

### 키 충돌 처리

IDE 기본 단축키와 겹치는 키는 `sethandler` 로 소유자를 지정합니다.

```vim
sethandler <C-h> a:vim        " 모든 모드에서 vim이 처리
sethandler <Tab> n:vim i:ide  " 노멀은 vim, 인서트는 IDE
```

이걸 파일에 적어두면 새 PC에서 IDE 충돌 대화상자를 다시 클릭할 필요가 없습니다.

---

## 주의할 점

**`set` 뒤에 같은 줄로 주석을 달면 안 됩니다.** vim이 `"` 를 옵션 값으로 읽어
`unknown option: "` 에러가 납니다. 주석은 반드시 별도 줄에 씁니다.

```vim
" 이렇게 (O)
set scrolloff=8

set scrolloff=8   " 이렇게 하면 에러 (X)
```

**툴 윈도우 안에서는 이 파일의 매핑이 동작하지 않습니다.** IdeaVim은 에디터만 담당합니다.
프로젝트 트리는 `set NERDTree` 가 따로 처리해주지만, `Ctrl+k` `Ctrl+l` 같은
이 파일의 매핑은 트리·터미널 안에서 먹지 않습니다. 돌아올 때는 `Esc` 를 씁니다.

**터미널에서 돌아오기는 IDE 설정이 필요합니다.** 최신 IDE는 터미널의 `Esc` 를
셸로 그대로 보내도록 바뀌었고, `Terminal.SwitchFocusToEditor` 액션에는
기본 단축키가 없습니다. 아래에서 직접 지정하세요.

```
Settings → Tools → Terminal → "Move focus to the Editor with:"
```

이건 IDE 설정이라 **이 폴더를 옮기는 것만으로는 재현되지 않습니다.**
새 PC에서 한 번 더 지정해야 합니다.

**`<leader>l` 은 두 액션을 연달아 실행합니다.** IdeaVim이 액션을 비동기로 처리해서
드물게 뒤엣것(import 정리)이 씹힐 수 있습니다. 그럴 땐 두 줄로 나누세요.

```vim
nmap <leader>l <Action>(ReformatCode)
nmap <leader>L <Action>(OptimizeImports)
```
