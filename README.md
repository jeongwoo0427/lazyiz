# lazyiz — Neovim 개인 설정

LazyVim 기반. Python(uv, Jupyter), Flutter, TypeScript/React 개발 환경 포함.

---

## 설치 순서

### 1. 의존성 설치

> Python은 따로 설치하지 않는다. **uv**가 프로젝트마다 필요한 Python 버전까지 알아서 내려받는다.
> `imagemagick` 는 molten 그래프(matplotlib 등)를 image.nvim 으로 렌더링하는 데 필요하다.
> 없으면 출력 창은 열려도 그림이 안 보인다.

**macOS**
```bash
brew install neovim uv node git ripgrep fd imagemagick
```

**Linux (Ubuntu)**
```bash
sudo add-apt-repository ppa:neovim-ppa/unstable -y && sudo apt update
sudo apt install -y neovim nodejs npm git ripgrep imagemagick curl
curl -LsSf https://astral.sh/uv/install.sh | sh
```

---

### 2. 클론

```bash
# 기존 설정 백업 (있다면)
mv ~/.config/nvim ~/.config/nvim.bak

git clone https://github.com/<your-username>/lazyiz ~/.config/nvim
```

---

### 3. 플러그인 설치

```bash
nvim  # 실행하면 lazy.nvim이 자동으로 플러그인 설치 시작
```

설치 완료 후 `:Lazy sync` 한 번 더 실행하고 재시작.

---

## Python (uv)

**uv만 설치돼 있으면 된다.** Python 버전, 가상환경(`.venv`), 패키지는 프로젝트마다 uv가 관리한다.
전역 venv나 `pip install` 은 쓰지 않는다.

```bash
uv init myproject && cd myproject
uv add numpy matplotlib   # .venv 생성 + 패키지 설치
uv run myproject          # 실행 (src/myproject/__init__.py 의 main)
nvim                      # 꼭 프로젝트 루트에서 켠다
```

> 파일 하나만 돌릴 땐 `uv run 파일.py`.

- pyright(LSP)는 **nvim을 켠 폴더의 `.venv`** 를 분석한다 (`lua/plugins/python.lua`).
  그래서 프로젝트 루트에서 켜야 import 오류가 안 뜬다.
- nvim을 켠 뒤에 `.venv` 가 생겼다면(`uv add`/`uv sync`) `:LspRestart` 한 번.

---

## Jupyter / Colab 스타일 셀 실행 (molten, 선택)

셀 단위 실행이 필요할 때만 설정한다. 필요한 건 두 가지다.
- **molten 호스트** `~/.venvs/molten`: nvim이 쓰는 환경. `pynvim` + `jupyter_client` 만 넣는다.
  (`lua/config/options.lua` 가 이 venv를 자동 감지 → 없으면 시스템 python3로 폴백)
- **커널**: 코드가 실제로 도는 환경. 각 프로젝트의 `.venv` 를 커널로 등록해서 쓴다.
  numpy 같은 라이브러리는 호스트가 아니라 프로젝트에 `uv add` 한다.

### 1단계 — molten 호스트 만들기 (최초 1회)

```bash
uv venv ~/.venvs/molten
uv pip install --python ~/.venvs/molten pynvim jupyter_client

# Jupyter runtime 디렉토리 보장 (없으면 커널 connection 파일을 못 써서
# "Could not initialize kernel" 에러. 경로는 jupyter가 직접 계산 → OS 무관)
~/.venvs/molten/bin/python -c "import os, jupyter_core.paths as p; os.makedirs(p.jupyter_runtime_dir(), exist_ok=True)"
```

### 2단계 — molten remote plugin 등록 (최초 1회 필수)

> 빼먹으면 `:MoltenInit` 등 명령어 자체가 없다 (`E492` 에러).
> molten은 lazy-load라 headless 모드에선 runtimepath에 안 올라오므로 `set rtp+=` 가 꼭 필요하다.

```bash
nvim --headless \
  -c "set rtp+=~/.local/share/nvim/lazy/molten-nvim" \
  -c "UpdateRemotePlugins" \
  -c "qa"
```

> 등록 후 **nvim을 완전히 재시작**해야 명령어가 반영된다.

### 3단계 — 프로젝트를 커널로 등록 (프로젝트마다 1회)

```bash
cd myproject
uv add --dev ipykernel
uv run python -m ipykernel install --user --name myproject
```

### 사용법

`.py` 파일에서 `# %%` 로 셀 구분:

```python
# %% 셀 1
import numpy as np
print(np.array([1,2,3]).mean())

# %% 셀 2
import matplotlib.pyplot as plt
plt.plot([1,2,3]); plt.show()
```

1. `<leader>mi` (`:MoltenInit`) → 커널 목록에서 3단계에서 등록한 **프로젝트 이름**(예: `myproject`) 선택
2. 이후 키로 셀 실행

| 키 | 동작 |
|----|------|
| `<leader>mi` | 커널 선택 후 시작 |
| `<leader>ml` | 현재 줄 실행 |
| `<leader>me` | 범위(operator) 실행 |
| `v` 선택 후 `<leader>mv` | 선택 영역 실행 |
| `<leader>mo` / `<leader>mh` | 출력 창 표시 / 숨기기 |
| `[c` / `]c` | 이전 / 다음 셀 |
| `<leader>ms` / `<leader>mR` | 실행 중단 / 커널 재시작 |

> **그래프 이미지**(matplotlib 등)는 kitty / wezterm / Ghostty 같은 이미지 지원 터미널에서만 보인다.
> iTerm2는 `lua/plugins/python.lua` 의 `image.nvim` backend를 `"ueberzug"` 로 변경. 기본 Terminal.app은 텍스트만 표시.

---

## Flutter

### 사전 설치

```bash
# FVM (Flutter Version Manager) 권장
brew install fvm        # macOS
# 또는: dart pub global activate fvm

fvm install stable
fvm global stable
```

> `lua/plugins/flutter.lua` 에 `fvm = true` 설정이 되어 있어 FVM 경로를 자동으로 잡는다.
> FVM 없이 Flutter 직접 설치했다면 `flutter_path` 주석을 해제하고 경로를 지정할 것.

```lua
-- flutter_path = "/path/to/flutter",  -- FVM 미사용 시
fvm = true,                             -- FVM 사용 시
```

---

## TypeScript / React

별도 플러그인 설정 없이 LazyVim 기본 extras로 동작.
`lazyvim.json` 에 아래가 활성화되어 있는지 확인:

```bash
cat ~/.config/nvim/lazyvim.json
```

없으면 nvim에서 `:LazyExtras` 실행 후 아래 항목 활성화:
- `lang.typescript`
- `lang.json`
- `formatting.prettier`

LSP(ts_ls), 자동완성, 포맷팅이 자동으로 설정된다.

---

## 트러블슈팅

| 에러 | 해결 |
|------|------|
| `Import "numpy" could not be resolved` 인데 실행은 됨 | nvim을 프로젝트 루트에서 켰는지 확인. 켠 뒤에 `.venv` 가 생겼으면 `:LspRestart` |
| `E492: Not an editor command: MoltenInit` | molten 2단계(remote plugin 등록) 재실행 |
| `No module named 'pynvim'` | 호스트에 설치 안 됨 → `uv pip install --python ~/.venvs/molten pynvim` 후 2단계 재실행 |
| `Could not initialize kernel named ...` | ① `No such file or directory: .../runtime/...json` 면 1단계의 runtime 디렉토리 보장 명령 재실행. ② 그 외엔 `~/.venvs/molten/bin/jupyter kernelspec list` 로 프로젝트 커널 확인, 없으면 3단계 재실행 |
| 셀 실행 시 `ModuleNotFoundError` | 프로젝트에서 `uv add <패키지>` 후 `<leader>mR` 로 커널 재시작 |
| `Failed to load python3 host` | `~/.venvs/molten/bin/python3` 존재 확인, 없으면 1단계부터 재실행 |
| 커널은 뜨는데 그래프가 안 보임 | ① `imagemagick` 설치 확인(`magick -version`) — image.nvim 렌더링 필수. ② 이미지 지원 터미널(kitty/wezterm/Ghostty) 사용. ③ 셀 실행 후 `<leader>mo` 로 출력 창 열기. ④ iTerm2면 `image.nvim` backend 를 `ueberzug` 로 변경 |

