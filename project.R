################################################################################
################################################################################
#
#                 QUANTITATIVE INVESTING 101 PROJECT R FILE
#
# ------------------------------------------------------------------------------
# Use this file to backtest your team's set of factors (Growth, Value,
# Quality, or Sentiment) and create your team's factor stock selection model.
#
# Most of the code to perform the backtests has been provided to you. However,
# you will be required to create the factor distributions, the summary table,
# the time series plots of the factor rank correlations.
#
# DON'T BE INTIMIDATED! You can do this, just put in a little bit of effort to
# understand the code provided and do some light googling to figure out how to
# create plots. ChatGPT or any other Large Language Model is fair game as well,
# use them as much as you want.
#
# We use the data.table constantly at work, so we are having you all use it
# for this project. An introduction to data.table can be found here:
# https://cran.r-project.org/web/packages/data.table/vignettes/datatable-intro.html
# The section that will be most useful for the project is the "Aggregations"
# section to create the summary table.
#
# You'll be interpreting the results and stating your conclusions in your
# final submission along with the distribution plots, summary table, and
# time series correlation plots produced from this script.
#
# After the first lecture, you'll return to this script to create and backtest
# your multi-factor stock selection model and create a summary table of it's
# performance as well.
################################################################################
################################################################################

################################################################################
# SETUP
################################################################################

# Library required packages
library(data.table)

# Read in dataset
dataset <- as.data.table(read.csv("dataset.csv"))

# Convert date column to a date type
## If this code does not work, look at the format of the date column in the
## dataset.csv file. You may need to change the format string to match the
## way the date is formatted in your `dataset` object
dataset[, date := as.Date(date, tryFormats = c("%m/%d/%y", "%Y-%m-%d"))]


################################################################################
################################################################################
#
#                             FACTOR BACKTESTS
#
################################################################################
################################################################################

################################################################################
# DISTRIBUTION OF FACTORS
# ------------------------------------------------------------------------------
# Create a histogram for each factor over the entire sample
#
# You can use the hist() function for your histograms:
# https://www.rdocumentation.org/packages/graphics/versions/3.6.2/topics/hist
#
# To create a histogram of a specific column in a dataset, we use the dataset
# name combined with a $ and the column name:
# hist(dataset$column)
#
# *** Include the plots in your final submission document ***
# USE THE 'Export' BUTTON UNDER THE 'Plots' PANE IN RSTUDIO TO SAVE THE PLOT
################################################################################

# *** WRITE YOUR CODE TO CREATE THE PLOTS HERE, COMMENT OUT CODE BELOW ***
# Hint: Try using the following prompt in ChatGPT:

# You are a world class R developer. I have a data.table object called
# dataset with the following column names:
# date, company_id, {insert your factor column names}
# I need to create a nice looking distribution plot for each of my factors.
# Please provide R code to create these distributions.

# Factor 1 (Book/Price, ROE, Sales Growth, or Up/Down Ratio)
# dist_factor_1 <-

hist(dataset$up_down_revisions, 
     breaks = 29, 
     col = "lightblue", 
     border = "black", 
     probability = TRUE,
     main = "Distribution of Up-Down Revisions",
     xlab = "Up-Down Revisions",
     ylab = "Density")
lines(density(dataset$up_down_revisions, na.rm = TRUE), 
      col = "red", 
      lwd = 2)



# Factor 2 (FCF Yield, Debt/IC, or 3M Return Momentum)
# dist_factor_2 <-

hist(dataset$momentum_3m, 
     breaks = 30, 
     col = "lightblue", 
     border = "black", 
     probability = TRUE,
     main = "Distribution of 3-Month Momentum",
     xlab = "3-Month Momentum",
     ylab = "Density")
lines(density(dataset$momentum_3m, na.rm = TRUE), 
      col = "red", 
      lwd = 2)

# Factor 3 (NTM EPS/Price, Return Volatility, or 12M Return Momentum)
# dist_factor_3 <-

hist(dataset$momentum_12m, 
     breaks = 30, 
     col = "lightblue", 
     border = "black", 
     probability = TRUE,
     main = "Distribution of 12-Month Momentum",
     xlab = "12-Month Momentum",
     ylab = "Density")
lines(density(dataset$momentum_12m, na.rm = TRUE), 
      col = "red", 
      lwd = 2)

################################################################################
# COMPUTE MEDIAN 3M AND 12M RETURN EACH MONTH
# ------------------------------------------------------------------------------
# We use the median stock return as the "benchmark" for our factor backtests.
# A stock index is usually market-cap weighted. This will cause the returns
# of the index to be heavily influenced by the largest stocks. To negate this
# effect, we use the median return in the universe as our benchmark since this
# is the return of the "typical" stock. 50% of the returns in the universe
# were higher than this return and 50% of the returns in the universe were
# lower.
#
# In data.table, you create a new column using ":=". You can use a
# function, combine other columns together, and a lot more:
#   dataset[, newColumn := someFunction(oldColumn)]
#   dataset[, column3 := column1 + column2]
################################################################################

# Calculate the median Forward 3 Month return for each month
dataset[, benchmark_return_3m := median(forward_return_3m), by = "date"]

# Calculate the median Forward 12 Month return for each month
dataset[, benchmark_return_12m := median(forward_return_12m), by = "date"]

# Don't forget to take a look at the dataset now! Type 'dataset' into your
# R console without the quotes or type View(dataset) to see the whole thing.
# What do you notice about the benchmark returns? How come they're the same
# for every stock each month?

# ANSW:
# The benchmark returns for the Forward 3 Month and Forward 12 Month periods 
# are calculated using the median stock return for each month. 
# This means that for every month, all stocks in the dataset are assigned 
# the same benchmark return, which is the median of their respective returns.


# Also try calculating the median Forward 3 and 12 month return for the
# most recent date in Excel. Do you get the same number as the last one
# in your dataset?

# Set the specific date for analysis
specific_date <- as.Date("2023-09-30")

# Step 1: Filter the dataset for the specific date
recent_data <- dataset[date == specific_date]

# Step 2: Calculate the median Forward 3 Month and Forward 12 Month returns
median_3m_return <- median(recent_data$forward_return_3m, na.rm = TRUE)
median_12m_return <- median(recent_data$forward_return_12m, na.rm = TRUE)

# Print the results
cat("Median Forward 3 Month Return on", specific_date, ":", median_3m_return, "\n")
cat("Median Forward 12 Month Return on", specific_date, ":", median_12m_return, "\n")

# Median Forward 3 Month Return on 19630 : 1.693501
# Median Forward 12 Month Return on 19630 : 2.570078 

# So no, we don't get the same results as before. 

################################################################################
# COMPUTE THE RELATIVE RETURN FOR EACH STOCK (STOCK RETURN - BENCHMARK RETURN)
# ------------------------------------------------------------------------------
# Here we are computing the relative return of each stock compared to the
# "benchmark" or "typical" stock as dicussed above.
################################################################################

# Calculate the relative 3 month return for every stock
dataset[, relative_return_3m := forward_return_3m - benchmark_return_3m]

# Calculate teh relative 12 month return for every stock
dataset[, relative_return_12m := forward_return_12m - benchmark_return_12m]

# Take a look at the dataset at this point. Now we have 2 new relative return
# columns for each stock.


################################################################################
# FUNCTION TO COMPUTE DECILES FOR EACH FACTOR
# ------------------------------------------------------------------------------
# Use the given function compute_tiles(factor, num_tiles = 10) to decile each
# factor. You'll need to do the analysis on each factor one at a time.
################################################################################

# Compute quantiles for each factor value. The number of quantiles is determined
# by the `num_tiles` argument.

# A more intuitive way of thinking about this function is it sorts stocks by
# their factor values (order all stocks based on their Book to Price ratio).
# Then it creates equal sized groups. The number of groups equals `num_tiles`.

compute_tiles <- function(factor, num_tiles = 10) {
  # Save number of observations
  num_observations <- sum(!is.na(factor))
  
  # Check to make sure we have observations
  if (num_observations == 0L) {
    rep(NA_integer_, length(factor))
  } else {
    # Compute rank order
    rank_order <- rank(
      x = factor,
      na.last = "keep",
      ties.method = "first"
    )
    
    # Compute percentile
    percentile <- (rank_order - 1) / num_observations
    
    # Scale up by num_tiles
    scaled_percentile <- percentile * num_tiles
    
    # Add 1 so lowest tile is 1 instaed of 0
    scaled_percentile <- scaled_percentile + 1
    
    # Turn tile into integers
    tiles <- as.integer(floor(scaled_percentile))
    
    # Return tiles
    return(tiles)
  }
}


################################################################################
# THE REST OF THE FACTOR BACKTEST ANALYSIS MUST BE DONE ONE FACTOR AT A TIME
# START WITH BookToPrice, CREATE THE PLOTS AND SUMMARY TABLES DESCRIBED BELOW
# AND SAVE THEM FOR YOUR FINAL SUBMISSION.
#
# ONCE YOU GET YOUR PLOTS AND SUMMARY TABLE CORRECTLY CREATED FOR YOUR FIRST
# FACTOR, YOU WILL RE-RUN EVERYTHING FOR YOUR SECOND AND THIRD FACTOR, RESAVING
# THE PLOTS AND SUMMARY TABLE.
#
# YOU CAN CHANGE THE FACTOR BEING ANALYZED BY CHANGING THE current_factor VALUE
# BELOW.
################################################################################

# Set the factor to be analyzed here
current_factor <- "momentum_12m"


################################################################################
# COMPUTE TILE BY DATE
################################################################################

# This will create those groups we mentioned earlier for every month
dataset_with_tiles <- copy(dataset)[,
                                    tile := compute_tiles(factor = get(current_factor), num_tiles = 10),
                                    by = "date"
]

# Make sure you take a look at the dataset at this point to see the tiles added
View(dataset_with_tiles)

################################################################################
# COMPUTE MEDIAN RELATIVE RETURN AND HIT RATE FOR EACH TILE ON EACH DATE
# ------------------------------------------------------------------------------
# Here we are computing the return and hit rate for each tile for each month.
# We use the median here again to negate the effects of large stocks or skewness
# in the returns. The hit rate as the percent of stocks in the tile that
# outperform the benchmark. A stock that has a higher return than the
# benchmark is said to have "outperformed".
#
# Remember our "benchmark" is the median stock return in our investment
# universe.
# Check out the Introduction to data.table given at the top of this file for
# more information on the .N part of the code chunk below.
################################################################################

# Compute the median forward return and hit rate for each tile on each date
# This will tell us how the "typical" stock in each group did relative
# to the "typical" stock in our investment universe

tile_performance <- dataset_with_tiles[,
                                       .(
                                         tile_median_return_3m = median(relative_return_3m),
                                         tile_median_return_12m = median(relative_return_12m),
                                         tile_hit_rate_3m = sum(relative_return_3m > 0) / .N,
                                         tile_hit_rate_12m = sum(relative_return_12m > 0) / .N
                                       ),
                                       by = c("date", "tile")
][order(date, tile)]


################################################################################
# COMPUTE LONG - SHORT RETURN, SAVE AS TILE = 11
################################################################################

# Function to compute Long - Short Returns and Hit Rates. Don't worry about
# how this code works other than it computes the return we would get if
# we bought the stocks in the highest group and sold short the stocks in
# the lowest group every month.

compute_long_short <- function(dataset) {
  # 'dataset' is a dataset containing the median return and hit rate for each
  # tile on each date.
  long <- dataset[, max(tile)]
  short <- dataset[, min(tile)]
  dataset[,
          .(
            tile = c(
              tile,
              tile[tile == long] + tile[tile == short]
            ),
            tile_median_return_3m = c(
              tile_median_return_3m,
              tile_median_return_3m[tile == long] - tile_median_return_3m[tile == short]
            ),
            tile_hit_rate_3m = c(
              tile_hit_rate_3m,
              (tile_hit_rate_3m[tile == long] - tile_hit_rate_3m[tile == short]) / 2 + 0.5
            ),
            tile_median_return_12m = c(
              tile_median_return_12m,
              tile_median_return_12m[tile == long] - tile_median_return_12m[tile == short]
            ),
            tile_hit_rate_12m = c(
              tile_hit_rate_12m,
              (tile_hit_rate_12m[tile == long] - tile_hit_rate_12m[tile == short]) / 2 + 0.5
            )
          ),
          by = "date"
  ]
}

# Compute Long - Short Returns and Hit Rates
tile_performance <- compute_long_short(tile_performance)


################################################################################
# CREATE SUMMARY TABLE OF THE 3MO AND 12MO RETURNS AND HIT RATES FOR EACH TILE
# ------------------------------------------------------------------------------
# Take the average 3m return, average 12m return, average 3m hit rate, and
# average 12m hit rate by tile.
#
# Check out the "Aggregations" section of the Introduction to data.table page:
# https://cran.r-project.org/web/packages/data.table/vignettes/datatable-intro.html
#
# You can use the code chunk where we compute tile_performance as a guide.
# What's the difference between what we wanted to do there versus now? Do we
# want to compute the average return and hit rate by date and tile? Or just by
# date? Or just by tile?
#
# *Take a screenshot of your summary table to include in your final submission*
################################################################################

# *** WRITE YOUR CODE TO CREATE THE SUMMARY TABLE HERE, COMMENT OUT CODE BELOW ***

compute_tile_summary <- function(dataset) {
  dataset[, .(
    avg_return_3m = mean(tile_median_return_3m, na.rm = TRUE),
    avg_return_12m = mean(tile_median_return_12m, na.rm = TRUE),
    avg_hit_rate_3m = mean(tile_hit_rate_3m, na.rm = TRUE),
    avg_hit_rate_12m = mean(tile_hit_rate_12m, na.rm = TRUE)
  ), by = tile]
}

# Compute the summary table
factor_summary <- compute_tile_summary(tile_performance)

# Print the summary table
print(factor_summary)


################################################################################
# FACTOR RANK CORRELATIONS
# ------------------------------------------------------------------------------
# Now we will calculate the percentile ranking for each factor to understand
# their relationship with one another. We want to look at the correlation of the
# percentile rankings between each factor pair. This will help us understand
# if one two factors produce the same stocks to buy and sell.
#
# Use the function compute_percentile below and save the percentile ranks for
# each factor. Call the columns 'rank_factor1', 'rank_factor2', and
# 'rank_factor3' (you should replace factor1, factor2, and factor3 with
# your actual factor names, e.g. rank_book_to_price).
#
# You can use the cor() function to compute the correlations on each date
# similar to how we compute the median return for the investment universe
# on each date. This is called the cross sectional rank correlation.
# https://www.rdocumentation.org/packages/stats/versions/3.6.2/topics/cor
#
# Finally, plot the correlation for each pair over time. Use the plot()
# function to create the plots.
# https://www.rdocumentation.org/packages/graphics/versions/3.6.2/topics/plot
#
# * Include your correlations in your final submission with an interpretation
# of what they mean. Think about how this will help or hurt the performance
# of our stock selection model we will create later. We'll go over this more
# in the second lecture. *
################################################################################

# Function to compute the percentile values for each factor
# We need to compute the percentile values to compute rank correlations and
# later to create a weighted average ranking for our stock selection model.
compute_percentiles <- function(factor, flip = FALSE) {
  # Save number of observations
  num_observations <- sum(!is.na(factor))
  # Check to make sure we have observations
  if (num_observations == 0L) {
    rep(NA_integer_, length(factor))
  } else {
    # Compute rank order
    rank_order <- rank(
      x = factor,
      na.last = "keep",
      ties.method = "first"
    )
    # Compute percentile
    percentile <- (rank_order - 1) / num_observations
    # Flip to make higher worse if required
    if (flip) percentile <- 1 - percentile
    # Return percentiles
    return(percentile)
  }
}

# *** FILL IN THE CODE BELOW TO COMPUTE THE PERCENTILE RANKS FOR EACH FACTOR ***
# Compute percentiles
percentiles <- copy(dataset)[,
                             .(company_id,
                               rank_Momentum3mo = compute_percentiles(momentum_3m),
                               rank_Momentum12mo = compute_percentiles(momentum_12m),
                               rank_UpDownRevisions = compute_percentiles(up_down_revisions)
                             ),
                             by = c("date")
]

# Correlations
correlations <- copy(percentiles)[,
                                  .(
                                    cor_Momentum3mo_Momentum12mo = cor(rank_Momentum3mo, rank_Momentum12mo),
                                    cor_Momentum3mo_UpDownRevisions = cor(rank_Momentum3mo, rank_UpDownRevisions),
                                    cor_Momentum12mo_UpDownRevisions = cor(rank_Momentum12mo, rank_UpDownRevisions)
                                  ),
                                  by = "date"
]

# Plot correlations over time
plot_cor_Momentum3mo_Momentum12mo <- plot(
  x = as.Date(correlations$date),
  y = correlations$cor_Momentum3mo_Momentum12mo,
  main = "3-Month Price Momentum and 12-Month Price Momentum Correlation",
  xlab = "Date",
  ylab = "Correlation",
  type = "h"
)
plot_cor_Momentum3mo_UpDownRevisions <- plot(
  x = as.Date(correlations$date),
  y = correlations$cor_Momentum3mo_UpDownRevisions,
  main = "3-Month Price Momentum and Analyst Up-Down Revision Ratio Correlation",
  xlab = "Date",
  ylab = "Correlation",
  type = "h"
)
plot_cor_Momentum12mo_UpDownRevisions <- plot(
  x = as.Date(correlations$date),
  y = correlations$cor_Momentum12mo_UpDownRevisions,
  main = "12-Month Price Momentum and Analyst Up-Down Revision Ratio Correlation",
  xlab = "Date",
  ylab = "Correlation",
  type = "h"
)



# different code to get the colors and such right!!!

install.packages("ggplot2")

library(ggplot2)

# Example for "3-Month Price Momentum and 12-Month Price Momentum Correlation"
plot_cor_Momentum3mo_Momentum12mo <- ggplot(correlations, aes(x = as.Date(date), y = cor_Momentum3mo_Momentum12mo)) +
  geom_col(aes(fill = cor_Momentum3mo_Momentum12mo)) +
  scale_fill_gradientn(
    colors = c("blue", "green", "red"),  # Blue for negative, green for neutral, red for positive
    name = "Correlation",
    limits = c(-.15, .15),  # To ensure that the color scale spans the range of correlation values
    oob = scales::squish
  ) +
  labs(
    title = "3-Month Price Momentum and 12-Month Price Momentum Correlation",
    x = "Date",
    y = "Correlation"
  ) +
  theme_minimal()

# Example for "3-Month Price Momentum and Analyst Up-Down Revision Ratio Correlation"
plot_cor_Momentum3mo_UpDownRevisions <- ggplot(correlations, aes(x = as.Date(date), y = cor_Momentum3mo_UpDownRevisions)) +
  geom_col(aes(fill = cor_Momentum3mo_UpDownRevisions)) +
  scale_fill_gradientn(
    colors = c("blue", "green", "red"),
    name = "Correlation",
    limits = c(-.15, .15),
    oob = scales::squish
  ) +
  labs(
    title = "3-Month Price Momentum and Analyst Up-Down Revision Ratio Correlation",
    x = "Date",
    y = "Correlation"
  ) +
  theme_minimal()

# Example for "12-Month Price Momentum and Analyst Up-Down Revision Ratio Correlation"
plot_cor_Momentum12mo_UpDownRevisions <- ggplot(correlations, aes(x = as.Date(date), y = cor_Momentum12mo_UpDownRevisions)) +
  geom_col(aes(fill = cor_Momentum12mo_UpDownRevisions)) +
  scale_fill_gradientn(
    colors = c("blue", "green", "red"),
    name = "Correlation",
    limits = c(-.15, .15),
    oob = scales::squish
  ) +
  labs(
    title = "12-Month Price Momentum and Analyst Up-Down Revision Ratio Correlation",
    x = "Date",
    y = "Correlation"
  ) +
  theme_minimal()

# To display the plots
plot_cor_Momentum3mo_Momentum12mo
plot_cor_Momentum3mo_UpDownRevisions
plot_cor_Momentum12mo_UpDownRevisions


# Calculate the mean correlation coefficients for each pair of variables
mean_cor_Momentum3mo_Momentum12mo <- mean(correlations$cor_Momentum3mo_Momentum12mo, na.rm = TRUE)
mean_cor_Momentum3mo_UpDownRevisions <- mean(correlations$cor_Momentum3mo_UpDownRevisions, na.rm = TRUE)
mean_cor_Momentum12mo_UpDownRevisions <- mean(correlations$cor_Momentum12mo_UpDownRevisions, na.rm = TRUE)

# Print the mean values
print(paste("Mean correlation between 3-Month and 12-Month Price Momentum: ", mean_cor_Momentum3mo_Momentum12mo))
print(paste("Mean correlation between 3-Month Price Momentum and Analyst Up-Down Revision Ratio: ", mean_cor_Momentum3mo_UpDownRevisions))
print(paste("Mean correlation between 12-Month Price Momentum and Analyst Up-Down Revision Ratio: ", mean_cor_Momentum12mo_UpDownRevisions))





# Box plot for 3-Month Momentum (without colors and legend)
plot_momentum_3m <- ggplot(dataset_with_tiles, aes(x = factor(tile), y = momentum_3m)) +
  geom_boxplot() +
  labs(
    title = "3-Month Momentum by Tiles",
    x = "Tiles (Deciles)",
    y = "Momentum 3-Month"
  ) +
  theme_minimal() +
  theme(legend.position = "none")  # Remove legend

# Box plot for 12-Month Momentum (without colors and legend)
plot_momentum_12m <- ggplot(dataset_with_tiles, aes(x = factor(tile), y = momentum_12m)) +
  geom_boxplot() +
  labs(
    title = "12-Month Momentum by Tiles",
    x = "Tiles (Deciles)",
    y = "Momentum 12-Month"
  ) +
  theme_minimal() +
  theme(legend.position = "none")  # Remove legend

# Box plot for Up-Down Revisions (without colors and legend)
plot_up_down_revisions <- ggplot(dataset_with_tiles, aes(x = factor(tile), y = up_down_revisions)) +
  geom_boxplot() +
  labs(
    title = "Up-Down Revisions by Tiles",
    x = "Tiles (Deciles)",
    y = "Up-Down Revisions"
  ) +
  theme_minimal() +
  theme(legend.position = "none")  # Remove legend

# To display the plots
plot_momentum_3m
plot_momentum_12m
plot_up_down_revisions



# Bar chart for 12-Month Momentum by Tiles
plot_momentum_12m_bar <- ggplot(dataset_with_tiles, aes(x = factor(tile), y = momentum_12m)) +
  stat_summary(fun = "median", geom = "bar", fill = "skyblue", color = "black") +
  labs(
    title = "12-Month Momentum by Tiles (Bar Chart)",
    x = "Tiles (Deciles)",
    y = "Mean 12-Month Momentum"
  ) +
  theme_minimal() +
  theme(legend.position = "none")  # Remove legend

# To display the plot
plot_momentum_12m_bar










################################################################################
# EXTRA CREDIT: COMPUTE AND PLOT INFORMATION COEFFICENTS (IC)
# ------------------------------------------------------------------------------
# Use the compute_percentiles function above and the explanation of ICs in the
# project pdf to compute and plot the IC for each factor over time. There is
# less guidance for this part since it's extra credit.
################################################################################

# *** WRITE YOUR CODE HERE ***



################################################################################
################################################################################
#
#        CREATE A MULTI-FACTOR STOCK SELECTION MODEL TO MANAGE A FACTOR
#              PORTFOLIO WITH A 12 MONTH AVERAGE HOLDING PERIOD
#
################################################################################
################################################################################

################################################################################
# DESCRIPTION
# ------------------------------------------------------------------------------
# Every group will create a stock selection model to pick stocks based on
# their factor type. For example, the Value team will use their value
# factors to create a Value Portfolio. You are basically creating a new
# "factor" that is a combinations of the factors we have backtested already.
# Then we backtest that new factor to see how our "model" performs. You will
# follow the same exact process that we used in the factor backtests above.
# Copy and paste the code as necessary under each prompt below.
################################################################################

# Compute the percentile ranks for each factor using compute_percentiles()
# just like we used compute_tiles() earlier

library(data.table)
dataset <- as.data.table(read.csv("dataset.csv"))

# Calculate the median Forward 3 Month return for each month
dataset[, benchmark_return_3m := median(forward_return_3m), by = "date"]

# Calculate the median Forward 12 Month return for each month
dataset[, benchmark_return_12m := median(forward_return_12m), by = "date"]

# Calculate the relative 3 month return for every stock
dataset[, relative_return_3m := forward_return_3m - benchmark_return_3m]

# Calculate the relative 12 month return for every stock
dataset[, relative_return_12m := forward_return_12m - benchmark_return_12m]

compute_tiles <- function(factor, num_tiles = 10) {
  # Save number of observations
  num_observations <- sum(!is.na(factor))
  
  # Check to make sure we have observations
  if (num_observations == 0L) {
    rep(NA_integer_, length(factor))
  } else {
    # Compute rank order
    rank_order <- rank(
      x = factor,
      na.last = "keep",
      ties.method = "first"
    )
    
    # Compute percentile
    percentile <- (rank_order - 1) / num_observations
    
    # Scale up by num_tiles
    scaled_percentile <- percentile * num_tiles
    
    # Add 1 so lowest tile is 1 instaed of 0
    scaled_percentile <- scaled_percentile + 1
    
    # Turn tile into integers
    tiles <- as.integer(floor(scaled_percentile))
    
    # Return tiles
    return(tiles)
  }
}

# Function to compute the percentile values for each factor
# We need to compute the percentile values to compute rank correlations and
# later to create a weighted average ranking for our stock selection model.
compute_percentiles <- function(factor, flip = FALSE) {
  # Save number of observations
  num_observations <- sum(!is.na(factor))
  # Check to make sure we have observations
  if (num_observations == 0L) {
    rep(NA_integer_, length(factor))
  } else {
    # Compute rank order
    rank_order <- rank(
      x = factor,
      na.last = "keep",
      ties.method = "first"
    )
    # Compute percentile
    percentile <- (rank_order - 1) / num_observations
    # Flip to make higher worse if required
    if (flip) percentile <- 1 - percentile
    # Return percentiles
    return(percentile)
  }
}

dataset[,
        ':='(
          PercMomentum3m = compute_percentiles(momentum_3m),
          PercMomentum12m = compute_percentiles(momentum_12m),
          PercUpDownRevisions = compute_percentiles(up_down_revisions)
        ),  
        by = "date"
]

##WEIGHTS
w_momentum3m <- (19/100)
w_momentum12m <- (8/10)
w_updownrevisions <- (1/100)

dataset[,
        ModelScore := (PercMomentum3m * w_momentum3m) + 
          (PercMomentum12m * w_momentum12m) +
          (PercUpDownRevisions * w_updownrevisions)
]

current_factor <- "ModelScore"

dataset_with_tiles <- copy(dataset)[,
                                    tile := compute_tiles(factor = get(current_factor), num_tiles = 10),
                                    by = "date"  
]

tile_performance <- dataset_with_tiles[,
                                       .(
                                         tile_median_return_3m = median(relative_return_3m),
                                         tile_median_return_12m = median(relative_return_12m),
                                         tile_hit_rate_3m = sum(relative_return_3m > 0) / .N,
                                         tile_hit_rate_12m = sum(relative_return_12m > 0) / .N
                                       ),
                                       by = c("date", "tile")
][order(date, tile)]

compute_long_short <- function(dataset) {
  # 'dataset' is a dataset containing the median return and hit rate for each
  # tile on each date.
  long <- dataset[, max(tile)]
  short <- dataset[, min(tile)]
  dataset[,
          .(
            tile = c(
              tile,
              tile[tile == long] + tile[tile == short]
            ),
            tile_median_return_3m = c(
              tile_median_return_3m,
              tile_median_return_3m[tile == long] - tile_median_return_3m[tile == short]
            ),
            tile_hit_rate_3m = c(
              tile_hit_rate_3m,
              (tile_hit_rate_3m[tile == long] - tile_hit_rate_3m[tile == short]) / 2 + 0.5
            ),
            tile_median_return_12m = c(
              tile_median_return_12m,
              tile_median_return_12m[tile == long] - tile_median_return_12m[tile == short]
            ),
            tile_hit_rate_12m = c(
              tile_hit_rate_12m,
              (tile_hit_rate_12m[tile == long] - tile_hit_rate_12m[tile == short]) / 2 + 0.5
            )
          ),
          by = "date"
  ]
}

tile_performance <- compute_long_short(tile_performance)

summary <- tile_performance[,
                            .(
                              AverageMedian3mo = mean(tile_median_return_3m),
                              AverageMedian12mo = mean(tile_median_return_12m),
                              AverageHitRate3mo = mean(tile_hit_rate_3m),
                              AverageHitRate12mo = mean(tile_hit_rate_12m)
                            ),  
                            by = "tile"                        
]

#weights at line 545



sharpe_ratio <- function(weights) {
  # Ensure weights sum to 1
  weights <- weights / sum(weights)
  
  # Calculate the ModelScore
  dataset[, ModelScore := weights[1] * PercMomentum3m + 
            weights[2] * PercMomentum12m + 
            weights[3] * PercUpDownRevisions]
  
  # Recompute tile returns
  dataset_with_tiles <- dataset[, tile := compute_tiles(factor = ModelScore, num_tiles = 10), by = "date"]
  
  tile_performance <- dataset_with_tiles[,
                                         .(
                                           tile_median_return_12m = median(relative_return_12m)
                                         ),
                                         by = c("date", "tile")
  ]
  
  # Calculate long-short performance
  long_short_return <- tile_performance[tile == max(tile), mean(tile_median_return_12m)] - 
    tile_performance[tile == min(tile), mean(tile_median_return_12m)]
  
  # Calculate standard deviation for Sharpe Ratio
  return_mean <- mean(long_short_return)
  return_std <- sd(long_short_return)
  
  # Return the negative Sharpe Ratio (for minimization)
  return(-return_mean / return_std)
}

# Optimize weights
initial_weights <- c(0.33, 0.33, 0.34)  # Starting point
optimal_weights <- optim(par = initial_weights, fn = sharpe_ratio, method = "L-BFGS-B", lower = 0, upper = 1)$par
optimal_weights <- optimal_weights / sum(optimal_weights)  # Normalize
