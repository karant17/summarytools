#' Query and set summarytools global options
#'
#' To list all \code{summarytools} global options, call without arguments. To
#' display the value of one or several options, enter the name(s) of the
#' option(s) in a character vector as sole argument.
#'
#' @param option option(s) name(s) to query (optional). Can be a single string
#'   or a vector of strings to query multiple values.
#' @param value the value you wish to assign to the option specified in the first
#'   argument. This is for backward-compatibility, as all options can now be set
#'   via their own parameter. That is, instead of 
#'   \code{st_options('plain.ascii', FALSE))}, it is more practical to use
#'   \code{st_options(plain.ascii = FALSE)}.
#' @param style Character. One of \dQuote{simple} (default), \dQuote{rmarkdown},
#'   or \dQuote{grid}. Does not apply to \code{\link{dfSummary}}.
#' @param plain.ascii Logical. \code{TRUE} by default. Set to \code{FALSE} when
#'   using summarytools with a rendering tool such as \code{knitr} or when
#'   creating rmarkdown output files to be converted with Pandoc. Note hoewever
#'   that its value will automatically be set to \code{FALSE} whenever
#'   \code{style} is set to \dQuote{rmarkdown}).
#' @param round.digits Numeric. Defaults to \code{2}.
#' @param headings Logical. Set to \code{FALSE} to remove all headings from
#'   outputs. Only the tables will be printed out, except when \code{\link{by}}
#'   or \code{\link{lapply}} are used. In that case, the variable or the group
#'   will still appear before the tables. \code{FALSE} by default.
#' @param footnote Character. When the default value \dQuote{default} is used,
#'   the package name & version, as well as the R version number are displayed
#'   below html outputs. Set no \code{NA} to omit the footnote, or provide a
#'   custom string. Applies only to \emph{html} outputs.
#' @param display.labels Logical. \code{TRUE} by default. Set to \code{FALSE} to
#'   omit data frame and variable labels in the headings section.
#' @param bootstrap.css Logical. Specifies whether to Include 
#'   \emph{Bootstrap css} in \emph{html} reports \emph{head} section outputs.
#'   Defaults to \code{TRUE}. Set to \code{FALSE} when using the \dQuote{render}
#'   method inside a \code{shiny} app to avoid interacting with the app's 
#'   layout.
#' @param custom.css Character. Path to an additional, user-provided, CSS file.
#'   \code{NA} by default.
#' @param escape.pipe Logical. Set to \code{TRUE} if Pandoc conversion is your
#'   goal and you have unsatisfying results with grid or multiline tables.
#'   \code{FALSE} by default.
#' @param freq.totals Logical. Corresponds to the \code{totals} parameter of
#'   \code{\link{freq}}. \code{TRUE} by default.
#' @param freq.report.nas Logical. Corresponds to the \code{display.nas}
#'   parameter of \code{freq()}. \code{TRUE} by default.
#' @param ctable.prop Character. Corresponds to the \code{prop} parameter of
#'   \code{\link{ctable}}. Defaults to \dQuote{r} (\emph{r}ow).
#' @param ctable.totals Logical. Corresponds to the \code{totals} parameter of
#'   \code{\link{ctable}}. \code{TRUE} by default.
#' @param descr.stats Character. Corresponds to the \code{stats} parameter of
#'   \code{\link{descr}}. Defaults to \dQuote{all}.
#' @param descr.transpose Logical. Corresponds to the \code{transpose} parameter
#'   of \code{\link{descr}}. \code{FALSE} by default.
#' @param dfSummary.varnumbers Logical. In \code{\link{dfSummary}}, display
#'   variable numbers in the first column. Defaults to \code{TRUE}.
#' @param dfSummary.labels.col Logical. In \code{\link{dfSummary}}, display
#'   variable labels Defaults to \code{TRUE}.
#' @param dfSummary.valid.col Logical. In \code{\link{dfSummary}}, include
#'   column indicating count and proportion of valid (non-missing). \code{TRUE}
#'   by default.
#' @param dfSummary.na.col Logical. In \code{\link{dfSummary}}, include column
#'   indicating count and proportion of missing (NA) values. \code{TRUE} by
#'   default.
#' @param dfSummary.graph.col Logical. Display barplots / histograms column in
#'   \code{\link{dfSummary}} \emph{html} reports. \code{TRUE} by default.
#' @param dfSummary.graph.magnif Numeric. Magnification factor, useful if
#'   \code{\link{dfSummary}} graphs show up too large (then use a value between
#'   0 and 1) or too small (use a value > 1). Must be positive. Default to
#'   \code{1}.
#' @param omit.headings Logical. Deprecated. Use \code{headings} instead.
#' 
#' @author
#' Dominic Comtois, \email{dominic.comtois@@gmail.com},
#' @note Loosely based on Gergely Daróczi's \code{\link[pander]{panderOptions}}
#'  function.
#' 
#' @examples \dontrun{
#' st_options()                   # show all summarytools global options
#' st_options('round.digits')     # show a specific global option 
#' st_options(round.digits = 1)   # set an option
#' st_options('round.digits', 1)  # set an option (legacy way)
#' st_options('reset')            # reset all summarytools global options
#' }
#' @export
st_options <- function(option = NULL, value = NULL, style = 'simple', 
                       round.digits = 2, plain.ascii = TRUE, headings = TRUE,
                       footnote = 'default', display.labels = TRUE,
                       bootstrap.css = TRUE, custom.css = NA,
                       escape.pipe = FALSE, freq.totals = TRUE,
                       freq.report.nas = TRUE, ctable.prop = 'r',
                       ctable.totals = TRUE, descr.stats = 'all',
                       descr.transpose = FALSE, dfSummary.varnumbers = TRUE,
                       dfSummary.labels.col = TRUE, dfSummary.valid.col = TRUE, 
                       dfSummary.na.col = TRUE, dfSummary.graph.col = TRUE, 
                       dfSummary.graph.magnif = 1, omit.headings = !headings) {
  
  allOpts <- getOption('summarytools')
  
  mc <- match.call()
  
  if (omit.headings %in% names(mc)) {
    message("'omit.headings' will be deprecated in future releases. ",
            "Use 'headings' instead")
  }
  
  # Querying all
  if (is.null(names(mc))) {
    return(allOpts)
  }
  
  # Querying one or several
  if (length(mc) == 2 && "option" %in% names(mc) && option != "reset") {
    # Check that option is among the existing ones
    for (o in option) {
      if (!o %in% c(names(allOpts), 'omit.headings')) {
        message('Available options: ', paste(names(allOpts), collapse = ", "))
        print(o)
        stop('Option ', o, 'not recognized / not available')
      }
    }
    
    if (length(option) == 1) {
      if (option == 'omit.headings') {
        message("'omit.headings' has been replaced by 'headings'. ",
                "Returning !headings instead")
        return(!allOpts[['headings']])
      } else {
        return(allOpts[[option]])
      }
    } else {
      return(allOpts[option])
    }
  }

  if (isTRUE(option == 'reset')) {
    if (length(mc) > 2) {
      stop('Cannot reset options and set them at the same time')
    }
    
    options('summarytools' = 
              list('style'                  = 'simple',
                   'plain.ascii'            = TRUE,
                   'round.digits'           = 2,
                   'headings'               = TRUE,
                   'footnote'               = 'default',
                   'display.labels'         = TRUE,
                   'bootstrap.css'          = TRUE,
                   'custom.css'             = NA,
                   'escape.pipe'            = FALSE,
                   'freq.totals'            = TRUE,
                   'freq.report.nas'        = TRUE,
                   'ctable.prop'            = 'r',
                   'ctable.totals'          = TRUE,
                   'descr.stats'            = 'all',
                   'descr.transpose'        = FALSE,
                   'dfSummary.varnumbers'   = TRUE,
                   'dfSummary.labels.col'   = TRUE,
                   'dfSummary.graph.col'    = TRUE,
                   'dfSummary.valid.col'    = TRUE,
                   'dfSummary.na.col'       = TRUE,
                   'dfSummary.graph.magnif' = 1))
    
    message('summarytools options have been reset')
    return(invisible())
  }

  # Legacy way of setting of options
  if (length(names(mc)) == 3 && identical(sort(names(mc)), 
                                          c("", "option", "value"))) {
    if (length(option) > 1) {
      stop("Cannot set more than one option at a time in the legacy way.",
           "Use separate arguments for each option instead")
    }
    if (option == 'omit.headings') {
      message("'omit.headings' has been replaced by 'headings'. Setting ",
              "'headings' to ", !isTRUE(value))
      allOpts[['headings']] <- !isTRUE(value)
    } else if (!option %in% names(allOpts)) {
      message('Available options:', paste(names(allOpts), collapse = ", "))
      stop('Option ', option, 'not recognized / not available')
    } else {
      allOpts[[option]] <- value
    }
    options('summarytools' = allOpts)
    return(invisible())
  }
  
  # Regular way of setting options    
  for (o in setdiff(names(mc), c("", "option", "value"))) {
    if (o == 'omit.headings') {
      message("'omit.headings' has been replaced by 'headings' and will be ",
              "deprecated in future releases.")
      if (!'headings' %in% names(mc)) {
        message("Setting 'headings' to ", !isTRUE(get(o)))
        allOpts[['headings']] <- !isTRUE(get(o))
      } else {
        message("Ignoring this option as 'headings' is also specified")
      }
    } else {
      allOpts[[o]] <- get(o)
    }
  }
  options('summarytools' = allOpts)
  return(invisible())
}
