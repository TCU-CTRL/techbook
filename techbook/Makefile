LATEXMK ?= latexmk

.PHONY: pdf clean
pdf:
	@mkdir -p build
	$(LATEXMK) -norc -r latexmkrc main.tex

# 生成物専用ディレクトリの中身だけを削除する。
clean:
	@mkdir -p build
	$(LATEXMK) -norc -r latexmkrc -C main.tex
	find build -type f -delete
