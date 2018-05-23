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
day.name <- c("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday")
day.abb <- substr(day.name,1,3)

.Last <- function() {
  if(interactive()) try(utils::savehistory("~/.Rhistory"))
}

.First <- function() {
  if(interactive()) try(utils::loadhistory("~/.Rhistory"))
}

qn <- function() quit('no')
cd <- function(dir="~") setwd(dir)
## print.data.frame <- data.table:::print.data.table ## data.table *is* data.frame so we use its print method which, IMO, is much more useful for printing data.frame too!!

## saner printing of sf objects!
print.sf <- function(x, ..., n = ifelse(options("max.print")[[1]] == 99999, 20, options("max.print")[[1]])) {
  geoms = which(vapply(x,function(col) inherits(col,"sfc"), TRUE))
  nf = length(x) - length(geoms)
  app = paste("and", nf, ifelse(nf == 1, "field", "fields"))
  if (any(!is.na(st_agr(x))))
    app = paste0(app,"\n","Attribute-geometry relationship: ", summarize_agr(x))
  if (length(geoms) > 1)
    app = paste0(app,"\n","Active geometry column: ", attr(x, "sf_column"))
  print(st_geometry(x),n=0,what="Simple feature collection with",append=app)
  print.data.frame(x, ...)
  invisible(x)
}

pdflatex <- function(file, ...) tools::texi2pdf(file, clean=TRUE, ...)
sweavepdf <- function(file, ...) {
  Sweave(file, ...)
  texfile <- tools::file_path_sans_ext(file)
  pdflatex(paste0(texfile, ".tex"))
}
#### ispkginstalled <- function(pkgname) {
####     ## This will not work with sapply/lapply because of NSE!
####     ## See http://adv-r.had.co.nz/Computing-on-the-language.html#calling-from-another-function
####     ##
####     ## Still don't know how to fix this!  2016.06.10
####
####     ischar <- tryCatch(is.character(pkg) && length(pkg) == 1L, error=identity)
####     pkg <- substitute(pkgname)
####     if (inherits(ischar, "error")) ischar <- FALSE
####     if (!ischar)
####       pkg <- deparse(pkg)
####     ## pkg %in% names(utils::installed.packages()[,"Package"])
####     pkg %in% utils::installed.packages()[,"Package"]
#### }
ispkginstalled <- function(pkgname) {
  pkg <- as.character(pkgname)
  pkg %in% utils::installed.packages()[,"Package"]
}

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

options(datatable.print.class=TRUE
      , datatable.print.nrows=30
      , datatable.print.topn=5
      , datatable.verbose=TRUE
      , defaultPackages=c(options()$defaultPackages, "tools")
      ## , digits=3
      , digits.secs=2
      , editor="vi"
      ## , error=quote({dump.frames(to.file=TRUE, include.GlobalEnv=TRUE); q(save="yes", status=1); })
      , error=utils::recover
      , expressions=2000
      , help.try.all.packages=TRUE
      , locatorBell=FALSE
      , lubridate.fasttime=TRUE
      ## , max.print=800
      , mc.cores = parallel::detectCores()
      # , prompt="R=> "  # Causes problems with ESS
      , Ncpus = parallel::detectCores() - 2
      , repos=structure(c(CRAN="https://ftp.ussg.iu.edu/CRAN/"))
      , useFancyQuotes=FALSE # causes problems with LaTeX
      ## , warnPartialMatchArgs=TRUE  ## Causes lots of warnings!
      , warnPartialMatchAttr=TRUE
      , warnPartialMatchDollar=TRUE
      , xtable.booktabs=TRUE
      # , xtable.type="html"
      )

## http://andrewgelman.com/2010/10/29/could_someone_p/
## ?setHook and ?plot.new
### setHook('plot.new',function(...) graphics::par(mar=c(3,3,2,1),mgp=c(2,0.7,0),tck=-0.01))
### Above causes problems with `raster` package plot function!

setHook(packageEvent("sp","onLoad"),
    function(...) {
      fn <- function(object) str(object,max.level=2)
      spclasses <- c("SpatialPoints", "SpatialPointsDataFrame",
                     "SpatialMultiPoints", "SpatialMultiPointsDataFrame",
                     "SpatialLines", "SpatialLinesDataFrame",
                     "SpatialPolygons", "SpatialPolygonsDataFrame")
      for(spclass in spclasses) setMethod("show",spclass,fn)
    })
setHook(packageEvent("tuneR", "onLoad"), function(...) options(WavPlayer="/Users/vijay/code/R/playRWave"))

##
## See http://stackoverflow.com/questions/1358003/tricks-to-manage-the-available-memory-in-an-r-session
##
lsos <- .ls.objects <- function(pos=1, pattern, order.by , decreasing=FALSE, head=FALSE, n=5) {
    napply <- function(names, fn) sapply(names, function(x) fn(get(x, pos=pos)))
    names <- ls(pos=pos, pattern=pattern)
    if (length(names)==0) return(character(0))
    obj.class <- napply(names, function(x) as.character(class(x))[1])
    obj.mode <- napply(names, base::mode)
    obj.type <- ifelse(is.na(obj.class), obj.mode, obj.class)
    obj.size <- napply(names, function(x) {
                        l <- capture.output(print(object.size(x), units="auto"))
                        l[length(l)]
                        })

    obj.dim <- t(napply(names, function(x) as.numeric(dim(x))[1:2]))
    vec <- is.na(obj.dim)[,1] & (obj.type != "function")
    obj.dim[vec, 1] <- napply(names, length)[vec]
    out <- data.frame(obj.type, obj.size, obj.dim)
    names(out) <- c("Type", "Size", "Rows", "Columns")

    if (!missing(order.by)) {
      if (order.by=="Size") {
        ## This is to fix the obj.size issues!
        ## Try eh following to see the issue:
        ## m <- mtcars; m2 <- rbind(m,m); x <- 1:3; lsos(order.by="Size")
        sizes <- napply(names, sizes)
        out <- out[order(sizes, decreasing=decreasing),]
      } else {
        out <- out[order(out[[order.by]], decreasing=decreasing),]
    }
    if (head) out <- head(out, n)
    out
}

# lsos <- function(..., n=10) .ls.objects(..., order.by="Size", decreasing=TRUE, head=TRUE, n=n)
# lsos <- function(..., n=10) .ls.objects(..., order.by="Size", decreasing=TRUE, n=n)

updatepkgs <- my.update.packages <- function(...) {
    ## local({r <- getOption("repos");
    ##        r["CRAN"] <- 'http://ftp.ussg.iu.edu/CRAN';
    ##        options(repos=r)})
    update.packages(checkBuilt=TRUE, ask=FALSE)
}

## reverse a string of characters
reverse <- function(str, split="") {
    # strReverse from help(strsplit) !
    sapply(lapply(strsplit(str,split), rev), paste, collapse=split)
}

# std. error
se <- function(x) sd(x)/sqrt(length(x))

## http://stackoverflow.com/questions/30695648/how-to-redefine-cov-to-calculate-population-covariance-matrix
cov.pop <- function(x, y=NULL, ...) { cov(x,y, ...) * (NROW(x)-1)/NROW(x) }
var.pop <- function(x, ...) { var(x, ...) * (NROW(x)-1) / NROW(x) }
symdiff <- function(x,y) union(setdiff(x,y),setdiff(y,x))
rmse <- function(residuals) sqrt(mean(residuals))

fixcolnames <- normalize_string <- function(x,lowercase=FALSE) {
  ## replaces one or more of non alpha-numeric characters to _
  ## also lowercases the character string
  f <- ifelse(lowercase, tolower, identity)
  gsub("^_|_$","",f(gsub("[^A-Za-z0-9]+","_",as.character(x))))
}

num_unique <- function(x) length(unique(x))
showpaths <- pathcomponents <- function(path=Sys.getenv("PATH")) {
  unlist(strsplit(path, .Platform$path.sep))
}

functions_to_learn_this_session <- local({
  last_seen <- NA ; fns_to_learn <- c()
  function() {
    if(is.na(last_seen) | Sys.Date() > last_seen) {
      fns_to_learn <<- sample(c(ls("package:base"), ls("package:utils"),
                                ls("package:stats"), ls("package:MASS")), 5)
    }
    last_seen <<- Sys.Date()
    cat("R-Trivia: Do you know these following functions?\n")
    invisible(cat(paste(seq_along(fns_to_learn), fns_to_learn, sep=". "), sep="\n"))
  }
})

totitle <- function(x,USE.NAMES=FALSE) {
  s <- sapply(x, function(x) strsplit(x,"\\s",perl=TRUE,fixed=FALSE))
  s <- sapply(s, function(s) paste(gsub("(.)(.*)","\\U\\1\\E\\2",s,perl=TRUE), collapse=" "))
  s
}

theme_vl <- function(base_size=12) {
  bg_color="#f0f0f0"
  bg_rect=element_rect(fill=bg_color, color=bg_color)

  theme_bw(base_size=base_size) +
    theme(
      plot.title=element_text(hjust=0.5,size=rel(1.5),face="bold"), # family=title_font_family),
      plot.subtitle=element_text(size=rel(1.1), lineheight=1.1, hjust=0.5),
      plot.caption=element_text(size=rel(0.7), margin=unit(c(1,0,0,0), "lines"), lineheight=1.1, color="#555555"),
      ## plot.background=element_rect(color="black",size=1),
      plot.margin=margin(1,1,0.2,0.2,'cm'),
      ## axis.ticks=element_blank(),
      axis.text.x=element_text(size=rel(1), color="black"),
      axis.title.x=element_text(size=rel(1)),
      axis.text.y=element_text(size=rel(1),color="black"),
      axis.title.y=element_text(size=rel(1)),
      ## panel.background=bg_rect,
      panel.border=element_rect(fill=NA,color="black"),
      panel.grid.major=element_line(color="grey80", size=0.10),
      panel.grid.minor=element_line(color="grey80", size=0.05),
      panel.spacing=unit(1.25,"lines"),
      legend.background=bg_rect,
      legend.key.width=unit(1.5,"line"),
      ## legend.key=element_blank(),
      strip.background=element_blank()
    )
}

withOptions <- function(optlist, expr) {
  ## See the subsection ``Deep End'' on http://www.burns-stat.com/the-options-mechanism-in-r/
  oldopt <- options(optlist)
  on.exit(options(oldopt))
  expr <- substitute(expr)
  eval.parent(expr)
}

toggleError <- function() {
  invisible(ifelse(is.null(options()$error), options(error=utils::recover), options(error=NULL)))
}

## Print only 3 decimal digits while printing/showing data.frame.
## .print.data.frame <- print.data.frame
## print.data.frame <- function(x, ..., digits=3, quote=FALSE,right=TRUE, row.names=TRUE) {
##   .print.data.frame(x, ..., digits=digits, quote=quote, right=right, row.names=row.names)
## }

if (interactive()) {
    ## if (ispkginstalled("fortunes")) print(fortunes::fortune())  ## Slows down R!
    suppressPackageStartupMessages(require(compiler))
    suppressPackageStartupMessages(compilePKGS(TRUE))  ## ?compiler::compile
    setCompilerOptions(suppressUndefined=TRUE)  ## ?compiler::compile
    suppressPackageStartupMessages(require(MASS))
    suppressPackageStartupMessages(require(Matrix))
    suppressPackageStartupMessages(require(parallel))
    suppressPackageStartupMessages(require(bit64))
    suppressPackageStartupMessages(require(data.table))
    suppressPackageStartupMessages(require(ggplot2))
    suppressPackageStartupMessages(require(utils))
    ## suppressPackageStartupMessages(require(knitr))
    ## suppressPackageStartupMessage(require(ff))
    ## invisible(enableJIT(3))  ## ?compiler::compile ## causes problems!  2015.11.14
    functions_to_learn_this_session()
    options(error=utils::recover)
}
}, env=.vl_env)
attach(.vl_env)
Sys.setenv(MAKEFLAGS = "-j4")

if(ispkginstalled("rstan")) rstan::rstan_options(auto_write=TRUE)

# http://reasoniamhere.com/2013/09/23/7-r-tips-rescued-from-the-vault/
makeActiveBinding(".", function() .Last.value, .GlobalEnv) # ?makeActiveBinding

## All packages needed in scripts have to be explicitly stated!!
