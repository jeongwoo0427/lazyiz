# lazyiz — Neovim 개인 설정

LazyVim 기반. Python(Jupyter), Flutter, TypeScript/React 개발 환경 포함.

---

## 설치 순서

### 1. 의존성 설치

**macOS**
```bash
brew install neovim python@3.11 node git ripgrep fd
```

**Linux (Ubuntu)**
```bash
sudo add-apt-repository ppa:neovim-ppa/unstable -y && sudo apt update
sudo apt install -y neovim python3 python3-pip nodejs npm git ripgrep
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

## Python (Jupyter 스타일 실행)

시스템 Python을 직접 쓰지 않고, **`~/.venvs/molten` 전용 venv**를 만들어 커널을 등록해서 사용한다.

---

### 1단계 — Molten 전용 venv 생성 (최초 1회)

```bash
python3 -m venv ~/.venvs/molten
```

---

### 2단계 — 패키지 설치 & 커널 등록

```bash
source ~/.venvs/molten/bin/activate
# 프롬프트 앞에 (molten) 표시가 나타나면 정상

pip install pynvim jupyter_client ipykernel

python -m ipykernel install --user --name molten --display-name "Python (molten)"

deactivate
```

등록된 커널 목록 확인:
```bash
jupyter kernelspec list
```

> **runtime 디렉토리가 없으면 생성:**
> ```bash
> mkdir -p ~/.local/share/jupyter/runtime      # Linux
> mkdir -p ~/Library/Jupyter/runtime           # macOS
> ```

---

### 3단계 — molten remote plugin 등록 (최초 1회 필수)

> 이 단계를 빠뜨리면 `E492: Not an editor command: MoltenEvaluateLine` 에러 발생.

```bash
nvim --headless \
  -c "let g:python3_host_prog=expand('~/.venvs/molten/bin/python3')" \
  -c "set rtp+=~/.local/share/nvim/lazy/molten-nvim" \
  -c "UpdateRemotePlugins" \
  -c "qa"
```

---

### 사용법

`.py` 파일에서 `# %%` 로 셀 구분:

```python
# %% 셀 1
import numpy as np
print(np.array([1,2,3]).mean())

# %% 셀 2
print("다른 셀")
```

**워크플로:**
1. `:MoltenInit` — 커널 목록에서 `Python (molten)` 선택
2. 이후 셀 실행

| 키 | 동작 |
|----|------|
| `:MoltenInit` | 커널 선택 후 시작 |
| `<leader>ml` | 현재 줄 실행 |
| `v` 선택 후 `<leader>mv` | 선택 영역 실행 |
| `<leader>mo` / `<leader>mh` | 출력 창 표시 / 숨기기 |
| `<leader>ms` | 실행 중단 |
| `<leader>mR` | 커널 재시작 |
| `<leader>cv` | 가상환경 변경 (VenvSelect) |

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
| `E492: Not an editor command: MoltenEvaluateLine` | molten remote plugin 등록 단계 재실행 |
| `Could not initialize kernel named ...` | `jupyter kernelspec list` 로 커널 등록 확인, `.venv/bin/python -m ipykernel install --user` 재실행 |
| `No module named 'pynvim'` | `source ~/.venvs/molten/bin/activate && pip install pynvim` 후 remote plugin 등록 재실행 |
| `Failed to load python3 host` | `~/.venvs/molten/bin/python3` 파일 존재 확인, 없으면 1단계부터 재실행 |
| VenvSelect branch 경고 | `lua/plugins/python.lua` 에서 `branch = "main"` 확인 |

