% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/customRankings.R
\name{crRelativePitchingValue}
\alias{crRelativePitchingValue}
\title{Calculate relative rotisserie values for pitchers}
\usage{
crRelativePitchingValue(projs_df, pitching_df, configs)
}
\arguments{
\item{projs_df}{Data.frame of batting projections}

\item{pitching_df}{Data.frame of pitching stats}

\item{configs}{An `fbbConfigs` object}
}
\value{
An RRV object with custom pitcher values
}
\description{
Custom pitcher values based on relative rotisserie point values
}
