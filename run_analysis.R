# Set up the working dictionary
setwd("./UCI_HAR_Dataset")

library(dplyr)

# import train data
train_x_train <- read.table("./train/X_train.txt", header = FALSE)
train_y_train <- read.table("./train/Y_train.txt", header = FALSE)

# import test data
test_x_test <- read.table("./test/X_test.txt", header = FALSE)
test_y_test <- read.table("./test/Y_test.txt", header = FALSE)

# import activity labels
activity <- read.table("./activity_labels.txt", header = FALSE)

# import features
features <- read.table("./features.txt", header = FALSE)

# import features
features <- read.table("./features.txt", header = FALSE)

# import train subject
subject_train <- read.table("./train/subject_train.txt", header = FALSE)

# import test subject
subject_test <- read.table("./test/subject_test.txt", header = FALSE)

# rename the activity data
activity <- rename(activity, code = V1, type = V2)

# rename the train_y_train
train_y_train <- rename(train_y_train, code = V1)

# rename the test_y_test
test_y_test <- rename(test_y_test, code = V1)

# rename column name for train_x_train
colnames(train_x_train) <- features$V2

# rename column name for test_x_test
colnames(test_x_test) <- features$V2

# rename the subject_train ID
subject_train <- rename(subject_train, "subject_train_ID" = "V1")

# rename the subject_test ID
subject_test <- rename(subject_test, "subject_test_ID" = "V1")

# add subject_train_ID
train_x_train$subject_ID <- subject_train$subject_train_ID

# add subject_test_ID
test_x_test$subject_ID <- subject_test$subject_test_ID


# add activity code to train_x_train
train_x_train$code <- train_y_train$code

# add activity code to test_x_test
test_x_test$code <- test_y_test$code


# To complete the dataset which had been partitioned by 70% and 30% for training and test data
df <- rbind(train_x_train,test_x_test)


# merge the activity to completed dataset
merge_df <- merge(df, activity, by.x = "code")

merge_df <- relocate(merge_df, "subject_ID", "code", "type")

merge_df$type <- as.factor(merge_df$type)
merge_df$subject_ID <- as.numeric(merge_df$subject_ID)

# Extract data with mean and std
merge_df_extract <- merge_df[,1:9]


result <- merge_df_extract%>%
    group_by(subject_ID, type)%>%
    summarise(mean_X = mean(`tBodyAcc-mean()-X`),
              mean_Y = mean(`tBodyAcc-mean()-Y`),
              mean_Z = mean(`tBodyAcc-mean()-Z`),
              std_X = mean(`tBodyAcc-std()-X`),
              std_Y = mean(`tBodyAcc-std()-Y`),
              std_Z = mean(`tBodyAcc-std()-Z`)
    )


# write the tidy date
write.table(result, file = "tidydata.txt", row.names = FALSE)

