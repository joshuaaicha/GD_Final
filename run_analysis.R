#Check if file exists
filename <- "GD_final.zip"
if (!file.exists(filename)){
   file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(file_url, filename, method = "curl")
}
#Checking if folder exists
if(!file.exists("UCI HAR Dataset")){
  unzip(filename)
}

#Merge training and datasets.
#Training Datasets.
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

#Test Datasets.
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

#Reading Features.
features <- read.table("UCI HAR Dataset/features.txt")

#Reading Activity labels.
activities <- read.table("UCI HAR Dataset/activity_labels.txt")

#Variable names
colnames(x_train) <- features[,2]
colnames(y_train) <- "activityID"
colnames(subject_train) <- "subjectID"
#Test Data names
colnames(x_test) <- features[,2]
colnames(y_test) <- "activityID"
colnames(x_test) <- "subjectID"

colnames(activities) <- c("activityID", "activityType")

#Actual Merging
trained <- cbind(x_train, subject_train,y_train)
tested <- cbind(x_test, subject_test, y_test)
#main data table
final <-  rbind(trained, tested)

#Extract mean and Standard deviation
newcolNames() <- colnames(final)

#Vectors for mean and standard deviation
mean_std <- ( grep1("activityID", newcolNames) |
  grepl("subjectID", newcolnames) |
  grepl("mean...", newcolnames) |
  grep1("std...",newcolNames)
)

sub_set <- final[,mean_std == TRUE]

active <- merge(sub_set, activities, by = "activityID", all.x = TRUE)

#Label the dataset

#create text file
clean_tidy <- aggregate(.~ subjectID + activityID, active, mean)
clean_tidy <- clean_tidy[order(clean_tidy$subjectID, clean_tidy$activityID),]

#New table
write.table(clean_tidy, "clean_tidy.txt", row.names = FALSE)