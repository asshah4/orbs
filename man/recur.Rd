% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/recur.R
\name{recur}
\alias{recur}
\title{Recurrent Survival Data Format}
\usage{
recur(data, model_type, id, left, right, censor = NULL, event_dates = NULL)
}
\arguments{
\item{data}{A dataframe containing the subsequent parameters}

\item{model_type}{Model type that is indicated:
\itemize{
\item \code{trad} makes traditional survival table
\item \code{ag} makes table with risk periods starting at time of prior event
without conditional strata
\item \code{marginal} makes table with risk periods from entry to censorship with
strata per each event
\item \code{pwptt} makes table with risk periods starting at time of prior event
with conditional strata
\item \code{pwpgt} makes table with risk periods of each time interval between
events,  with conditional strata
}}

\item{id}{Column in dataframe that contains unique IDs for each row}

\item{left}{Column with left/enrollment dates}

\item{right}{Column with right/censoring time point, or right contact}

\item{censor}{Column that names if death/final censorship is known (0 or 1).
The default is that, if no censorship information is given, that are no
failure events at time of right contact. \code{censor} is not required for
recurrent event analysis, but is required for traditional survival tables.}

\item{event_dates}{Vector of columns that contain event dates}
}
\value{
A data frame organized into a survival table format. Output options
are in \strong{Details}. Generally, the following columns are generated:
\itemize{
\item \strong{id}: An ID column is created
\item \strong{start}: A formatted start time, usually 0
\item \strong{stop}: A formatted stop time, in days, from prior event
\item \strong{status}: If event occurred or not
\item \strong{strata}: Event strata that is being applied
}
}
\description{
Reformats recurrent event data (wide) into different models for
survival analysis, but can also be used for simple survival analysis tables
as well. The general format is how data tends to be collected. There is
left and right censoring date, a labeled event column that contains the
date of the event, and a censoring column for a final censoring event. The
accepted parameter options are listed, with the type of table that will be
generated:
\itemize{
\item \strong{traditional}: Traditional survival table that has single censoring
event (\code{trad})
\item \strong{counting} : Formally called the Andersen and Gill model (\code{ag}).
Counting process model assumes each event is independent and that a subject
contributes to the risk set during the time under observation. Multiple
events are treated as a new (but delayed) entry that is followed until the
next event. This means subjects under observation are at risk for a second
event, even without having had a prior event. There are thus no \emph{strata} in
the model.
\item \strong{marginal}: Formally called the Wei-Lin-Weissfield model, but more
commonly known as a marginal model (\code{marginal}). Marginal models assumes
each event is a separate process. Each subject is at risk for all events.
The time for an event starts at the beginning of follow-up for each
subject. Thus, each risk period is considered a different \emph{strata}
(regardless of if subject had an event or not).
\item \strong{conditional A}: Formally called the Prentice, Williams, and Peterson
total time model (\code{pwptt}). Conditional A models order events by
stratification, based on the number of events prior. All subjects are at
risk for the left \emph{strata}, but only those with a previous event are at
risk for a successive event. The total time to event is used.
\item \strong{conditional B}: Formally called the Prentice, Williams, and Peterson
gap time model (\code{pwpgt}). Conditional B models also order events by strata
(like conditional A), however the time to outcome is defined as the gap
between the time of previous event.
}
}
\details{
This function takes every event date, and creates several types of
recurrent event tables. It orders the data chronologically for repeat
events. Currently does normal (left event) and recurrent models (counting,
marginal, and conditional A and B models). Further details can be found at
\href{https://stats.idre.ucla.edu/sas/faq/how-can-i-model-repeated-events-survival-analysis-in-proc-phreg/}{IDRE}.
\itemize{
\item For recurrent events, the final censoring event can include death, or can
be ignored if its not considered a failure event.
\item For traditional survival analysis, \code{censor} is required and \code{event_dates}
should be left as NULL. The function will do the rest.
}

\strong{Performance}: Importantly, for large datasets of recurrent data (>500
rows), this function will show significant slow-down since it uses an
intuitive approach on defining the datasets. Future iterations will create
a vectorized approach that should provide performance speed-ups.
}
\examples{
\donttest{
# Data
data("mims")

# Parameters
id <- "patid"
left <- "left_visit_date_bl"
right <- "ldka"
event_dates <- c("mi_date_1", "mi_date_2", "mi_date_3")
model_type <- "marginal"
censor <- "DEATH_CV_YN"

# Run analysis
out <- recur(
  mims, model_type, id, left, right, censor, event_dates
)
}

}
