run:
	Rscript --vanilla expand_vac.R data/uf_17_vac_web_b.txt catalog/out.csv

parse_vac:
	python3 ./catalog/parse_sas_import.py vac
