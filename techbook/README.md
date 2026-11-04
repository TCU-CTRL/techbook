# 技術合同誌の制作環境

TCU-CTRLの部員が各章を担当して、日本語の技術同人誌を制作するためのテンプレートです。
完成原稿ではなく、短い機能サンプルを収録しています。目標は48〜64ページですがページ数は固定しません。
既存プロジェクトの依存関係やビルドを変更せず、このディレクトリ内だけで動作します。

## 最初に行うこと

1. 下記のTeX環境を用意する。
2. ターミナルで `techbook/` に移動し、`make pdf` を実行する。
3. `build/main.pdf` をPDFビューアで開く。
4. `metadata.tex` の仮情報と、自分が担当する `chapters/` の原稿を編集する。
5. 再び `make pdf` を実行して確認する。文字コードはUTF-8を使用する。

## 使用技術と環境構築

LuaLaTeX、jlreq、latexmk、Gitを使用します。MakefileはmacOS/Linuxのmakeで動作します。
Python、Node.js、Pygments、BibTeX、Biberはビルドに不要です。
コード表示にはlistingsを使い、shell-escapeを無効にしています。

macOSでは [MacTeX](https://www.tug.org/mactex/) の導入を推奨します。
インストール後にターミナルを開き直してください。必要なら `/Library/TeX/texbin` をPATHに追加します。
LinuxではTeX Liveを導入します。Debian/Ubuntuの例：

```sh
sudo apt update
sudo apt install texlive-luatex texlive-lang-japanese texlive-latex-extra texlive-fonts-recommended latexmk make git
```

OS配布版とTUG配布版のTeX Liveを混在させず、同じ配布元でパッケージを管理してください。
必要なパッケージは `jlreq`, `luatexja`（presetを含む）, `fontspec`, `haranoaji`,
`lm`, `amsmath`, `amsfonts`, `amsthm`, `graphics`, `booktabs`, `xcolor`,
`listings`, `url`, `hyperref`, `latexmk` と、それぞれの依存パッケージです。
TUG版TeX Liveで不足がある場合は、その環境の管理権限で以下を実行します。

```sh
tlmgr install jlreq luatexja haranoaji lm fontspec amsmath amsfonts amscls graphics booktabs xcolor listings url hyperref latexmk
```

`File ... not found` が出たら該当パッケージを確認します。フォント不足の場合もOS固有フォントで代用せず、原ノ味・Latin Modernを導入すると全員の環境を揃えやすくなります。
初回はLuaLaTeXのフォントキャッシュ作成に時間がかかります。

```sh
lualatex --version
latexmk -v
kpsewhich jlreq.cls
kpsewhich HaranoAjiMincho-Regular.otf
```

## PDF生成・削除

```sh
cd techbook
make pdf
make clean
```

PDFと補助ファイルは `build/` に出力します。`make clean` はPDFも含めてこの生成物を削除します。
`build/` には原稿や画像を置かないでください。ディレクトリはビルド時に自動生成します。
makeを使わない場合は `latexmk -norc -r latexmkrc main.tex` でも同じ設定で生成できます。
ホームや親ディレクトリのlatexmk設定を読み込まず、この制作環境の設定を使用します。
生成PDFや補助ファイル、フォントキャッシュをGitに追加しないでください。

### Overleaf

`techbook/` の中身をプロジェクトのルートとしてアップロードし、Main documentを `main.tex`、Compilerを **LuaLaTeX** に設定します。
TeX Liveは利用可能な新しい版を選びます。Makefileは使いません。
`latexmkrc` はローカルでも使用する共通設定です。Overleaf側で出力先が管理される場合は、画面のPDFダウンロードを使ってください。
既存リポジトリ全体を送る必要はありません。アップロードは各執筆者が行ってください。

## ファイル構成（ソース全一覧）

```text
techbook/
├── README.md
├── Makefile
├── latexmkrc                  # LuaLaTeX・生成先
├── .gitignore                 # build/を除外
├── main.tex                   # 本の構成と章の一覧
├── layout.tex                 # 判型・余白・文字サイズ
├── metadata.tex               # 書名・発行情報・著者名
├── preamble.tex               # 共通スタイル・パッケージ
├── chapters/
│   ├── chapter01.tex          # Python・リスト・表
│   └── chapter02.tex          # 数式・定理・図・引用
├── frontmatter/
│   ├── cover.tex
│   ├── preface.tex
│   └── contributors.tex
├── backmatter/
│   ├── references.tex         # 全章共通の参考文献
│   ├── afterword.tex
│   └── colophon.tex
├── images/
│   └── .gitkeep
└── build/                     # 自動生成、Git管理外
```

表紙、表紙裏の白紙、はじめに、目次、各章、参考文献、あとがき、執筆者紹介、奥付の順です。
表紙は無番号、前付はローマ数字、本文は1からのアラビア数字です。後付も本文から連続します。
章は左右どちらのページからも開始する `openany` を採用し、不要な白紙増加を防ぎます。
本文の左右余白は両面印刷で反転します。表紙を印刷会社に別入稿する場合は、表紙の読み込みと表紙裏の白紙処理を併せて調整してください。

## 章の追加と文章

`chapters/chapter03.tex` を作り、次のように記載します。個別の `documentclass` や `begin{document}` は不要です。

```tex
\chapter{新しい記事のタイトル}
\label{chap:network}
\chapterauthor{執筆者名}
\section{最初の節}
日本語の本文を書きます。空行で段落を分けます。

次の段落です。脚注も使えます\footnote{補足説明。}。
\subsection{項の見出し}
第\ref{chap:python}章も参照してください。
\begin{itemize}
  \item 箇条書きの項目
\end{itemize}
\begin{enumerate}
  \item 番号付きの項目
\end{enumerate}
\url{https://example.com/}
```

`main.tex` の第2章の後、`backmatter` の前に `\input{chapters/chapter03}` を追加します。
著者名を一元管理する場合は `metadata.tex` に専用コマンドを追加します。
`frontmatter/contributors.tex` の紹介も更新してください。
章内では共通設定を変更せず、スタイルの変更は編集担当者が `preamble.tex` にまとめます。
ラベルは `chap:network`, `eq:network-cost`, `fig:network-topology` のように章固有の語を含め、全章で重複させないでください。
参照番号・目次はlatexmkが必要な回数を再コンパイルして確定します。
`%` はコメントです。本文中の記号は `\%`, `\_`, `\&`, `\#` のようにエスケープします。
手動改行 `\\` を段落の代用にしないでください。

## 数式・定義・定理

```tex
本文中の数式は $a^2+b^2=c^2$ のように書きます。
\[ E = mc^2 \] % 番号なし
\begin{equation}
  S_n = \frac{n(n+1)}{2}
  \label{eq:network-sum}
\end{equation}
式\eqref{eq:network-sum}を参照します。
\begin{align}
  f(x) &= x^2 + 2x + 1 \\
       &= (x+1)^2.
\end{align}
\begin{definition}[用語名]
  ここに定義を書きます。
\end{definition}
\begin{theorem}
  ここに主張を書きます。
\end{theorem}
\begin{proof}
  ここに証明を書きます。
\end{proof}
```

## コード

```tex
\begin{lstlisting}[language=Python,caption={処理の例},label={lst:network-example}]
for i in range(3):
    print(i)
\end{lstlisting}
コード\ref{lst:network-example}を参照します。
```

行番号・枠・折り返しを共通設定しています。コードは実行されません。
他の対応言語は `language=C` などを指定します。
listings内のコード・コメントはASCIIを推奨します。日本語コメント・Unicode識別子の組版は保証していないため、日本語の説明は本文かキャプションに書いてください。
外部ソースを掲載する場合は、章用ディレクトリに置き、例えば `\lstinputlisting[language=Python,caption={実装例},label={lst:network-file}]{chapters/network/example.py}` とします。

## 画像と表

画像は `images/chapter03/` など担当章ごとに保存します。PDF・PNG・JPEGを推奨します。
EPS・SVGは直接使わず、執筆者が事前にPDFやPNGに変換してください。

```tex
\begin{figure}[htbp]
  \centering
  \includegraphics[width=0.85\linewidth]{chapter03/diagram.png}
  \caption{構成図}
  \label{fig:network-diagram}
\end{figure}
図\ref{fig:network-diagram}を参照します。

\begin{table}[htbp]
  \centering
  \caption{測定結果}
  \label{tab:network-results}
  \begin{tabular}{lr}
    \toprule
    手法 & 時間（秒） \\
    \midrule
    A & 1.2 \\
    B & 2.4 \\
    \bottomrule
  \end{tabular}
\end{table}
```

ラベルはキャプションの後に置きます。図表は空きに合わせて移動します。
本文は白黒を前提に、色だけで意味を区別せず線種・ラベルでも区別します。
色付き画像は自動で白黒化されません。執筆者がグレースケールでの視認性を確認してください。

## 引用・参考文献

本文で `\cite{network:source}` と書き、`backmatter/references.tex` の `thebibliography` 内に文献を追加します。

```tex
\bibitem{network:source}
著者名, 『資料名』, 発行元, 2026年, pp. 10--12.
```

Web資料はURLと参照日も記載します。引用文は `quote` 環境で示し、原文との区別・出典・ページを明確にします。
文献キーは章固有にし、同じ資料を共有する場合は既存キーを再利用します。
文献一覧が100件以上になる場合は `\begin{thebibliography}{999}` のように番号の桁幅も調整します。

## Gitによる共同執筆

共同執筆には `TCU-CTRL/techbook` リポジトリを使用します。
担当章と画像だけを各部員が編集し、章の登録・共有設定・参考文献の競合は編集担当者が調整します。
以下は部員が今後作業するための例です。

```sh
git switch -c writing/chapter03
# 原稿と画像を編集
cd techbook
make pdf
cd ..
git diff --check
git diff -- techbook/
git add techbook/chapters/chapter03.tex techbook/images/chapter03/
git commit -m "第3章の原稿を追加"
git push -u origin writing/chapter03
```

GitHubでPull Requestを作成し、別の部員が内容・ビルド結果を確認します。
mainへ直接pushせず、部の運用ルールに従って取り込んでください。
文や意味のまとまりでソースを改行すると差分を読みやすくできます。
作業開始時には変更を保存して既定ブランチの更新を取り込みます。競合時に他人の章を丸ごと上書きしないでください。

## 版面と入稿前の確認

標準はA5（148×210mm）、横書き、和欧文10pt、行送り17pt、段落先頭1字下げです。
明朝は原ノ味明朝、ゴシックは原ノ味角ゴシック、英数字はLatin Modernです。
本文領域の余白はノド20mm、小口16mm、天18mm、地20mmを指定しています。
jlreqが字数・行数を調整するため、実際の余白には丸めが生じます。
柱は上部小口側、ページ番号は下部小口側です。章・節・項・目次にはjlreqの組版を使用します。
`layout.tex` を変更すると全章に反映されます。表紙色は `preamble.tex` の `CoverAccent` で変更できます。

印刷会社決定後に、次の事項を確認してください。

- 仕上がり寸法、綴じ方向、綴じ方、ノド、背幅、本文用紙、表紙用紙。
- 表紙と本文の別入稿、表1〜表4・背表紙の一枚絵が必要か。現在は表1相当の簡易表紙のみ。
- 塗り足し・トンボ・メディアサイズ。必要なら `layout.tex` と読み込み設定で `jlreq-trimmarks` などを検討する。
- PDF/Xの種類・ICCプロファイル・RGB/CMYK・透明効果などの指定。本テンプレートのPDFはPDF/Xを保証しない。
- フォント埋め込み、画像解像度、白黒の濃度、細線・コードの読みやすさ。
- ページ数の条件（4の倍数など）、白紙・ノンブル・目次・相互参照。ページ数合わせは原稿確定後に行う。
- 著作権、画像・コードのライセンス、引用、プロフィールの公開許可、奥付の仮情報。
- 実寸での試し刷り、校正、印刷会社の事前チェック。縦長の本文を家庭で両面印刷する場合は通常は長辺綴じを選ぶ。

印刷用のPDFを自動生成する専用プロファイル、表紙全展開、CI、索引は未実装です。
必要になった段階で、このディレクトリ内に追加する運用を推奨します。

## 動作確認

2026年11月4日、macOS・TeX Live 2026・latexmk 4.88で `make clean` 後の `make pdf` が成功しました。
サンプルは11ページで、全ページA5（148×210mm）です。フォントの埋め込み、日本語、数式、Pythonコード、図表、目次、相互参照を確認しています。
検証用コピーで第3章の追加と `make clean` による生成物削除も確認しました。
LinuxとOverleafでの実ビルドは未確認です。印刷会社の入稿条件への適合は別途確認してください。

## 参考資料

- [jlreq公式ドキュメント](https://github.com/abenori/jlreq/blob/master/README-ja.md)
- [LaTeXの導入案内](https://www.latex-project.org/get/)

本テンプレートは上記の公開仕様を参考に独自に構成しています。
