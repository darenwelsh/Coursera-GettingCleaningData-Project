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
    # 
    
    ## setwd("~/r/Coursera/Coursera-GettingCleaningData-Project")
    
    # read in names for the 561 variables
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
    
    # read in the 561 variables
    test_x <- read.table("./dataset/test/X_test.txt")
    train_x <- read.table("./dataset/train/X_train.txt")
    datapoints <- rbind(test_x, train_x)
    datapoints <- as.data.frame(datapoints)
    names(datapoints) <- var_names
    
    # subset from 561 variables to just means and SDs
    sub_var_list_mean <- agrep("mean", var_names, value=TRUE)
    sub_var_list_std <- agrep("std", var_names, value=TRUE)
    sub_var_list <- append(sub_var_list_mean, sub_var_list_std)
    
    datapoints_subset <- datapoints[,sub_var_list]
    
    
    # bind into one df
    test_df <- cbind(subject, activity, datapoints_subset)
    
    summary(test_df)
    
}