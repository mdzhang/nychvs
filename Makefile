CAT=vac

run:
	Rscript --vanilla expandMicrodata.R data/uf_17_${CAT}_web_b.txt catalog/${CAT}/result.csv catalog/${CAT}/parsed.csv

parse:
	python3 ./catalog/parse_sas_import.py ${CAT}

run_vac: run

run_occ: CAT=occ
run_occ: run

run_pers: CAT=pers
run_pers: run

parse_vac: parse

parse_occ: CAT=occ
parse_occ: parse

parse_pers: CAT=pers
parse_pers: parse
