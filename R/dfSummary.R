#' Data frame Summary
#'
#' Summary of a data frame consisting of: variable names, labels if any, factor
#' levels, frequencies and/or numerical summary statistics, and valid/missing
#' observation counts.
#'
#' @param x A data frame.
#' @param round.digits Number of significant digits to display. Defaults to
#'   \code{2} and can be set globally; see \code{\link{st_options}}.
#' @param varnumbers Logical. Should the first column contain variable number?
#'   Defaults to \code{TRUE}. Can be set globally; see \code{\link{st_options}},
#'   option \dQuote{dfSummary.varnumbers}.
#' @param labels.col Logical. If \code{TRUE}, variable labels (as defined with
#'   \pkg{rapportools}, \pkg{Hmisc} or \pkg{summarytools}' \code{label}
#'   functions) will be displayed. By default, the \emph{labels} column is shown
#'   if at least one column has a defined label.
#' @param valid.col Logical. Include column indicating count and proportion of
#'   valid (non-missing) values. \code{TRUE} by default, but can be set
#'   globally; see \code{\link{st_options}}, option
#'   \dQuote{dfSummary.valid.col}.
#' @param na.col Logical. Include column indicating count and proportion of
#'   missing (NA) values. \code{TRUE} by default, but can be set globally; see
#'   \code{\link{st_options}}, option \dQuote{dfSummary.na.col}.
#' @param graph.col Logical. Display barplots / histograms column in \emph{html}
#'   reports. \code{TRUE} by default, but can be set globally; see
#'   \code{\link{st_options}}, option \dQuote{dfSummary.graph.col}.
#' @param graph.magnif Numeric. Magnification factor, useful if the graphs show
#'   up too large (then use a value < 1) or too small (use a value > 1). Must be
#'   positive. Default to \code{1}. Can be set globally; see
#'   \code{\link{st_options}}, option \dQuote{dfSummary.graph.magnif}.
#' @param style Style to be used by \code{\link[pander]{pander}} when rendering
#'   output table. Defaults to \dQuote{multiline}. The only other valid option
#'   is \dQuote{grid}. Style \dQuote{simple} is not supported for this
#'   particular function, and \dQuote{rmarkdown} will fallback to
#'   \dQuote{multiline}.
#' @param plain.ascii Logical. \code{\link[pander]{pander}} argument; when
#'   \code{TRUE}, no markup characters will be used (useful when printing to
#'   console). Defaults to \code{TRUE}. Set to \code{FALSE} when in context of
#'   markdown rendering. To change the default value globally, see
#'   \code{\link{st_options}}.
#' @param justify String indicating alignment of columns; one of \dQuote{l}
#'   (left) \dQuote{c} (center), or \dQuote{r} (right). Defaults to \dQuote{l}.
#' @param headings Logical. Set to \code{FALSE} to omit headings. To change this
#'   default value globally, see \code{\link{st_options}}.
#' @param display.labels Logical. Should data frame label be displayed in the
#'   title section?  Default is \code{TRUE}. To change this default value
#'   globally, see \code{\link{st_options}}.
#' @param max.distinct.values The maximum number of values to display
#'   frequencies for. If variable has more distinct values than this number, the
#'   remaining frequencies will be reported as a whole, along with the number of
#'   additional distinct values. Defaults to 10.
#' @param trim.strings Logical; for character variables, should leading and
#'   trailing white space be removed? Defaults to \code{FALSE}. See
#'   \emph{details} section.
#' @param max.string.width Limits the number of characters to display in the
#'   frequency tables. Defaults to \code{25}.
#' @param split.cells A numeric argument passed to \code{\link[pander]{pander}}.
#'   It is the number of characters allowed on a line before splitting the cell.
#'   Defaults to \code{40}.
#' @param split.tables \pkg{pander} argument which determines the maximum width
#'   of a table. Keeping the default value (\code{Inf}) is recommended.
#' @param \dots Additional arguments passed to \code{\link[pander]{pander}}.
#'
#' @return A data frame with additional class \code{summarytools} containing as
#'   many rows as there are columns in \code{x}, with attributes to inform
#'   \code{print} method. Columns in the output data frame are:
#'   \describe{
#'     \item{No}{Number indicating the order in which column appears in the data
#'      frame.}
#'     \item{Variable}{Name of the variable, along with its class(es).}
#'     \item{Label}{Label of the variable (if applicable).} 
#'     \item{Stats / Values}{For factors, a list of their values, limited by the
#'       \code{max.distinct.values} parameter. For character variables, the most
#'        common values (in descending frequency order), also limited by
#'       \code{max.distinct.values}. For numerical variables, common univariate
#'       statistics (mean, std. deviation, min, med, max, IQR and CV).} 
#'     \item{Freqs (\% of Valid)}{For factors and character variables, the 
#'       frequencies and proportions of the values listed in the previous 
#'       column. For numerical vectors, number of distinct values, or frequency
#'       of distinct values if their number is not greater than 
#'       \code{max.distinct.values}.} 
#'     \item{Text Graph}{An ascii histogram for numerical variables, and ascii
#'       barplot for factors and character variables.} \item{Valid}{Number and 
#'       proportion of valid values.} 
#'     \item{Missing}{Number and proportion of missing (NA and NAN) values.} }
#'
#' @details The default \code{plain.ascii = TRUE} option is there to make
#'   results appear cleaner in the console. When used in a context of
#'   \emph{rmarkdown} rendering, set this option to \code{FALSE}.
#'
#'   When the \code{trim.strings} is set to \code{TRUE}, trimming is done
#'   \emph{before} calculating frequencies, so those will be impacted
#'   accordingly.
#'
#'   The package vignette \dQuote{Recommendations for Rmarkdown} provides
#'   valuable information for creating optimal \emph{Rmarkdown} documents with
#'   summarytools.
#'   
#' @examples
#' data(tobacco)
#' dfSummary(tobacco)
#' \dontrun{view(dfSummary(iris))}
#'
#' @keywords univar attribute classes category
#' @author Dominic Comtois, \email{dominic.comtois@@gmail.com}
#' @export
dfSummary <- function(x, round.digits = st_options('round.digits'), 
                      varnumbers = st_options('dfSummary.varnumbers'),
                      labels.col = length(label(x, all = TRUE)) > 0,
                      valid.col = st_options('dfSummary.valid.col'),
                      na.col = st_options('dfSummary.na.col'),
                      graph.col = st_options('dfSummary.graph.col'),
                      graph.magnif = st_options('dfSummary.graph.magnif'),
                      style = "multiline", 
                      plain.ascii = st_options('plain.ascii'),
                      justify = "left", headings = st_options('headings'),
                      display.labels = st_options('display.labels'),
                      max.distinct.values = 10, trim.strings = FALSE,  
                      max.string.width = 25, split.cells = 40,
                      split.tables = Inf, ...) {

  # Parameter validation ------------------------------------------------------
  
  parse_info <- try(parse_args(sys.calls(), sys.frames(), match.call()), 
                    silent = TRUE)
  if (any(grepl('try-', class(parse_info)))) {
    parse_info <- list()
  }

  if (!is.data.frame(x)) {
    x <- try(as.data.frame(x))

    if (inherits(x, "try-error")) {
      stop("x is not a data frame and attempted conversion failed")
    }

    message("x was converted to a data frame")
    parse_info$df_name <- parse_info$var_name

  }

  if ("file" %in% names(match.call())) {
    message(paste0("'file' argument is deprecated; use for instance ",
                   "print(x, file='a.txt') or view(x, file='a.html') instead"))
  }

  if (style=="rmarkdown") {
    message("'rmarkdown' style not supported - using 'multiline' instead.")
    style <- "multiline"
  }
  
  if (!graph.col %in% c(TRUE, FALSE)) {
    stop("'graph.col' must be either TRUE or FALSE.")
  }
  
  if (graph.magnif <= 0) {
    stop("'graph.magnif' must be > 0" )
  }
  
  if (!display.labels %in% c(TRUE, FALSE)) {
    stop("'display.labels' must be either TRUE or FALSE.")
  }

  if ("omit.headings" %in% names(match.call())) {
    message(paste0("'omit.headings' argument has been replaced by 'headings';",
                   "setting headings = ", 
                   !isTRUE(match.call()[['omit.headings']])))
    headings <- !isTRUE(match.call()[['omit.headings']])
  }
  
  # End of arguments validation
  
  # Initialize the output data frame -------------------------------------------
  
  output <- data.frame(No = numeric(),
                       Variable = character(),
                       Label = character(),
                       Stats = character(),
                       Frequencies = character(),
                       Graph_html = character(),
                       Graph_ascii = character(),
                       Valid = character(),
                       Missing = character(),
                       stringsAsFactors = FALSE,
                       check.names = FALSE)

  n_tot <- nrow(x)

  # iterate over columns of x --------------------------------------------------
  
  for(i in seq_len(ncol(x))) {
    
    # extract column data
    column_data <- x[[i]]

    # Add column number
    output[i,1] <- i

    # Add column name and class
    output[i,2] <- paste0(names(x)[i], "\\\n[",
                          paste(class(column_data), collapse = ", "),
                          "]")

    # Add column label (if applicable)
    if (isTRUE(labels.col)) {
      output[i,3] <- label(x[[i]])
      if (is.na(output[i,3]))
        output[i,3] <- ""
    }

    # Calculate valid vs missing data info
    n_miss <- sum(is.na(column_data))
    n_valid <- n_tot - n_miss

    # Factors: display a column of levels and a column of frequencies ----------
    if (is.factor(column_data)) {
      output[i,4:7] <- crunch_factor()
    }
    
    # Character data: display frequencies whenever possible --------------------
    else if (is.character(column_data)) {
      output[i,4:7] <- crunch_character()
    }
    
    # Numeric data, display a column of descriptive stats + column of freqs ----
    else if (is.numeric(column_data)) {
      output[i,4:7] <- crunch_numeric()
    }
    
    # Time/date data -----------------------------------------------------------
    else if (inherits(column_data, c("Date", "POSIXct"))) {
      output[i,4:7] <- crunch_time_date()
    }
      
    # Data does not fit in previous categories ---------------------------------
    else {
      output[i,4:7] <- crunch_other()
    }

    output[i,8] <- 
      paste0(n_valid, "\\\n(", round(n_valid / n_tot * 100, round.digits), "%)")
    output[i,9] <- 
      paste0(n_miss,  "\\\n(", round(n_miss  / n_tot * 100, round.digits), "%)")
  }

  # Prepare output object ------------------------------------------------------
  
  names(output) <- c("No", "Variable", "Label", "Stats / Values",
                     "Freqs (% of Valid)", "Graph", "Text Graph", "Valid",
                     "Missing")

  if (!isTRUE(varnumbers)) {
    output$No <- NULL
  }

  if (!isTRUE(labels.col)) {
    output$Label <- NULL
  }

  if (!isTRUE(graph.col)) {
    output$Graph <- NULL
    output[['Text Graph']] <- NULL
  }

  if (!isTRUE(valid.col)) {
    output$Valid <- NULL
  }
  
  if (!isTRUE(na.col)) {
    output$Missing <- NULL
  }
  
  # Set output attributes
  class(output) <- c("summarytools", class(output))
  attr(output, "st_type") <- "dfSummary"
  attr(output, "date") <- Sys.Date()
  attr(output, "fn_call") <- match.call()

  data_info <-
    list(Dataframe = parse_info$df_name,
         Dataframe.label = ifelse("df_label" %in% names(parse_info),
                                  parse_info$df_label, NA),
         # Subset = ifelse("rows_subset" %in% names(parse_info),
         #                 parse_info$rows_subset, NA),
         Dimensions = paste(nrow(x), "x", ncol(x)),
         Duplicates = sum(duplicated(x)))

  attr(output, "data_info") <- data_info[!is.na(data_info)]

  attr(output, "formatting") <- list(style          = style,
                                     round.digits   = round.digits,
                                     plain.ascii    = plain.ascii,
                                     justify        = justify,
                                     headings       =  headings,
                                     display.labels = display.labels,
                                     labels.col     = labels.col,
                                     split.cells    = split.cells,
                                     split.tables   = split.tables)

  attr(output, "user_fmt") <- list(... = ...)

  return(output)
}

# Utility functions ------------------------------------------------------------
align_numbers_dfs <- function(counts, props) {
  maxchar_cnt <- nchar(as.character(max(counts)))
  maxchar_pct <- nchar(sprintf(paste0("%.", 1, "f"), max(props*100)))
  paste(sprintf(paste0("%", maxchar_cnt, "i"), counts),
        sprintf(paste0("(%", maxchar_pct, ".", 1, "f%%)"), props*100))
}

#' @importFrom RCurl base64Encode
#' @importFrom graphics barplot hist par text plot.new
#' @importFrom grDevices dev.off nclass.Sturges png
encode_graph <- function(data, graph_type, graph.magnif = NA) {
  if (graph_type == "histogram") {
    png(img_png <- tempfile(fileext = ".png"), width = 150 * graph.magnif,
        height = 100 * graph.magnif, units = "px", bg = "transparent")
    par("mar" = c(0.03,0.01,0.07,0.01))
    data <- data[!is.na(data)]
    breaks_x <- pretty(range(data), n = min(nclass.Sturges(data), 250),
                       min.n = 1)
    hist_values <- suppressWarnings(hist(data, breaks = breaks_x, plot = FALSE))
    cl <- try(suppressWarnings(hist(data, freq = FALSE, breaks = breaks_x,
                                    axes = FALSE, xlab=NULL, ylab=NULL,
                                    main=NULL, col = "grey95",
                                    border = "grey65")),
              silent = TRUE)
    if (any(grepl('try-', class(cl)))) {
      plot.new()
      text("Graph Not Available", x = 0.5, y = 0.5, cex = 1)
    }
    
  } else if (graph_type == "barplot") {
    
    png(img_png <- tempfile(fileext = ".png"), width = 150 * graph.magnif,
        height = 26 * length(data) * graph.magnif, units = "px",
        bg = "transparent")
    par("mar" = c(0.03,0.01,0.05,0.01))
    data <- rev(data)
    bp_values <- barplot(data, names.arg = "", axes = FALSE, space = 0.2,
                         col = "grey97", border = "grey65", horiz = TRUE,
                         xlim = c(0, sum(data)))
  }
  
  dev.off()
  img_txt <- base64Encode(txt = readBin(con = img_png, what = "raw",
                                        n = file.info(img_png)[["size"]]),
                          mode = "character")
  return(sprintf('<img src="data:image/png;base64,%s">', img_txt))
}

txtbarplot <- function(props, maxwidth = 20) {
  #widths <- props / max(props) * maxwidth
  widths <- props * maxwidth
  outstr <- character(0)
  for (i in seq_along(widths)) {
    outstr <- paste(outstr, paste0(rep(x = 'I', times = widths[i]),
                                   collapse = ""),
                    sep = " \\ \n")
  }
  outstr <- sub("^ \\\\ \\n", "", outstr)
  return(outstr)
}

#' @importFrom grDevices nclass.Sturges
txthist <- function(data) {
  data <- data[!is.na(data)]
  breaks_x <- pretty(range(data), n = nclass.Sturges(data), min.n = 1)
  if (length(breaks_x) <= 10) {
    counts <- hist(data, breaks = breaks_x, plot = FALSE)$counts
  } else {
    counts <- as.vector(table(cut(data, breaks = 10)))
  }
  
  # make counts top at 10
  counts <- matrix(round(counts / max(counts) * 10), nrow = 1, byrow = TRUE)
  graph <- matrix(data = "", nrow = 6, ncol = length(counts))
  for (ro in 6:1) {
    for (co in seq_along(counts)) {
      if (counts[co] > 1) {
        graph[ro,co] <- ": "
      } else if (counts[co] > 0) {
        graph[ro,co] <- ". "
      } else {
        if (sum(counts[1, co:length(counts)] > 0)) {
          graph[ro,co] <- "\\ \\ "
        }
      }
    }
    counts <- matrix(apply(X = counts - 2, MARGIN = 2, FUN = max, 0),
                     nrow = 1, byrow = TRUE)
  }
  
  graphlines <- character()
  for (ro in seq_len(nrow(graph))) {
    graphlines[ro] <-  trimws(paste(graph[ro,], collapse = ""), "right")
  }
  return(paste(graphlines, collapse = "\\\n"))
}

#' @importFrom utils head
#' @importFrom stats na.omit
detect_barcode <- function(x) {
  
  x <- na.omit(x)[1:100]
  if (length(x) < 10 || (len <- min(nchar(x))) != max(nchar(x)) ||
      !len %in% c(8,12,13,14)) {
    return(FALSE)
  }
  
  x <- head(x, 20)
  
  type <- switch(as.character(len),
                 "8"  = "EAN-8",
                 "12" = "UPC",
                 "13" = "EAN-13",
                 "14" = "ITF-14")
  
  x_pad      <- paste0(strrep("0", 14-len), x)
  vect_code  <- lapply(strsplit(x_pad,""), as.numeric)
  weighted   <- lapply(vect_code, FUN = function(x) x * c(3,1))
  sums       <- mapply(weighted, FUN = sum)
  
  if (any(sums %% 10 != 0, na.rm = TRUE)) {
    return(FALSE)
  }
  
  return(type)
}

crunch_factor <- function() {
  
  outlist <- list()
  
  max.string.width    <- parent.frame()$max.string.width
  max.distinct.values <- parent.frame()$max.distinct.values
  graph.magnif        <- parent.frame()$graph.magnif
  round.digits        <- parent.frame()$round.digits
  
  n_levels <- nlevels(parent.frame()$column_data)
  counts   <- table(parent.frame()$column_data, useNA = "no")
  props    <- prop.table(counts)
  
  if (parent.frame()$n_levels == 0 && parent.frame()$n_valid == 0) {
    ouplist[[1]] <- "No levels defined"
    outlist[[2]] <- "All NA's"
    outlist[[3]] <- ""
    outlist[[4]] <- ""
    
  } else if (parent.frame()$n_valid == 0) {
    outlist[[1]] <- paste0(1:n_levels,"\\. ",
                           levels(parent.frame()$column_data),
                           collapse = "\\\n")
    outlist[[2]] <- "All NA's"
    outlist[[3]] <- ""
    outlist[[4]] <- ""
    
  } else if (n_levels <= max.distinct.values) {
    outlist[[1]] <- paste0(1:n_levels,"\\. ",
                           substr(levels(parent.frame()$column_data), 1,
                                  max.string.width),
                           collapse = "\\\n")
    counts_props <- align_numbers_dfs(counts, round(props, round.digits + 2))
    outlist[[2]] <- paste0("\\", counts_props, collapse = "\\\n")
    if (isTRUE(parent.frame()$graph.col) &&
        any(!is.na(parent.frame()$column_data))) {
      outlist[[3]] <- encode_graph(counts, "barplot", graph.magnif)
      outlist[[4]] <- txtbarplot(prop.table(counts))
    }
    
  } else {
    
    # more levels than allowed by max.distinct.values
    n_extra_levels <- n_levels - max.distinct.values
    
    outlist[[1]] <-
      paste0(1:max.distinct.values,"\\. ",
             substr(levels(parent.frame()$column_data), 1,
                    max.string.width)[1:max.distinct.values],
             collapse="\\\n")
    
    outlist[[1]] <- paste(outlist[[1]],
                          paste("[", n_extra_levels, "others", "]"),
                          sep="\\\n")
    
    counts_props <- align_numbers_dfs(
      c(counts[1:max.distinct.values],
        sum(counts[(max.distinct.values + 1):length(counts)])),
      c(props[1:max.distinct.values],
        round(sum(props[(max.distinct.values + 1):length(props)]),
              round.digits + 2))
    )
    
    outlist[[2]] <- paste0("\\", counts_props, collapse = "\\\n")
    
    if (isTRUE(parent.frame()$graph.col) &&
        any(!is.na(parent.frame()$column_data))) {
      # prepare data for barplot
      tmp_data <- parent.frame()$column_data
      levels(tmp_data)[max.distinct.values + 1] <-
        paste("[", n_extra_levels, "others", "]")
      tmp_data[which(as.numeric(tmp_data) > max.distinct.values)] <-
        paste("[", n_extra_levels, "others", "]")
      levels(tmp_data)[(max.distinct.values + 2):n_levels] <- NA
      outlist[[3]] <- encode_graph(table(tmp_data), "barplot", graph.magnif)
      outlist[[4]] <- txtbarplot(prop.table(table(tmp_data)))
    }
  }
  return(outlist)
}

crunch_character <- function() {
  
  outlist <- list()
  
  max.string.width    <- parent.frame()$max.string.width
  max.distinct.values <- parent.frame()$max.distinct.values
  graph.magnif        <- parent.frame()$graph.magnif
  round.digits        <- parent.frame()$round.digits
  
  if (isTRUE(parent.frame()$trim.strings)) {
    column_data <- trimws(parent.frame()$column_data)
  }
  
  n_empty <- sum(parent.frame()$column_data == "", na.rm = TRUE)
  
  if (n_empty == parent.frame()$n_tot) {
    outlist[[1]] <- ""
    outlist[[2]] <- "All empty strings"
    outlist[[3]] <- ""
    outlist[[4]] <- ""
    
  } else if (parent.frame()$n_miss == parent.frame()$n_tot) {
    outlist[[1]] <- ""
    outlist[[2]] <- "All NA's"
    outlist[[3]] <- ""
    outlist[[4]] <- ""
    
  } else if (n_empty + parent.frame()$n_miss == parent.frame()$n_tot) {
    outlist[[1]] <- ""
    outlist[[2]] <- "All empty strings / NA's"
    outlist[[3]] <- ""
    outlist[[4]] <- ""
    
  } else {
    
    counts <- table(parent.frame()$column_data, useNA = "no")
    props <- prop.table(counts)      
    
    # Check if data fits UPC / EAN barcode numbers patterns
    if (!isFALSE(barcode_type <-
                 detect_barcode(trimmed <-
                                trimws(parent.frame()$column_data)))) {
      
      outlist[[1]] <- paste(barcode_type, "codes \\\n",
                            "min  :", min(trimmed, na.rm = TRUE), "\\\n",
                            "max  :", max(trimmed, na.rm = TRUE), "\\\n",
                            "mode :", names(counts)[which.max(counts)])
      counts_props <- align_numbers_dfs(counts, round(props, round.digits + 2))
      outlist[[2]] <- paste0(counts_props, collapse = "\\\n")
      
      if (isTRUE(parent.frame()$graph.col)) {
        outlist[[3]] <- encode_graph(counts, "barplot", graph.magnif)
        outlist[[4]] <- txtbarplot(prop.table(counts))
      }
      
    } else if (length(counts) <= max.distinct.values + 1) {
      
      # Report all frequencies when allowed by max.distinct.values
      outlist[[1]] <- paste0(seq_along(counts), "\\. ",
                             substr(names(counts), 1, max.string.width),
                             collapse="\\\n")
      counts_props <- align_numbers_dfs(counts, round(props, round.digits + 2))
      outlist[[2]] <- paste0(counts_props, collapse = "\\\n")
      
      if (isTRUE(parent.frame()$graph.col)) {
        outlist[[3]] <- encode_graph(counts, "barplot", graph.magnif)
        outlist[[4]] <- txtbarplot(prop.table(counts))
      }
      
    } else {
      
      # Too many values - report most common strings
      counts <- sort(counts, decreasing = TRUE)
      props <- sort(props, decreasing = TRUE)
      n_extra_values <- length(counts) - max.distinct.values
      outlist[[1]] <- paste0(
        paste0(1:max.distinct.values,"\\. ",
               substr(names(counts), 1,
                      max.string.width)[1:max.distinct.values],
               collapse="\\\n"),
        paste("\\\n[", n_extra_values, "others", "]")
      )
      counts_props <- align_numbers_dfs(
        counts = c(counts[1:max.distinct.values],
                   sum(counts[(max.distinct.values + 1):length(counts)])),
        props = c(props[1:max.distinct.values],
                  round(sum(props[(max.distinct.values + 1):length(props)]),
                        round.digits + 2))
      )
      outlist[[2]] <- paste0(counts_props, collapse = "\\\n")
      
      if (isTRUE(parent.frame()$graph.col)) {
        # Prepare data for graph
        counts[max.distinct.values + 1] <-
          sum(counts[(max.distinct.values + 1):length(counts)])
        names(counts)[max.distinct.values + 1] <-
          paste0("[ ", n_extra_values, " others ]")
        counts <- counts[1:(max.distinct.values + 1)]
        outlist[[3]] <- encode_graph(counts, "barplot", graph.magnif)
        outlist[[4]] <- txtbarplot(prop.table(counts))
      }
    }
  }
  return(outlist)
}

#' @importFrom stats IQR median ftable sd
crunch_numeric <- function() {
  
  outlist <- list()
  
  max.string.width    <- parent.frame()$max.string.width
  max.distinct.values <- parent.frame()$max.distinct.values
  graph.magnif        <- parent.frame()$graph.magnif
  round.digits        <- parent.frame()$round.digits
  
  if (parent.frame()$n_miss == parent.frame()$n_tot) {
    outlist[[1]] <- ""
    outlist[[2]] <- "All NA's"
    outlist[[3]] <- ""
    outlist[[4]] <- ""
    
  } else {
    
    counts <- table(parent.frame()$column_data, useNA = "no")
    
    # Check if data fits UPC / EAN barcode numbers patterns
    if (!isFALSE(barcode_type <- detect_barcode(parent.frame()$column_data))) {
      
      outlist[[1]] <- paste(barcode_type, "codes \\\n",
                            "min  :", min(parent.frame()$column_data,
                                          na.rm = TRUE), "\\\n",
                            "max  :", max(parent.frame()$column_data, 
                                          na.rm = TRUE), "\\\n",
                            "mode :", names(counts)[which.max(counts)])
      
    } else if (length(counts) == 1) {
      outlist[[1]] <- "One distinct value"
      
    } else {
      outlist[[1]] <- paste(
        "mean (sd) : ", round(mean(parent.frame()$column_data, na.rm = TRUE),
                              round.digits),
        " (", round(sd(parent.frame()$column_data, na.rm = TRUE),
                    round.digits), ")\\\n",
        "min < med < max :\\\n", round(min(parent.frame()$column_data,
                                           na.rm = TRUE), round.digits),
        " < ", round(median(parent.frame()$column_data, na.rm = TRUE),
                     round.digits),
        " < ", round(max(parent.frame()$column_data, na.rm = TRUE),
                     round.digits), "\\\n",
        collapse="", sep="")
      
      # Data is binary: add mode
      if (length(counts) == 2 && counts[1] != counts[2]) {
        outlist[[1]] <- paste0(outlist[[1]], "mode: ",
                               names(counts)[which.max(parent.frame()$counts)])           
        
      } else if (length(counts) >= 3) {
        # Data has 3+ distinct values: add IQR and CV
        outlist[[1]] <-
          paste(outlist[[1]],
                "IQR (CV) : ", round(IQR(parent.frame()$column_data,
                                         na.rm = TRUE), round.digits),
                " (", round(sd(parent.frame()$column_data, na.rm = TRUE) /
                              mean(parent.frame()$column_data, na.rm = TRUE),
                            round.digits), ")", collapse="", sep="")
      }
    }
    
    extra_space <- FALSE
    
    # In specific circumstances, display most common values         
    if (length(counts) <= max.distinct.values &&
        (all(parent.frame()$column_data %% 1 == 0, na.rm = TRUE) ||
         identical(names(parent.frame()$column_data), "0") ||
         all(abs(as.numeric(names(counts[-which(names(counts) == "0")]))) >=
             10^-round.digits))) {
      
      props <- round(prop.table(counts), round.digits + 2)
      counts_props <- align_numbers_dfs(counts, props)
      
      outlist[[2]]  <-
        paste(
          paste0(rounded_names <-
                   format(round(as.numeric(names(counts)),
                                round.digits),
                          nsmall = round.digits *
                            !all(parent.frame()$column_data %% 1 == 0,
                                 na.rm = TRUE)),
                 ifelse(as.numeric(names(counts)) != as.numeric(rounded_names),
                        "!", " ")),
          counts_props, sep = ": ", collapse = "\\\n"
        )
      
      if (any(as.numeric(names(counts)) != as.numeric(rounded_names))) {
        extra_space <- TRUE
        outlist[[2]] <- paste(outlist[[2]], "! rounded", sep = "\\\n")
      }
      
    } else {
      # Do not display specific values - only the number of distinct values
      outlist[[2]] <- paste(length(counts), "distinct values")
      if (parent.frame()$n_miss == 0 &&
          (isTRUE(all.equal(parent.frame()$column_data,
                            min(parent.frame()$column_data):
                            max(parent.frame()$column_data))) ||
           isTRUE(all.equal(parent.frame()$column_data,
                            max(parent.frame()$column_data):
                            min(parent.frame()$column_data))))) {
        outlist[[2]] <- paste(outlist[[2]], "(Integer sequence)", sep = "\\\n")
      }
    }
    
    if (isTRUE(parent.frame()$graph.col)) {
      if (length(counts) <= max.distinct.values) {
        outlist[[3]] <- encode_graph(counts, "barplot", graph.magnif)
        outlist[[4]] <- txtbarplot(prop.table(counts))
        
        if (isTRUE(extra_space)) {
          outlist[[3]] <- paste0(outlist[[3]], "\n\n")
          outlist[[4]] <- paste0(outlist[[4]], " \\ \n \\")
        }
      } else {
        outlist[[3]] <- encode_graph(parent.frame()$column_data, "histogram",
                                     graph.magnif)
        outlist[[4]] <- txthist(parent.frame()$column_data)
      }
    }
  }
  return(outlist)
}

#' @importFrom lubridate as.period interval
crunch_time_date <- function() {
  
  outlist <- list()
  
  max.string.width    <- parent.frame()$max.string.width
  max.distinct.values <- parent.frame()$max.distinct.values
  graph.magnif        <- parent.frame()$graph.magnif
  round.digits        <- parent.frame()$round.digits
  
  if (parent.frame()$n_miss == parent.frame()$n_tot) {
    outlist[[1]] <- ""
    outlist[[2]] <- "All NA's"
    outlist[[3]] <- ""
    outlist[[4]] <- ""
    
  } else {
    
    counts <- table(parent.frame()$column_data, useNA = "no")
    
    # Report all frequencies when allowed by max.distinct.values
    if (length(counts) <= max.distinct.values) {
      outlist[[1]] <- paste0(seq_along(counts),". ", names(counts),
                             collapse="\\\n")
      props <- round(prop.table(counts), round.digits + 2)
      counts_props <- align_numbers_dfs(counts, props)
      outlist[[2]] <- paste(counts_props, collapse = "\\\n")
      outlist[[3]] <- encode_graph(counts, "barplot", graph.magnif)
      outlist[[4]] <- txtbarplot(prop.table(counts))
      
    } else {
      
      outlist[[1]] <- paste0(
        "min : ", tmin <- min(parent.frame()$column_data, na.rm = TRUE), "\\\n",
        "med : ", median(parent.frame()$column_data, na.rm = TRUE), "\\\n",
        "max : ", tmax <- max(parent.frame()$column_data, na.rm = TRUE), "\\\n",
        "range : ", sub(pattern = " 0H 0M 0S", replacement = "",
                        x = round(as.period(interval(tmin, tmax)),round.digits))
      )
      
      outlist[[2]] <- paste(length(counts), "distinct val.")
      
      if (isTRUE(parent.frame()$graph.col)) {
        tmp <- as.numeric(parent.frame()$column_data)[!is.na(
          parent.frame()$column_data)]
        outlist[[3]] <- encode_graph(tmp - mean(tmp), "histogram", graph.magnif)
        outlist[[4]] <- txthist(tmp - mean(tmp))
      }
    }
  }
  outlist 
}

crunch_other <- function() {
  
  outlist <- list()
  
  max.string.width    <- parent.frame()$max.string.width
  max.distinct.values <- parent.frame()$max.distinct.values
  graph.magnif        <- parent.frame()$graph.magnif
  round.digits        <- parent.frame()$round.digits
  
  counts <- table(parent.frame()$column_data, useNA = "no")
  
  if (parent.frame()$n_miss == parent.frame()$n_tot) {
    outlist[[1]] <- ""
    outlist[[2]] <- "All NA's"
    outlist[[3]] <- ""
    outlist[[4]] <- ""
    
  } else if (length(counts) <= max.distinct.values) {
    props <- round(prop.table(counts), parent.frame()$round.digits + 2)
    counts_props <- align_numbers_dfs(counts, props)
    outlist[[2]] <- paste0(counts_props, collapse = "\\\n")
    
  } else {
    outlist[[2]] <- paste(
      as.character(length(unique(parent.frame()$column_data))),
      "distinct val."
    )
  }
  
  outlist[[3]] <- ""
  outlist[[4]] <- ""
  
  return(outlist)
}
