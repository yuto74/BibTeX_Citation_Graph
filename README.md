# BibGraph
AIとの対話ログはAI_log.orgに保存している。

BibTeXファイル（`.bib`）に含まれる論文間の引用関係を解析し、有向非巡回グラフ（DAG）として可視化・管理するRuby製コマンドラインツール。

## 機能

* **階層構造表示**: 指定したエントリーを起点とする引用関係をターミナル上にツリー形式で表示する。
* **メタデータ付与**: 出力時に発行年、著者、タイトルを自動的に併記する。
* **探索深度制限**: 指定した階層数（Depth）で探索を終了する。
* **グラフエクスポート**: 全体またはフィルタリングした引用関係をPNG/PDF形式の画像ファイルとして出力する。
* **循環参照検知**: 深さ優先探索（DFS）を用いて引用のループを検知し、異常時はエラーを送出する。

## 動作環境・前提条件

* **Ruby**: 3.2 以上
* **システム依存**: Graphviz (`dot`コマンドが実行可能であること)

```bash
# UbuntuでのGraphvizインストール
sudo apt-get install graphviz

# macOSでのGraphvizインストール
brew install graphviz

```

## インストール

```bash
git clone https://github.com/yuto74/BibTeX_Citation_Graph.git
cd BibTeX_Citation_Graph
bundle install
rake install

```

## BibTeXファイルの記述形式

本ツールは、各エントリー内の `x-cites` フィールドを引用情報として解釈する。複数の引用先はカンマ区切りで記述する。

```bibtex
@article{EntryA,
  author = {Author Name},
  title = {Paper Title},
  year = {2025},
  x-cites = {EntryB, EntryC}
}

```

---

## 使用方法

### 1. 引用ツリーの表示 (`tree`)

特定の論文を起点とした引用階層を表示する。

```bash
# 基本実行
bib_graph tree [CITEID] --dir [BIB_DIR]

# 探索深度を1段階に制限
bib_graph tree Knuth1984 --dir ./bibs --depth 1

```

### 2. グラフのエクスポート (`export`)

引用関係を画像化する。フィルタリングオプションにより、特定のノードのみを抽出可能。

| オプション | 引数型 | 内容 |
| --- | --- | --- |
| `--dir` | String | `.bib`ファイルが格納されたディレクトリ（デフォルト: `.`） |
| `--format` | String | `png` または `pdf`（デフォルト: `png`） |
| `--author` | String | 著者名による部分一致フィルタ |
| `--year` | String | 発行年による完全一致フィルタ |
| `--query` | String | タイトルに含まれるキーワードによる部分一致フィルタ |

```bash
# 著者が 'Shannon' の論文のみを抽出して画像化
bib_graph export shannon.png --dir ./bibs --author Shannon

# 特定のキーワードを含むグラフをPDFで出力
bib_graph export search_result.pdf --query "Theory" --format pdf

```

---

## 開発・テスト

RSpecによる自動テストを実行する。

```bash
bundle exec rspec

```

テスト項目には以下の内容が含まれる。

1. 正常なBibTeXデータからの木構造ハッシュ構築の検証。
2. 循環参照（A→B→A等）が含まれる場合の例外送出の確認。
3. メタデータの正確なパースおよびラベル生成の検証。