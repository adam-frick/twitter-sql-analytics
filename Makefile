doc = writeup

default:
	rst2latex.py $(doc).rst > $(doc).tex
	pdflatex $(doc).tex

clean:
	rm -r $(doc).aux $(doc).log $(doc).tex
