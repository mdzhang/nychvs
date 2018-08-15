library(plyr)

processLine = function(line, catDf) {
  # returns single observation to put into a dataframe

  # initialize empty-ish dataframe (one observation and col to avoid errs)
  df = data.frame(ix=0)

  for (i in 1:nrow(catDf)) {
    row = catDf[i,]

    start = as.numeric(as.character(row$idx))
    len = as.numeric(as.character(row$len))
    end = start + len - 1

    val = as.character(substr(line, start, end))
    tmp = as.character(row$var)

    df[, tmp] = val
  }

  return(df)
}

processFile = function(dataFilepath, catFilepath) {
  # dataFilepath: string path to data csv
  # catFilepath: string path to microdata catalog csv
  #              as parsed by catalog/*.py files
  con = file(dataFilepath, "r")
  dataFrames = list()
  idx = 1

  catDf = read.csv(catFilepath)

  while ( TRUE ) {
    line = readLines(con, n = 1)
    if ( length(line) == 0 ) {
      break
    }

    df = processLine(line, catDf)
    dataFrames[[idx]] = df
    idx = idx + 1
  }

  df = rbind.fill(dataFrames)
  write.csv(df, 'out.csv')

  close(con)
}

#############################################################################
# Entrypoint
#############################################################################

args = commandArgs(trailingOnly=TRUE)

if (length(args)<2) {
  stop("At least two arguments must be supplied (input file, catalog file).", call.=FALSE)
}

processFile(args[1], args[2])
