# Personal Dotfiles

chezmoi で管理している個人のdotfiles

**前提条件**: PCにgitがインストール済みであること

## セットアップ

### chezmoiインストール

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

### dotfiles適用

```bash
# 初期化
chezmoi init git@github.com:wataru-script/dotfiles.git

# 変更内容確認
chezmoi diff

# 適用（パッケージも自動インストール）
chezmoi apply -v
```

## 使用方法

### 設定ファイルの変更
```bash
# 1. ソースディレクトリでファイル編集（VSCodeなど任意のエディタ）
code $(chezmoi source-path)

# 2. 変更を適用
chezmoi apply -v
```

### 新しいファイルを管理対象に追加
```bash
# ファイルをchezmoiに追加
chezmoi add ~/.gitconfig

# ソースディレクトリに移動してコミット
cd $(chezmoi source-path)
git add .
git commit -m "Add gitconfig"
```

### パッケージリストの更新
```bash
# ソースディレクトリでインストールスクリプトを編集
cd $(chezmoi source-path)
code run_onchange_install-packages.sh.tmpl

# 変更を適用
chezmoi apply
```

## 仕組み

### テンプレート機能
`.tmpl` ファイルでOS別設定を切り替え
```go-template
{{ if eq .chezmoi.os "darwin" -}}
# macOS用設定
{{ else if eq .chezmoi.os "linux" -}}
# Linux用設定
{{ end -}}
```

### 自動パッケージインストール
`run_onchange_install-packages.sh.tmpl` がファイル変更時に自動実行される

## よく使うコマンド

```bash
# ソースディレクトリの場所を確認（編集時に使用）
chezmoi source-path

# 管理対象ファイル一覧を表示
chezmoi managed

# 現在の状態と管理ファイルの差分確認
chezmoi diff

# 実際の適用前に何が変更されるかを確認
chezmoi apply --dry-run --verbose

# 既存ファイルがあっても強制上書きして適用
chezmoi apply --force

# 特定ファイルのみ適用
chezmoi apply ~/.zshrc

# 新しいファイルを管理対象に追加
chezmoi add ~/.gitconfig

# ファイルの編集（テンプレートファイルを直接編集）
chezmoi edit ~/.zshrc

# リモートリポジトリから最新を取得して適用
chezmoi update
```

## トラブルシューティング

**パッケージインストールエラー**
```bash
# macOS
brew update && brew doctor

# Arch Linux
sudo pacman -Syu
```

**リセット**
```bash
rm -rf ~/.local/share/chezmoi ~/.config/chezmoi
chezmoi init git@github.com:wataru-script/dotfiles.git
```

## 機微情報管理

現在は機微情報の管理は想定していないが、将来的に必要になった場合は1Passwordとの連携を検討する。

### 1Password連携の方針
- API Key、パスワード等の機微情報は1Passwordで管理
- chezmoiの1Password連携機能を使用してテンプレートから参照
- 環境変数や設定ファイルに平文で記載しない

参考: [chezmoi 1Password integration](https://www.chezmoi.io/user-guide/password-managers/1password/)