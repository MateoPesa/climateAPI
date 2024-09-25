library(dplyr)
# Creating the Station and Daily Dataset

#Get file path
file.path.origin <- "/Users/mateopesa/STSCI4520/myWork/finalProject/CRND0103-202404080750/"

#Files within directory
files <- list.files(file.path.origin,
                    full.names = FALSE,
                    recursive = TRUE)

#Get Station Data
pattern <- "CRND0103-(.*?)\\.txt"
all.data <- list()
for (i in 1:length(files)) {
  filepath <- paste(file.path.origin, files[i], sep = '')
  dat <-
    read.table(filepath,
               quote = "\"",
               comment.char = "",
               as.is = TRUE)
  
  #Station Dataset
  #Station identifier
  identifier <- dat[1, 1]
  
  #Longitude and Latitude
  longitude <- dat[1, 4]
  latitude <- dat[1, 5]
  
  #State, Station Name
  substrings <- sub(pattern, "\\1", files[i])
  state <- substr(substrings, 11, 12)
  station_name <- substr(substrings, 14, nchar(substrings))
  
  #Assign to a list of vectors
  all.data[[i]] <- c(station_name,
                     state,
                     identifier,
                     longitude,
                     latitude)
}

#Get rid of duplicate stations
unique_indices <- !duplicated(all.data)
unique.stations <- all.data[unique_indices]

#Form the Station dataframe
stations <-
  data.frame(matrix(
    unlist(unique.stations),
    nrow = length(unique.stations),
    byrow = TRUE
  ))

#Name the station dataframe
colnames(stations) <-
  c('Station_Name', "State", "Station_ID", "Longitude", "Latitude")

#Convert numeric columns to numeric type
stations$Station_ID <- as.numeric(stations$Station_ID)
stations$Longitude <- as.numeric(stations$Longitude)
stations$Latitude <- as.numeric(stations$Latitude)

#Daily Data

#Get number of rows to initialize a matrix
num.rows.total <- 0
num.cols <- 28
for (i in 1:length(files)) {
  filepath <- paste(file.path.origin, files[i], sep = '')
  dat <-
    read.table(filepath,
               quote = "\"",
               comment.char = "",
               as.is = TRUE)
  #Getting number of rows to initialize
  num.rows.total <- num.rows.total + nrow(dat)
}

#Initialize matrix
daily.data <- matrix(nrow = num.rows.total, ncol = num.cols)
daily.data <- as.data.frame(daily.data)
row.index <- 1

#Iterate through files and assign to the initialized dataframe
for (i in 1:length(files)) {
  filepath <- paste(file.path.origin, files[i], sep = '')
  dat <-
    read.table(filepath,
               quote = "\"",
               comment.char = "",
               as.is = TRUE)
  
  num.rows.temp <- nrow(dat)
  daily.data[row.index:(row.index + num.rows.temp - 1), 1:28] <- dat
  row.index <- row.index + num.rows.temp
}

#Set column names of daily dataframe
header <-
  read.table(
    paste(getwd(), '/myWork/finalProject/headers.txt', sep = ''),
    quote = "\"",
    comment.char = ''
  )
colnames(daily.data) <- header[29:56, ]

#Converting missing values
missing_values <- c(-9.0, -99.0, -999.0, -9999.0)
daily.data <- mutate_all(daily.data, ~ifelse(. %in% missing_values, NA, .))

#Converting data column to date type
daily.data$LST_DATE <- as.character(daily.data$LST_DATE)
daily.data$LST_DATE <- as.Date(daily.data$LST_DATE, format="%Y%m%d")

#Saving the Dataframes
write.csv(stations, file = 'myWork/finalProject/stations.csv')
saveRDS(stations, file = 'myWork/finalProject/stations.rds')
save(stations, file='../stations.RData')
save(stations,file='../stations.rda')

write.csv(daily.data, file = "myWork/finalProject/daily_data.csv")
saveRDS(daily.data, file = "myWork/finalProject/daily_data.rds")
save(daily_data, file='../daily_data.RData')
save(daily_data, file="../daily_data.rda")
