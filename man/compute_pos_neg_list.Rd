% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/functions_unitevents.R
\name{compute_pos_neg_list}
\alias{compute_pos_neg_list}
\title{Compute several true/false positives}
\usage{
compute_pos_neg_list(Msim_list, Mtrue, est = "BL")
}
\arguments{
\item{Msim_list}{a list, each element has elements $BL and $BOL and
in each there are $S (spontaneous part) and $I 
(interaction coefficients, lists.)}

\item{Mtrue}{true model: array (K*K*Ncomp array)}

\item{est}{estimator to use (BL, BVL or BOL)}
}
\value{
Returns a df with columns TP, FP, TN, FN and as many rows as
  there are models in Msim_list.
}
\description{
Evaluates several inferred models (in Msim_list) compared to the true
model used to generate data (Mtrue).
Computes:
    TP (true positives)
    FP (false positives)
    TN (true negatives)
    FN (false negatives)
}
