# BibGraph

BibTeXエントリー間の引用関係をグラフ構造（DAG）として可視化および管理するためのコマンドラインツール。

## 機能
- `x-cites`フィールドに基づいた引用関係の抽出。
- ターミナル上での階層構造表示（`tty-tree`利用）。
- グラフ画像（PNG/PDF）の出力（`Graphviz`利用）。
- 循環参照の自動検知。

## インストール手順

### 依存パッケージ
Graphvizがインストールされている必要がある。
```bash
# macOS
brew install graphviz

# Ubuntu
sudo apt-get install graphviz