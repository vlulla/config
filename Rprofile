

qn <- function() quit('no')
cd <- function(dir="~") setwd(dir)

# some handy aliases
cwd <- getwd
pwd <- getwd
h <- utils::help
len <- length
lf <- list.files

home <- cd
hd <- utils::head
tl <- utils::tail
doff <- grDevices::dev.off

options(datatable.print.nrows=50
        , defaultPackages = c(options()$defaultPackages, "tools")
        , digits = 10
        , digits.secs = 2
        , editor = "gvim"
        , error = utils::recover
        , expressions = 2000
        , max.print = 2000
        , prompt = "R=> "
        , repos = structure(c(CRAN="http://ftp.ussg.iu.edu/CRAN/"))
        , useFancyQuotes = FALSE # causes problems with LaTeX
        , xtable.booktabs = TRUE
       )

##
##  See http://stackoverflow.com/questions/1358003/tricks-to-manage-the-available-memory-in-an-r-session
##
.ls.objects <- function(pos = 1, pattern, order.by
                        , decreasing = FALSE, head = FALSE, n = 5) {
    napply <- function(names, fn) sapply(names,
                                         function(x) fn(get(x, pos = pos)))

    names <- ls(pos = pos, pattern = pattern)
    obj.class <- napply(names, function(x) as.character(class(x))[1])
    obj.mode <- napply(names, mode)
    obj.type <- ifelse(is.na(obj.class), obj.mode, obj.class)
    obj.size <- napply(names, function(x) capture.output(print(object.size(x), units="auto")))
    obj.dim <- t(napply(names, function(x) as.numeric(dim(x))[1:2]))

    vec <- is.na(obj.dim)[,1] & (obj.type != "function")
    obj.dim[vec, 1] <- napply(names, length)[vec]
    out <- data.frame(obj.type, obj.size, obj.dim)
    names(out) <- c("Type", "Size", "Rows", "Columns")

    if (!missing(order.by))
        out <- out[order(out[[order.by]], decreasing = decreasing),]

    if (head)
        out <- head(out, n)

    out
}

lsos <- function(..., n = 10) {
    .ls.objects(..., order.by = "Size", decreasing = TRUE, head = TRUE, n = n)
}

my.update.packages <- function(...) {
    local({r <- getOption("repos");
           r["CRAN"] <- 'http://ftp.ussg.iu.edu/CRAN';
           options(repos=r)})
    update.packages(checkBuilt = TRUE, ask = FALSE)
}

if (interactive()) {
    local_pkgs <- names(utils::installed.packages()[, "Package"])
    if ("fortunes" %in% local_pkgs)
        fortunes::fortune()

    # Some packages I use very commonly
    invisible(library(compiler))
    invisible(enableJIT(3))
    invisible(library(data.table)) # Apparently this broke because of Rcpp!
    
    invisible(library(xtable))
    invisible(library(Matrix))
}

