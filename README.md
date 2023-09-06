Week 4 project - Getting and Cleaning Data in R

Author - Shenq-Shyang Huang

Data Source: Human Activity Recognition Using Smartphones (<http://archive.ics.uci.edu/dataset/240/human+activity+recognition+using+smartphones>)

Data process strategy:

1.  import data from line 6 to line 27:

    \# import train data

    train_x_train \<- read.table("./train/X_train.txt", header = FALSE)

    train_y_train \<- read.table("./train/Y_train.txt", header = FALSE)

    \# import test data

    test_x_test \<- read.table("./test/X_test.txt", header = FALSE)

    test_y_test \<- read.table("./test/Y_test.txt", header = FALSE)

    \# import activity labels

    activity \<- read.table("./activity_labels.txt", header = FALSE)

    \# import features

    features \<- read.table("./features.txt", header = FALSE)

    \# import features

    features \<- read.table("./features.txt", header = FALSE)

    \# import train subject

    subject_train \<- read.table("./train/subject_train.txt", header = FALSE)

    \# import test subject

    subject_test \<- read.table("./test/subject_test.txt", header = FALSE)

2.  rename the column in activity data, I used "code" to replace V1, and "type" to replace V2:

    \# rename the activity data

    activity \<- rename(activity, code = V1, type = V2)

3.  rename columns in train data, I used "code" to replace V1

    \# rename the train_y_train

    train_y_train \<- rename(train_y_train, code = V1)

4.  rename column in test data, I used "code" to replace V1

    \# rename the test_y_test

    test_y_test \<- rename(test_y_test, code = V1)

5.  To import the features, I assigned the V2 column in feature data to as the column name in train and test data:

    \# rename column name for train_x_train

    colnames(train_x_train) \<- features\$V2

    \# rename column name for test_x_test

    colnames(test_x_test) \<- features\$V2

6.  Assign the subject_ID to train and test data:

    \# rename the subject_train ID

    subject_train \<- rename(subject_train, "subject_train_ID" = "V1")

    \# rename the subject_test ID

    subject_test \<- rename(subject_test, "subject_test_ID" = "V1")

7.  Assign the subject_ID to train and test data:

    \# add subject_train_ID

    train_x_train\$subject_ID \<- subject_train\$subject_train_ID

    \# add subject_test_ID

    test_x_test\$subject_ID \<- subject_test\$subject_test_ID

8.  Add the activity code to train and test data:

    \# add activity code to train_x_train

    train_x_train\$code \<- train_y_train\$code

    \# add activity code to test_x_test

    test_x_test\$code \<- test_y_test\$code

9.  All the above steps finalized the organization of train and test data, so they have the same column name. Then the next step is to combine both train and test data to one dataframe:

    \# To complete the dataset which had been partitioned by 70% and 30% for training and test data

    df \<- rbind(train_x_train,test_x_test)

10. The is a code column in df dataframe, to add the activity, I merge the df and activity (both share the same column "code")

    \# merge the activity to completed dataset

    merge_df \<- merge(df, activity, by.x = "code")

11. I rearrange the sequence of column, so the "subject_ID" is the first, then "code", and then "type":

    merge_df \<- relocate(merge_df, "subject_ID", "code", "type")

12. Assign the numeric and factor to subject_ID and type:

    merge_df\$type \<- as.factor(merge_df\$type)

    merge_df\$subject_ID \<- as.numeric(merge_df\$subject_ID)

13. I notice the mean and std are the required data, and there are numerous duplicated columns, therefore, I extracted the first 9 columns that covers what I need:

    \# Extract data with mean and std

    merge_df_extract \<- merge_df[,1:9]

14. Calculate the mean of data and assign it to a new dataframe "result":

    result \<- merge_df_extract%\>%

    group_by(subject_ID, type)%\>%

    summarise(mean_X = mean(\`tBodyAcc-mean()-X\`),

    mean_Y = mean(\`tBodyAcc-mean()-Y\`),

    mean_Z = mean(\`tBodyAcc-mean()-Z\`),

    std_X = mean(\`tBodyAcc-std()-X\`),

    std_Y = mean(\`tBodyAcc-std()-Y\`),

    std_Z = mean(\`tBodyAcc-std()-Z\`)

    )

15. Write a table and export as indicated:

    \# write the tidy date

    write.table(result, file = "tidydata.txt", row.names = FALSE)
