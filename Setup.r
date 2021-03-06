# -------------------------------------------------
# Initial set up script for tables and figures
# Tom Hiatt
# 6 July 2012, revised 28 June 2013
# -------------------------------------------------

# A few details on my way of working. For the tables, figures, maps repeated from year to year, all the code is here and the data source is nearly 100% from the global database. Some people have to send me excel files which I save in the 'External data' folder. For other one-off tables I just save the final files in my folders and iterate with the creator to get them in a ready format.


start <- Sys.time()
source("d:/users/hiattt/Dropbox/Code/R/.Rprofile")
runprofile()

# SETTINGS. Change these three things as appropriate
thisyear <- as.numeric(format(Sys.time(),"%Y")) # This refers to the report year
basefolder <- "d:/users/hiattt/Google Drive/Work files/Global TB report/Tables and Figures"

# Set-up

libraries(c('reshape', 'ggplot2', 'grid', 'scales', 'xtable', 'stringr', 'timeSeries'))

# library(treemap)
# library(RODBC)
# library(gtb)
# rm(est, regional, global)

# Create a folder structure for saving files if doesn't exist yet 
if(file.path(basefolder, 'FigData') %nin% list.dirs(basefolder, recursive=FALSE)){
dir.create(file.path(basefolder, "Review"))
dir.create(file.path(basefolder, "FigData"))
dir.create(file.path(basefolder, "Figs"))
dir.create(file.path(basefolder, "CPFigs"))
dir.create(file.path(basefolder, "Slides"))
dir.create(file.path(basefolder, "Tables"))
}




#for the date
# todate <- Sys.Date()
# if(file.path(versionfolders, todate) %nin% list.dirs(versionfolders, recursive=FALSE)){
# dir.create(file.path(versionfolders, todate))
# dir.create(file.path(versionfolders, todate, "FigData"))
# dir.create(file.path(versionfolders, todate, "Figs"))
# dir.create(file.path(versionfolders, todate, "CPFigs"))
# dir.create(file.path(versionfolders, todate, "Slides"))
# dir.create(file.path(versionfolders, todate, "Tables"))
# }
# outfolder <- file.path(versionfolders, todate)
outfolder <- basefolder
setwd(basefolder)

# Create dummy data for latest year until data are available
for(df in c('e', 'eraw', 'a', 'araw', 'n', 'd')){
  obj <- get(df)
  if(max(obj["year"]) < thisyear-1) {
    warning(paste('Still need to get updated dataset for', df, '!!!'))
    copy <- obj[obj['year']==thisyear-1-1,]
    copy$year <- thisyear-1
    comb <- rbind(obj, copy)
    if(df=="n") comb[comb$iso3=="DZA" & comb$year==thisyear-1, 'tot_newrel'] <- NA
  }
  else(comb <- obj)
  assign(paste(df, "t", sep="."), comb)
}

# Load in estimate projections. Better to have this in the db, but Hazim is in the UK...
# 
# if(max(araw.t$year < 2015)) {  
#   save.spot <- 'D:/Users/hiattt/Google Drive/Work files/Global TB report/Tables and Figures/From others'
#   for(piece in c('regional', 'est', 'global')){
#     load(file.path(save.spot, glue(piece, '.Rdata')))     
#   }
#   names(regional) <- gsub ('\\.', '_', names (regional))
# araw.t <- merge()
#   
#   # okay Im wasting my time now...okay no choice
#   print('got from dropbox')
# }

# functions
# rounding convention
# 0 is 0, under .1 to "<0.1", under 1 to 1 sig fig, otherwise 2 sig fig
round.conv <- function(x) {
  ifelse(x==0, 0, ifelse(x < 0.1, "<0.1", ifelse(signif(x, 2) < 1, formatC(round(x,1), format='f', digits=1),
                                                 ifelse(signif(x, 2) < 10, sapply(signif(x,2), sprintf, fmt="%#.2g"), signif(x, 2)))))
}	# Note: The second method for trailing 0s does not work with 9.99

# rounding convention for rates
# 0 is 0, under .1 to "<0.1", under 1 to 1 sig fig, under 100 to 2 sig figs,
# otherwise 3 sig figs
round.conv.rates <- function(x) {
  ifelse(x==0, 0, ifelse(x < 0.1, "<0.1", ifelse(signif(x, 2) < 10, formatC(round(x,1), format='f', digits=1),
                                                 # ifelse(signif(x, 2) < 10, formatC(round(x,1), format='f', digits=1),
                                                 ifelse(signif(x, 3) < 100, signif(x, 2), signif(x, 3)))))
}	

# Depends on whether dealing with thousands or rates. In general, 0 is 0, under .1 to "<0.1", then appropriate sig figs.
# Amended by Hazim 2012-08-31 to fix double-rounding error, plus also
# changed so that numbers < 1 are only rounded to 1 sig fig
frmt <- function(x, rates=FALSE, thou=FALSE) {
  ifelse(x==0, "0", 
         ifelse(x < 0.01 & thou==TRUE, "<0.01", 
                ifelse(x < 0.1 & thou==FALSE, "<0.1", 
                       ifelse(signif(x, 2) < 1 & thou==TRUE, formatC(signif(x,2), format='f', digits=2),
                              ifelse(signif(x, 2) < 1, formatC(signif(x,1), format='f', digits=1), 
                                     ifelse(signif(x, 2) < 10, formatC(signif(x,2), format='f', digits=1),
                                            ifelse(x > 1 & rates==FALSE, formatC(signif(x, 2), big.mark=" ", format='d'), 
                                                   ifelse(signif(x, 3) < 100, formatC(signif(x, 2), big.mark=" ", format='d'), formatC(signif(x, 3), big.mark=" ", format='d')))))))))
}  

# Simple rounder that just adds in the thousands separator 
rounder <- function(x, decimals=FALSE) {
  if(decimals==TRUE){
    ifelse(is.na(x), NA, ifelse(x==0, 0, ifelse(x < 0.01, "<0.01", ifelse(round(x,2) < 0.1, formatC(round(x,2), format='f', digits=2), ifelse(round(x,1) < 10, formatC(round(x,1), format='f', digits=1), formatC(round(x,0), big.mark=" ", format='d') )))))
  }
  else ifelse(is.na(x), NA, ifelse(x==0, 0, ifelse(x < 1, "< 1", formatC(round(x,0), big.mark=" ", format='d'))))
}

# Shorten and correct names (and order them properly!)
.shortnames <- function(d, col='country', ord='somethingelse'){
  d[col] <- as.character(d[[col]])
  d[col] <- ifelse(d[[col]]=='Democratic Republic of the Congo', 'DR Congo', 
                   ifelse(d[[col]]=='United Republic of Tanzania', 'UR Tanzania', 
                          ifelse(d[[col]]=='SEA', 'SEAR', 
                                 ifelse(d[[col]]=='global', 'Global', d[[col]]))))
  if(ord %nin% c('hbc')) warning('Not ordering.')
if(ord=='hbc')  d <- d[match(c("Afghanistan", "Bangladesh", "Brazil", "Cambodia", "China", "DR Congo", "Ethiopia", "India", "Indonesia", "Kenya", "Mozambique",  "Myanmar", "Nigeria", "Pakistan", "Philippines", "Russian Federation", "South Africa", "Thailand", "Uganda", "UR Tanzania", "Viet Nam", "Zimbabwe", "High-burden countries", "AFR", "AMR", "EMR", "EUR", "SEAR", "WPR", "Global"), d[[col]]),]

  
  return(d)
}
# Nab Philippe's functions (for aggregating)
add.rv <- function (r, r.lo, r.hi, r.sd, weights = 1, method = "beta") 
{
  if (is.null(r) || length(r) == 0) 
    stop("Error: r must contain at least one value")
  if (sum(r < 0 & !is.na(r) & method == "beta")) 
    stop("Error: r must be positive with method 'beta'")
  if (sum(r > 1 & !is.na(r) & method == "beta")) 
    stop("Error: r must be between 0 and 1 with method 'beta'")
  if (missing(r.sd)) 
    r.sd <- (r.hi - r.lo)/4
  if (missing(r.lo) & !missing(r.sd)) 
    r.lo <- numeric()
  if (missing(r.hi) & !missing(r.sd)) 
    r.hi <- numeric()
  if (sum(r.lo < 0 & !is.na(r.lo) & method == "beta")) 
    stop("Error: r.lo must be positive with method 'beta'")
  if (sum(r.lo > 1 & !is.na(r.lo) & method == "beta")) 
    stop("Error: r.lo must be between 0 and 1 with method 'beta'")
  if (sum(r.hi < 0 & !is.na(r.hi) & method == "beta")) 
    stop("Error: r.hi must be positive with method 'beta'")
  if (sum(r.hi > 1 & !is.na(r.hi) & method == "beta")) 
    stop("Error: r.hi must be between 0 and 1 with method 'beta'")
  if (sum(r.sd > 1 & !is.na(r.sd) & method == "beta")) 
    stop("Error: sd must be between 0 and 1 with method 'beta'")
  if (sum(r[!is.na(r) & is.na(r.sd)])) 
    stop("Error: some values for r are supplied without uncertainty")
  if (sum(r.sd < 0 & !is.null(r.sd) & !is.na(r.sd))) 
    stop("Error: sd must be positive")
  if (!is.null(r.sd)) 
    v <- r.sd^2
  else v <- ((r.hi - r.lo)/4)^2
  sw <- ifelse(length(weights) > 1, sum(weights[!is.na(r)], 
                                        na.rm = TRUE), 1)
  out.m <- sum(r * weights, na.rm = TRUE)/sw
  out.v <- ifelse(length(weights) > 1, sum(v[!is.na(r)] * weights[!is.na(r)]^2, 
                                           na.rm = TRUE)/sw^2, sum(v))
  if (method == "beta") {
    S <- (out.m * (1 - out.m)/out.v) - 1
    a <- S * out.m
    b <- S * (1 - out.m)
    lo <- qbeta(0.025, a, b)
    hi <- qbeta(0.975, a, b)
  }
  else {
    lo <- qnorm(0.025, out.m, sqrt(out.v))
    hi <- qnorm(0.975, out.m, sqrt(out.v))
  }
  if (all(weights == 1)) 
    return(data.frame(r = out.m, r.lo = lo, r.hi = hi, r.sd = sqrt(out.v)))
  else return(data.frame(r = out.m, r.lo = lo, r.hi = hi, r.sd = sqrt(out.v), 
                         r.num = out.m * sw, r.lo.num = lo * sw, r.hi.num = hi * 
                           sw, e.pop.num = sw))
}


# product of two random variables X and Y using Taylor expansion approximation
prodXY <- function(X, Y, varX, varY, covXY=0){
  eXY <- X * Y + covXY
  varXY <- X^2*varY + Y^2*varX + 2*X*Y*covXY + varX*varY + covXY^2
  return(list("E(XY)"=eXY, "Var(XY)"=varXY))
}


# ratio of two random variables X and Y using Taylor expansion
divXY <- function(X, Y, varX, varY, covXY=0){
  eXY <- X/Y - covXY/Y^2 + X*varY/Y^3
  varXY <- varX/Y^2 - 2*X*covXY/Y^3 + X^2*varY/Y^4
  return(list("E(X/Y)"=eXY, "Var(X/Y)"=varXY))
}

# For saving figures

figsave <- function(obj, data, name, width=11, height=7){
  #   save PDF for designer
  ggsave(glue(outfolder, "/Figs/", name, Sys.Date(), ".pdf"), obj, width=width, height=height)
  #   save PNG for reviewer
  ggsave(glue(outfolder, "/Review/", name, ".png"), obj, width=width, height=height)
  #   save data for designer
  write.csv(data, file=paste(outfolder, "/FigData/", name, Sys.Date(), ".csv", sep=""), row.names=FALSE, na="")
  #   save data for reviewer
  out <- xtable(data)
  print(out, file=paste(outfolder, "/Review/", name, ".htm", sep=""), type="html")
}

# For saving tables

tablecopy <- function(table){
  file.copy(glue("Tables/", table, Sys.Date(), ".htm"), glue("Review/", table, ".htm"), overwrite=TRUE)
}