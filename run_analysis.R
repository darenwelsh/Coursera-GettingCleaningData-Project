run_analysis <- function(){
    #
    # This script will do the following:
    # 1. Merge training & test data sets into one data set
    # 2. Extract only mean & sd for each measurement
    # 3. Name activities in data set with descriptive activity names
    # 4. Label data set with descriptive variable names
    # 5. From #4, create new data set with mean of each variable for each 
    #    activity and each subject
    # 
    # This script assumes you have downloaded and extracted the dataset
    # to a subdirectory called "dataset"
    # 
    # For more detailed information,
    # see https://github.com/darenwelsh/Coursera-GettingCleaningData-Project
    # which includes a ReadMe and CodeBook.
    # 
    
    ## setwd("~/r/Coursera/Coursera-GettingCleaningData-Project")
    
    # read in given names for the 561 variables
    features <- read.table("./dataset/features.txt")
    var_names <- as.character(features[,2])
    
    # read in subjects (people)
    test_subject <- read.table("./dataset/test/subject_test.txt")
    train_subject <- read.table("./dataset/train/subject_train.txt")
    subject <- rbind(test_subject, train_subject)
    subject <- as.data.frame(subject)
    names(subject) <- c("subject")
    
    # read in activity labels
    test_y <- read.table("./dataset/test/y_test.txt")
    train_y <- read.table("./dataset/train/y_train.txt")
    activity <- rbind(test_y, train_y)
    activity <- as.data.frame(activity)
    names(activity) <- c("activity")
    
    # read in the 561 variable data
    test_x <- read.table("./dataset/test/X_test.txt")
    train_x <- read.table("./dataset/train/X_train.txt")
    datapoints <- rbind(test_x, train_x)
    datapoints <- as.data.frame(datapoints)
    names(datapoints) <- var_names
    
    # subset from 561 variables to just mean()s and std()s
    # explain in code book why I chose just mean/std of measurements
    # not every mean in the dataset
    sub_var_list_mean <- agrep("mean()", var_names, value=TRUE)
    sub_var_list_std <- agrep("std()", var_names, value=TRUE)
    sub_var_list <- append(sub_var_list_mean, sub_var_list_std)
    # downselect from 561 to just the variables related to mean or std
    datapoints_subset <- datapoints[,sub_var_list]
    
    # modify variable names using info from features_info.txt
    # from "t" to "time"
    names(datapoints_subset) <- gsub("tBody","timeBody", names(datapoints_subset))
    names(datapoints_subset) <- gsub("tGravity","timeGravity", names(datapoints_subset))
    # from "f" to "frequency"
    names(datapoints_subset) <- gsub("fBody","frequencyBody", names(datapoints_subset))
    names(datapoints_subset) <- gsub("fGravity","frequencyGravity", names(datapoints_subset))
    # from "Acc" to "Accelerometer"
    names(datapoints_subset) <- gsub("Acc","Accelerometer", names(datapoints_subset))
    # from "Gyro" to "Gyroscope"
    names(datapoints_subset) <- gsub("Gyro","Gyroscope", names(datapoints_subset))
    # from "Mag" to "Magnitude"
    names(datapoints_subset) <- gsub("Mag","Magnitude", names(datapoints_subset))
    # remove "()" after "mean" in strings with "mean()" at end
    names(datapoints_subset) <- gsub("mean.[^-]*$","Mean", names(datapoints_subset))
    # remove "()" after "mean" in strings with "mean()-"
    names(datapoints_subset) <- gsub("mean..*-","Mean-", names(datapoints_subset))
    # remove "()" after "std" in strings with "std()" at end
    names(datapoints_subset) <- gsub("std.[^-]*$","StandardDeviation", names(datapoints_subset))
    # remove "()" after "std" in strings with "std()-"
    names(datapoints_subset) <- gsub("std..*-","StandardDeviation-", names(datapoints_subset))
    
    # bind into one df
    test_df <- cbind(subject, activity, datapoints_subset)
    
    # change activity labels to useful words based on activity_labels.txt
    test_df$activity <- gsub("1", "Walking", test_df$activity)
    test_df$activity <- gsub("2", "Walking Upstairs", test_df$activity)
    test_df$activity <- gsub("3", "Walking Downstairs", test_df$activity)
    test_df$activity <- gsub("4", "Sitting", test_df$activity)
    test_df$activity <- gsub("5", "Standing", test_df$activity)
    test_df$activity <- gsub("6", "Laying", test_df$activity)
    
    print(names(test_df))
    print(head(test_df[,1:3]))
    
}