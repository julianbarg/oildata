#' Information on M&As and company groups in the pipelines dataset
#'
#'
#' Information on companies that were part of M&As groups among the largest 150 companies in the pipelines datasets (2014-2018).
#' Best used in conjunction with the groups dataset.
#'
#' @source Information on company ownership obtained from Nexis company dossies.
#'   \url{https://github.com/julianbarg/oil_industry/blob/master/workbooks/8py_resolve\%20issues.ipynb}
#' @format 156 observations of companies that are part of a group or have been part of an M&A:
#' \describe{
#'   \item{group_name}{Name of the company group.}
#'   \item{members}{Name of the member(s).}
#'   \item{start_year}{Year of the M&A (actually, year of 1st of January that the date of the M&A is closed to.)}
#'   \item{end_year}{Year that the company was spun off.}
#'   \item{type}{Whether the entry describes an M&A, or a member of a company group (some M&As might be included as groups if the merger occured before the observation period of the dataset - 2004-2018).}
#' }
#' @examples
#' \dontrun{
#'  m_as
#' }
"m_as"
