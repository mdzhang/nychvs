library(plyr)

line = "31 999199991999199999919 221111211205  1110302111162130399999      040211089999101848014021164441000000021164441006310899020506666031623516023598762005342090034266368020991919022812704006405035021601891031481597007294806021163273032367986020587537006363259021059919021630813021740668034904790006574810033808973020803723006617593034094476006045556023329222018743528023501110020040003020501102037187316005886332024103659032293048020171834023067753020292275006046743019907143035480009024732058020745390005388434041136823006760094032516751006319892034062815005645694040834795005800585021308742022791457030808585021232281006946373019974159020635478023043159031829455025635297005189986034021308021810704023422102020159804022552109019054832006539908035235044005861827020368538034733371006869757032501556021020055021476398022105340"

processLine = function(line) {
  # returns single observation to put into a dataframe

  recordType = substr(line, 1, 1)
  boro = substr(line, 2, 2)
  uf1_1 = substr(line, 4, 4)
  uf1_3 = substr(line, 5, 5)
  uf1_4 = substr(line, 6, 6)
  uf1_5 = substr(line, 7, 7)
  uf1_6 = substr(line, 8, 8)

  df = data.frame(
    'recordType' = recordType,
    'boro' = boro,
    'uf1_1' = uf1_1,
    'uf1_3' = uf1_3,
    'uf1_4' = uf1_4,
    'uf1_5' = uf1_5,
    'uf1_6' = uf1_6
  )

  return(df)
}

processFile = function(filepath) {
  con = file(filepath, "r")
  dataFrames = list()
  idx = 1
  threshold = 5

  while ( TRUE ) {
    line = readLines(con, n = 1)
    if ( length(line) == 0 ) {
      break
    }

    df = processLine(line)
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

if (length(args)==0) {
  stop("At least one argument must be supplied (input file).", call.=FALSE)
}

processFile(args[1])
