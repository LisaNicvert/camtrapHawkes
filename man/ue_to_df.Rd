% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/functions_unitevents.R
\name{ue_to_df}
\alias{ue_to_df}
\title{Simolation to dataframe}
\usage{
ue_to_df(ue)
}
\arguments{
\item{ue}{an array (nspecies, ncameras, nmax+1) in the same format as the output 
of HawkesMulti from the UnitEvents package).}
}
\value{
Returns a dataframe with columns:
  species
  camera
  stamp
}
\description{
Convert output of simulation generated with HawkesMulti to a dataframe 
(rows must be named).
}
