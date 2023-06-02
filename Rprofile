##
## https://mran.revolutionanalytics.com/documents/rro/reproducibility/doc-research/
##
#### utils:::assignInNamespace("q",function(save="no",status=0,runLast=TRUE) {
####                               .Internal(quit(save,status,runLast))
####                           }, "base")
#### utils:::assignInNamespace("quit",function(save="no",status=0,runLast=TRUE) {
####                               .Internal(quit(save,status,runLast))
####                           }, "base")

.vl_env <- new.env()
local({

.Last <- function() {
  if(interactive()) {
    try(utils::savehistory("~/.Rhistory"))
  }
}

.First <- function() {
  if(interactive()) {
    ## Sys.setenv(R_HISTSIZE=5000)
    ## Sys.setenv("_R_CHECK_LENGTH_1_CONDITION_"=TRUE) # See cond: argument in ?`if`
    try(utils::loadhistory("~/.Rhistory"))
  }
}

qn <- function() quit('no')
cd <- function(dir="~") setwd(dir)
## print.data.frame <- data.table:::print.data.table ## data.table *is* data.frame so we use its print method which, IMO, is much more useful for printing data.frame too!!

#### ## saner printing of sf objects!
#### print.sf <- function(x, ..., n = ifelse(options("max.print")[[1]] == 99999, 20, options("max.print")[[1]])) {
####   geoms = which(vapply(x,function(col) inherits(col,"sfc"), TRUE))
####   nf = length(x) - length(geoms)
####   app = paste("and", nf, ifelse(nf == 1, "field", "fields"))
####   if (any(!is.na(st_agr(x))))
####     app = paste0(app,"\n","Attribute-geometry relationship: ", sf:::summarize_agr(x))
####   if (length(geoms) > 1)
####     app = paste0(app,"\n","Active geometry column: ", attr(x, "sf_column"))
####   print(st_geometry(x),n=0,what="Simple feature collection with",append=app)
####   if(is.data.table(x)) {
####     ## data.table:::print.data.table(x, ...)
####     NextMethod()
####   } else {
####     print.data.frame(x, ...)
####   }
####   ## print.data.frame(x, ...)
####   invisible(x)
#### }


# some handy aliases
cwd <- getwd
pwd <- getwd
h <- utils::help
## len <- length
lf <- list.files
home <- cd
hd <- utils::head
tl <- utils::tail
doff <- grDevices::dev.off

default_options <- options()

options(datatable.print.class=TRUE  ## causes problems with test.data.table()
      , datatable.print.nrows=30
      , datatable.print.topn=5
      , datatable.print.trunc.cols = TRUE
      ## , datatable.verbose=TRUE
      , defaultPackages=c(options()$defaultPackages, "tools")
      , digits=18 ## to catch issues with floating point rounding. Try log(1000)/log(10) with different values of digits to see how it gets printed.
      , digits.secs=2
      , editor="vim"
      ## , error=utils::recover
      , expressions=2000
      , help_type = "html"
      , help.try.all.packages=TRUE
      , locatorBell=FALSE
      , lubridate.fasttime=TRUE
      ## , max.print=800
      , mc.cores = parallel::detectCores()
      , Ncpus = parallel::detectCores() - 2
      # , prompt="R=> "  # Causes problems with ESS
      ## , repos=structure(c(CRAN="https://ftp.ussg.iu.edu/CRAN/",
      ##                     INLA="https://inla.r-inla-download.org/R/stable"))
      , repos=structure(c(CRAN="https://cloud.r-project.org/",
                          INLA="https://inla.r-inla-download.org/R/stable"))
      , timeout = max(300, getOption("timeout")) ## INLA download timesout with default value! See ?download.file of why we need higher value here...
      , useFancyQuotes=FALSE # causes problems with LaTeX
      ## , warnPartialMatchArgs=TRUE  ## Causes lots of warnings!
      , warnPartialMatchAttr=TRUE     ## Comment if weird "repeatwithsimplewarning" error messages start popping up.
      , warnPartialMatchDollar=TRUE     ## Comment if weird "repeatwithsimplewarning" error messages start popping up.
      , xtable.booktabs=TRUE
      # , xtable.type="html"
      )

## http://andrewgelman.com/2010/10/29/could_someone_p/
## ?setHook and ?plot.new
### setHook('plot.new',function(...) graphics::par(mar=c(3,3,2,1),mgp=c(2,0.7,0),tck=-0.01))
### Above causes problems with raster::plot!

setHook(packageEvent("sp","onLoad"),
    function(...) {
      fn <- function(object) str(object,max.level=2)
      spclasses <- c("SpatialPoints", "SpatialPointsDataFrame",
                     "SpatialMultiPoints", "SpatialMultiPointsDataFrame",
                     "SpatialGrid", "SpatialGridDataFrame",
                     "SpatialLines", "SpatialLinesDataFrame",
                     "SpatialPolygons", "SpatialPolygonsDataFrame")
      for(spclass in spclasses) setMethod("show",spclass,fn)
    })
setHook(packageEvent("tuneR", "onLoad"), function(...) options(WavPlayer="/Users/vijay/code/R/playRWave"))

functions_to_learn_this_session <- local({
  last_seen <- NA ; fns_to_learn <- c()
  function() {
    if(is.na(last_seen) | Sys.Date() > last_seen) {
      fns_to_learn <<- sample(c(lsf.str("package:base"), lsf.str("package:utils"),
                                lsf.str("package:stats"), lsf.str("package:MASS")), 5)
    }
    last_seen <<- Sys.Date()
    cat("R-Trivia: Do you know the following?\n")
    invisible(cat(paste(seq_along(fns_to_learn), fns_to_learn, sep=". "), sep="\n"))
  }
})


}, env=.vl_env)
if( .Platform$OS.type == "unix" & !Sys.getenv("USER") == "root") {
  if (file.exists("~/code/R/utils.R")) {
    local(source("~/code/R/utils.R", local=.vl_env), envir=.vl_env)
  }
}
attach(.vl_env)
Sys.setenv(MAKEFLAGS = "-j4")

if (interactive()) {
    ## if (ispkginstalled("fortunes")) print(fortunes::fortune())  ## Slows down R!
    suppressPackageStartupMessages(require(compiler))
    suppressPackageStartupMessages(require(fastmatch))
    match <- fmatch ## faster matching!
    suppressPackageStartupMessages(require(fasttime))
    suppressPackageStartupMessages(compilePKGS(TRUE))  ## ?compiler::compile
    setCompilerOptions(suppressUndefined=TRUE)  ## ?compiler::compile
    suppressPackageStartupMessages(require(MASS))
    suppressPackageStartupMessages(require(Matrix))
    suppressPackageStartupMessages(require(parallel))
    suppressPackageStartupMessages(require(bit64))
    suppressPackageStartupMessages(require(RSQLite))
    suppressPackageStartupMessages(require(data.table))
    suppressPackageStartupMessages(require(ggplot2)); ## theme_set(theme_vl())
    suppressPackageStartupMessages(require(utils))
    suppressPackageStartupMessages(require(sf))
    ## suppressPackageStartupMessages(require(knitr))
    ## suppressPackageStartupMessage(require(ff))
    ## invisible(enableJIT(3))  ## ?compiler::compile ## causes problems!  2015.11.14
    functions_to_learn_this_session()
    if(isTRUE(any(grepl("^(linux|darwin)",R.version$os,ignore.case=TRUE)))) options(width=system("tput cols",intern=TRUE))
}

## if(ispkginstalled("rstan")) rstan::rstan_options(auto_write=TRUE)

# http://reasoniamhere.com/2013/09/23/7-r-tips-rescued-from-the-vault/
makeActiveBinding(".", function() .Last.value, .GlobalEnv) # ?makeActiveBinding
## Sys.setenv(TZ="America/New_York") ## Weird warnings on mac!! 2017.11.14

## All packages needed in scripts have to be explicitly stated!!
