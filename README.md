# Personal Dotfiles

chezmoi で管理している個人のdotfiles

## 📍 chezmoiファイルの場所

**ソースディレクトリ**: `~/.local/share/chezmoi/`（このREADMEがある場所）

迷ったら以下のコマンドで確認:
```bash
chezmoi source-path
```

**管理されているファイルたち**:
- `.zshrc` - zsh設定（OS別に自動切り替え）
- `.tmux.conf` - tmux設定
- `.vimrc` - vim設定
- `.config/nvim/` - neovim設定
- `install-packages.sh` - パッケージ自動インストールスクリプト

---

**前提条件**: PCにgitがインストール済みであること

## 🚀 新しいマシンでのセットアップ

### 1. chezmoiをインストール

**macOS**
```bash
brew install chezmoi
```

**Arch Linux**
```bash
sudo pacman -S chezmoi
```

**その他/汎用**
```bash
sh -c "$(curl -fsLS get.chezmoi.io)"
```

### 2. dotfilesを初期化して適用

```bash
# リポジトリから初期化（~/.local/share/chezmoi/ にクローンされる）
chezmoi init git@github.com:wataru-script/dotfiles.git

# 何が変更されるか確認
chezmoi diff

# 適用（パッケージも自動インストールされる）
chezmoi apply -v
```

これだけで以下が自動的に実行されます:
- ✅ dotfilesがホームディレクトリに配置
- ✅ OS別の設定が自動選択（macOS/Linux）
- ✅ 必要なパッケージが自動インストール

## 📝 日常的な使い方（既にchezmoiを使っているマシン）

### よくある作業フロー

**1. 設定ファイルを編集したい**
```bash
# ソースディレクトリを開く（~/.local/share/chezmoi/）
code $(chezmoi source-path)

# または直接編集
chezmoi edit ~/.zshrc

# 変更を適用
chezmoi apply -v
```

**2. 他のマシンの変更を取り込みたい**
```bash
# リモートから最新を取得して適用
chezmoi update
```

**3. 新しいファイルをchezmoiで管理したい**
```bash
# ファイルを追加
chezmoi add ~/.gitconfig

# ソースディレクトリでコミット
cd $(chezmoi source-path)
git add .
git commit -m "Add gitconfig"
git push
```

**4. パッケージを追加/削除したい**
```bash
# インストールスクリプトを編集
cd $(chezmoi source-path)
code run_onchange_install-packages.sh.tmpl

# 適用（変更検知で自動実行される）
chezmoi apply -v
```

### マシン固有の設定（オプション）
chezmoiで管理する共通設定とは別に、特定のマシンでのみ必要な設定を追加できます。

```bash
# ~/.zshrc.localを作成・編集
code ~/.zshrc.local
```

**~/.zshrc.local の例**
```bash
#!/bin/zsh
# Machine-specific settings

# 会社専用の環境変数
export COMPANY_PROXY="http://proxy.example.com:8080"

# このマシン専用のエイリアス
alias work="cd ~/Projects/work"

# 特定アプリケーションの設定
export EDITOR="code"
```

**ポイント**
- `.zshrc.local` は `.chezmoiignore` で除外されているため、chezmoiで管理されません
- ファイルが存在しない環境でも `.zshrc` は正常に動作します
- マシン固有の設定（プロキシ、パス、機密情報など）をGitにコミットせずに管理できます

## 🔍 仕組みの理解

### OS別の設定はどう管理されている？

`.tmpl` ファイルでOS別設定を自動切り替え:
```go-template
{{ if eq .chezmoi.os "darwin" -}}
# macOS用設定（例: Homebrew のパス）
{{ else if eq .chezmoi.os "linux" -}}
# Linux用設定（例: pacman のパス）
{{ end -}}
```

**使い分け**:
- **OS依存の設定** → `.tmpl` で条件分岐（例: パッケージマネージャのパス）
- **マシン固有の設定** → `~/.zshrc.local`（例: 会社のプロキシ、Docker設定）

### パッケージの自動インストール

`run_onchange_install-packages.sh.tmpl` がファイル変更時に自動実行される仕組み:
1. ファイル内容が変更されたことを検知
2. `chezmoi apply` 時に自動でスクリプト実行
3. OS別に適切なパッケージマネージャを使用

## 📚 コマンドリファレンス

### 確認系
```bash
# ソースディレクトリの場所
chezmoi source-path              # → ~/.local/share/chezmoi/

# 管理対象ファイル一覧
chezmoi managed

# ホームディレクトリとの差分
chezmoi diff
```

### 編集・適用
```bash
# ファイルを編集（ソースファイルを直接開く）
chezmoi edit ~/.zshrc

# 全体を適用
chezmoi apply -v

# 特定ファイルのみ適用
chezmoi apply ~/.zshrc

# ドライラン（何が変更されるか確認のみ）
chezmoi apply --dry-run --verbose
```

### 同期
```bash
# リモートから最新を取得して適用
chezmoi update
```

### その他
```bash
# 新しいファイルを管理対象に追加
chezmoi add ~/.gitconfig

# 既存ファイルがあっても強制上書き
chezmoi apply --force
```

## ⚠️ トラブルシューティング

### パッケージインストールエラー
```bash
# macOS
brew update && brew doctor

# Arch Linux
sudo pacman -Syu
```

### chezmoi apply時に上書きを拒否される
```bash
# 差分を確認
chezmoi diff

# 問題なければ強制上書き
chezmoi apply --force
```

### 設定をリセットしたい
```bash
# chezmoiの状態を削除
rm -rf ~/.local/share/chezmoi ~/.config/chezmoi

# 再度初期化
chezmoi init git@github.com:wataru-script/dotfiles.git
chezmoi apply -v
```

### ソースディレクトリが見つからない
```bash
# 場所を確認
chezmoi source-path

# まだ初期化されていない場合
chezmoi init git@github.com:wataru-script/dotfiles.git
```

---

## 🔒 機微情報の扱い

**現在の方針**: 機微情報は `~/.zshrc.local` に記載（Gitにコミットしない）

**将来的な選択肢**: 1Password連携
- API Key、パスワード等を1Passwordで管理
- chezmoiの1Password連携機能でテンプレートから参照
- 参考: [chezmoi 1Password integration](https://www.chezmoi.io/user-guide/password-managers/1password/)

---

## 📖 参考情報

- **公式ドキュメント**: https://www.chezmoi.io/
- **このリポジトリ**: https://github.com/wataru-script/dotfiles