#' xgboost evaluation metric for maximum Kappa statistic
#' 
#' This function allows xgboost to use a custom thresholding method to maximize the Kappa statistic. You can use this function via \code{eval_metric}. It leaks memory over time, but it can be reclaimed using \code{gc()}.
#' 
#' @param pred Type: numeric. The predictions.
#' @param dtrain Type: xgb.DMatrix. The training data.
#' 
#' @return The maximum Kappa statistic for binary data.
#' 
#' @export

xgb.max_kappa <- function(pred, dtrain) {
  
  y_true <- getinfo(dtrain, "label")
  
  DT <- data.table(y_true = y_true, y_prob = pred, key = "y_prob")
  cleaner <- !duplicated(DT[, "y_prob"], fromLast = TRUE)
  nump <- sum(y_true)
  counter <- length(y_true)
  numn <- counter - nump
  
  DT[, tn_v := as.numeric(cumsum(y_true == 0))]
  DT[, fp_v := cumsum(y_true == 1)]
  DT[, fn_v := numn - tn_v]
  DT[, tp_v := nump - fp_v]
  DT <- DT[cleaner, ]
  DT <- DT[, pObs := (tp_v + tn_v) / counter]
  DT <- DT[, pExp := (((tp_v + fn_v) * (tp_v + fp_v)) + ((fp_v + tn_v) * (fn_v + tn_v))) / (counter * counter)]
  DT <- DT[, kappa := (pObs - pExp) / (1 - pExp)]
  
  best_row <- which.max(DT$kappa)
  
  if (length(best_row) > 0) {
    return(list(metric = "kappa", value = DT$kappa[best_row[1]]))
  } else {
    return(list(metric = "kappa", value = -1))
  }
  
}