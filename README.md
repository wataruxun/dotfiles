# dotfiles (chezmoiで管理)

[![chezmoi logo](https://www.chezmoi.io/logo.svg)](https://www.chezmoi.io)

このリポジトリは、[chezmoi](https://www.chezmoi.io/) を使って管理している個人のdotfilesです。複数のOSで一貫した環境を構築できるように設計されています。

## ✨ 主な特徴

- **クロスプラットフォーム対応**: **macOS**, **Arch Linux**, **Windows (WSL2)** の環境をサポートします。
- **セットアップの自動化**: 各OSに必要なパッケージやツールを自動でインストールします。
- **一貫した開発環境**: ターミナル、エディタ (Vim/Neovim)、各種ツールの設定を常に同期します。

---

## 🚀 セットアップ方法

新しいマシンにこのdotfilesをセットアップする手順です。

### 1. 事前準備

**Gitのインストール**
```sh
# macOS (Xcode Command Line Toolsに含まれています)
xcode-select --install

# Arch Linux
sudo pacman -S git
```

**chezmoiのインストール**
```sh
# macOS または Linux
sh -c "$(curl -fsLS get.chezmoi.io)"
```
*その他のインストール方法は[公式ドキュメント](https://www.chezmoi.io/install/)を参照してください。*

### 2. インストール手順

1.  **chezmoiを初期化**
    ```sh
    # "wataru-script/dotfiles.git" の部分はご自身のものに置き換えてください
    chezmoi init https://github.com/wataru-script/dotfiles.git
    ```

2.  **変更内容の確認（推奨）**
    ホームディレクトリにどのような変更が加わるかを事前に確認します。
    ```sh
    chezmoi diff
    ```

3.  **dotfilesの適用**
    ```sh
    chezmoi apply -v
    ```
    初回は `-v` (verbose) オプション付きでの実行を推奨します。このコマンドにより、以下の処理が実行されます。
    - ホームディレクトリに設定ファイルが展開されます。
    - インストールスクリプトが実行され、必要なパッケージが自動でインストールされます (macOSでは`brew`、Linuxでは`pacman`を使用)。

---

## 🔧 このリポジトリの仕組み

`chezmoi`の便利な機能を活用して、OSごとの差異を吸収しています。

### OS固有の設定

- **テンプレート機能 (`.tmpl`)**: `.zshrc.tmpl` のように、末尾が `.tmpl` のファイルにはGo言語のテンプレート構文を記述できます。これにより、OSに応じて設定内容を切り替えています。
  ```go-template
  {{ if eq .chezmoi.os "darwin" -}}
  # macOS固有の設定
  {{ else if eq .chezmoi.os "linux" -}}
  # Linux固有の設定
  {{ end -}}
  ```

### パッケージの自動インストール

- **実行スクリプト (`run_*.sh`)**: `run_onchange_install-packages.sh.tmpl` というスクリプトは、`chezmoi apply`実行時に内容の変更を検知して自動で実行されます。
- このスクリプトがOSを判別し、`brew`や`pacman`といったパッケージマネージャーを使って、`zsh`, `neovim`, 各種LSPサーバーまで、必要なツールをすべてインストール・更新します。

---

## 🛠️ メンテナンス方法

### 既存のファイルを変更する

1.  `chezmoi`のソースディレクトリ内にあるファイルを直接編集します。ソースディレクトリのパスは以下のコマンドで確認できます。
    ```sh
    chezmoi source-path
    ```
2.  編集後、変更を適用します。
    ```sh
    chezmoi apply -v
    ```

### 新しいファイルを追加する

1.  管理したいファイルを`chezmoi`に追加します。例えば `~/.gitconfig` を追加する場合：
    ```sh
    chezmoi add ~/.gitconfig
    ```
2.  ファイルがソースディレクトリにコピーされるので、必要に応じて編集し、Gitにコミットしてください。

### 対応パッケージを更新する

1.  インストールスクリプトをエディタで開きます。
    ```sh
    # $EDITORにはお使いのエディタが入ります
    $EDITOR "$(chezmoi source-path)/run_onchange_install-packages.sh.tmpl"
    ```
2.  対象OSのパッケージリストを編集（追加・削除）します。
3.  `chezmoi apply` を実行すると、更新されたスクリプトが実行されます。
