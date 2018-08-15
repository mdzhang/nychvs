# NYCHVS

Some scripts to help a friend decode the NYC Housing Vacancy Survey data from [here](https://www.census.gov/data/datasets/2017/demo/nychvs/microdata.html).

Running the makefile `run_*` targets will output `parsed.csv` file under `catalog/<subdir>/` which has the microdata lines split out into individual columns according to their keys, which I've parsed from the SAS import script provided on the website.
