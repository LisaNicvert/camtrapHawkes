# Header #############################################################
# 
# Author: Lisa Nicvert
# Email:  lisa.nicvert@univ-lyon1.fr
# 
# Date: 2023-02-28
#
# Script Description: contains functions to handle and format 
# camera trap data

# Modify data -------------------------------------------------------------

#' Add timestamps
#' 
#' Add a timestamps column to df.
#' 
#' @param df a dataframe with datetime column of type date.
#' @param origin optional origin (for which stamp is zero)
#' @param unit time unit to use for the stamps (delay in ...)
#'
#' @return  A dataframe with one more column (named stamp)
#' @export
add_stamps <- function(df, origin = NULL, unit = "days"){
  
  # -- Create min from data
  if(is.null(origin)){
    origin <- min(df$datetime)
    hour(origin) <- 0
    minute(origin) <- 0
    second(origin) <- 0
  }
  
  # -- Compute stamp
  dstamp <- df %>% mutate(stamp = as.numeric(as.duration(datetime - origin), unit)) 
  # store stamps in days
  
  # --- Reorder columns
  dstamp <- dstamp %>% select(cameraID, stamp, datetime, everything())
  
  return(dstamp)
}

#' Shift duplicates
#' 
#' Shift records occuring at the same timestamp on the same camera
#'
#' @param d a dataframe with columns
#'   row_ID (row id)
#'   cameraID (camera identifier)
#'   stamp (timestamp, numeric)
#' @param precision precision to consider
#'
#' @return input dataframe with modified timestamps.
#' @export
shift_duplicates <- function(d, precision = 10^6){
  
  if(1/precision > 1/(24*3600)){
    stop("precision must be less than 1 second (~ ", 
         round(1/(24*3600), 5), " day), so a power of 5 at least.")
  }
  
  # Copy reference data (move row_ID at the beginning)
  ref <- d %>% ungroup() %>% select(row_ID, everything())
  
  # Copy data and round stamps
  digits = round(log10(precision))
  test <- ref %>% mutate(stamp2 = round(stamp, digits = digits))
  
  nr <- -1
  i <- 1
  
  # Get random spacing
  seconds <- 1:60/(3600*24)
  seconds <- c(-seconds, seconds)
  seconds <- round(seconds, digits = digits)
  
  while(nr != 0 & i < 1000){
    # Get the rows of test for which camera and stamp is duplicated
    duplicate <- ref[duplicated(test[, c("cameraID","stamp2")]), ]
    
    # get row indices (in the reference dataset) of the rows that are duplicated
    duplicate_in_ref <- ref$row_ID %in% duplicate$row_ID
    
    # Replace the stamps that are duplicated (add time)
    randtime <- sample(x = seconds, 
                       size = length(ref$stamp[duplicate_in_ref]), 
                       replace = TRUE)
    
    # Change unrounded and rounded times
    # Get new time shifted from the original data (test$stamp)
    newtime <- test$stamp[duplicate_in_ref] + randtime
    # Update in return data and test data (to deselect those that changed)
    ref$stamp[duplicate_in_ref] <- newtime
    test$stamp2[duplicate_in_ref] <- newtime
    
    # Get the rows of test for which camera and stamp is duplicated
    duplicate_final <- ref[duplicated(ref[, c("cameraID","stamp")]), ]
    
    nr <- nrow(duplicate_final)
    i <- i+1
  }
  
  if(nr != 0){
    message("Warning, stopped before all duplicates were removed.")
  }
  return(ref)
}


# Visualise and summarise data --------------------------------------------

#' Get sampling info
#'
#' @param df A camera trap dataframe. Must have columns
#'   cameraID
#'   stamp
#' @param return return the summarized dataframe?
#'
#' @return prints a message summarizing sampling info for the cameras.
# If return = TRUE, also returns the summarized dataframe with
# min and max stamp and samplung duration for each camera.
#' @export
get_sampling_info <- function(df, return = TRUE){
  
  dat_summarised <- df %>%
    group_by(cameraID) %>%
    summarize(min_stamp = min(stamp),
              max_stamp = max(stamp),
              duration = max_stamp - min_stamp)
  
  meanlen <- mean(dat_summarised$duration)
  
  totlen <- sum(dat_summarised$duration)
  
  ncam <- length(unique(dat_summarised$cameraID))
  
  message("There are ", ncam, " cameras in total.\nEach camera sampling period is ",
          round(meanlen, 2), " days on average.\nThe total sampling length is ",
          round(totlen, 2), " days.\nThere are ",
          nrow(df), " occurrence events (rows) in the dataset.\n")
  
  if(return){
    return(dat_summarised)
  }
  
}


# Data quality ------------------------------------------------------------

#' Filter out cameras
#' 
#' Filter out cameras that have not enough observations/not enough 
#' frequent observations
#' 
#' @param df dataframe to filter. Must have columns cameraID, 
#' snapshotName, count, stamp
#' @param thr_obs minimal number of observations to keep camera
#' @param thr_freq minimal frequency of observations to keep camera
#' @param plot plot graphs?
#'
#' @return Returns the filtered dataframe. If plut = TRUE, ans plots 
#' camera sampling information.
#' @export
filter_inactive_cameras <- function(df, thr_obs, thr_freq, plot = TRUE){

  ncapture <- df %>% select(cameraID, snapshotName, count, stamp) %>% 
    group_by(cameraID) %>% 
    summarize(count = n(),
              minstamp = min(stamp), 
              maxstamp = max(stamp)) %>% 
    mutate(duration = maxstamp - minstamp) %>%
    mutate(freq = count/duration) %>%
    arrange(freq)
  
  camplot <- ncapture %>% filter(count > thr_obs)
  
  if(plot){
    g1 <- ggplot(ncapture) + 
      scale_y_log10() +
      geom_hline(yintercept = thr_obs, linetype = "dashed") +
      geom_point(aes(x = reorder(cameraID, count), y = count)) +
      theme(axis.text.x = element_text(angle=45, hjust=1))

    g2 <- ggplot(camplot) + 
      scale_y_log10() +
      geom_hline(yintercept = thr_freq, linetype = "dashed") +
      geom_point(aes(x = reorder(cameraID, freq), y = freq)) +
      theme(axis.text.x = element_text(angle=45, hjust=1))

    gridExtra::grid.arrange(grobs = list(g1, g2), nrow=1)
  }
  
  # Defines cameras that should be kept
  cam_to_keep <- ncapture %>% filter(count > thr_obs,
                                     freq > thr_freq)
  
  df_f <- df %>% filter(cameraID %in% cam_to_keep$cameraID)
  
  return(df_f)
}
