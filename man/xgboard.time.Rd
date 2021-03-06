% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/xgboard.time.R
\name{xgboard.time}
\alias{xgboard.time}
\title{Xgboard Metric Evaluation Time Reset (Environment)}
\usage{
xgboard.time(dump)
}
\arguments{
\item{dump}{Type: environment. An environment created by \code{xgboard.init}.}
}
\value{
An environment for the dumping. Does not store the dump though.
}
\description{
This function resets the timer on the environment for accurate timing of the model. This must be run before any xgboost run.
}

