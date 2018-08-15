library(plyr)

line = "31 199991999919999999991 321428205202  2920603112161130699999      040111099999101696115018179419000000018179419021027397005311476025750166020521900018434720005588458017277780031402888005178970020059295025695009025265660004617078019098882021689167015924112031714309005478676032385972019447014005296105029187237005098537020374659015852368017716545018223371016728638031224413005523023018655097032485620018440663018799462019188165004684718017697666032783065017825304019056388005045924037868536004547106033482874005120426032414656004975434035470011004703377021332639016652157028201105020050732005908313016348970016901394023691587027819227018298838005287252026053576017242421018326689020332192018420067017273704005730451033881159005365600017304772032156460005566963027530927022399363016880498016426659005855566016228623030640943"

processLine = function(line, catDf) {
  # returns single observation to put into a dataframe

  # initialize empty-ish dataframe (one observation and col to avoid errs)
  df = data.frame(ix=0)

  for (i in 1:nrow(catDf)) {
    row = catDf[i,]
    print(row)

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
  threshold = 5

  catDf = read.csv(catFilepath)

  while ( TRUE ) {
    line = readLines(con, n = 1)
    if ( length(line) == 0 ) {
      break
    }

    df = processLine(line, catDf)
    dataFrames[[idx]] = df
    idx = idx + 1

    if ( idx >= threshold ) {
      break
    }
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
