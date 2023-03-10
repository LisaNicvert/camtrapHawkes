% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/functions_plot.R
\name{plot_perf}
\alias{plot_perf}
\title{Plots performance}
\usage{
plot_perf(d, xaxis = "trapping_days", thr, vline, psize = 1)
}
\arguments{
\item{d}{the dataframe of observed sensitivity and specificity.
It has columns:
value (sensitivity or specificity value)
type (sensitivity or specificity as "sensi" or "speci")
"xaxis" (a measure of trapping days)
  possibly qinf, qsup (then quantiles are plotted arould sensitivity
  and specificity values.)}

\item{xaxis}{name of the x-axis to choose for plotting (must be present in d)}

\item{thr}{optional threshold where to plot a horizontal line}

\item{vline}{optional vline to plot to draw attention to a specific time}

\item{psize}{point sizes}
}
\value{
a ggplot object with the sensitivity and specificity displayed along
xaxis.
}
\description{
Plots the performance of the inference.
}
