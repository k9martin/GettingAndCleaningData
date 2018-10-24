
library(plyr)


        # Download data if data ziped doesn't already exist
path <- file.path(getwd(),"compressed_data.zip")

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if (!file.exists(path)) {
        download.file(url, path, mode = "wb")
}

        # unzip zip file containing data if data directory doesn't already exist
uncompressed <- "UCI HAR Dataset"
if (!file.exists(uncompressed)) {
        unzip(path)
}

# 1. Merges the training and the test sets to create one data set.

        # read all data before merge it
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

        # merge data into one dataset
x_dataset <- rbind(x_train, x_test)
y_dataset <- rbind(y_train, y_test)
subject_dataset <- rbind(subject_train, subject_test)

        # remove individual data for saving memory
rm(x_train, y_train, subject_train, x_test, y_test, subject_test)

 # 2. Extracts only the measurements on the mean and standard deviation for each measurement.

features <- read.table("UCI HAR Dataset/features.txt")

        # filter by name containing mean() or std()
mean_std <- grep("-(mean|std)\\(\\)", features[, 2])

        # take only the subset with mean and std
x_dataset <- x_dataset[, mean_std]

        # correct the column names
names(x_dataset) <- features[mean_std, 2]

 # 3. Uses descriptive activity names to name the activities in the data set

activities <- read.table("UCI HAR Dataset/activity_labels.txt")

        # as in x_dataset, update y with correct values and activity column names
y_dataset[, 1] <- activities[y_dataset[, 1], 2]
names(y_dataset) <- "activity"


 # 4. Appropriately labels the data set with descriptive variable names.

        # correct column name
names(subject_dataset) <- "subject"


 # 5. From the data set in step 4, creates a second, independent tidy data
 # set with the average of each variable for each activity and each subject.

        # join all in one dataset
dataset <- cbind(x_dataset, y_dataset, subject_dataset)
        # apply the mean in every column but last two (subject and activity)
tidy_data <- ddply(dataset, .(subject, activity), function(x) colMeans(x[, 1:66]))
        # save the average in a new file called "tidy_data.txt"
write.table(tidy_data, "tidy_data.txt", row.name=FALSE)