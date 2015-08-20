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
    # load required libraries
    library(plyr)
    
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
    # correct duplicate "BodyBody" to "Body"
    names(datapoints_subset) <- gsub("BodyBody","Body", names(datapoints_subset))
    
    # bind into one df
    df <- cbind(subject, activity, datapoints_subset)
    
    # change activity labels to useful words based on activity_labels.txt
    df$activity <- gsub("1", "Walking", df$activity)
    df$activity <- gsub("2", "WalkingUpstairs", df$activity)
    df$activity <- gsub("3", "WalkingDownstairs", df$activity)
    df$activity <- gsub("4", "Sitting", df$activity)
    df$activity <- gsub("5", "Standing", df$activity)
    df$activity <- gsub("6", "Laying", df$activity)
    
    # copy df for use in creating averagesdf (step 5)
    df2 <- df
    # add new "id" column combining "subject" and "activity" for easier factoring
    df2 <- data.frame("id"=paste("Subject", df$subject, "-", df$activity, sep=""), df[,3:68])
    
    # initialize "averagesdf"
    levels <- levels(df2$id)
    averagesdf <- NULL #numeric(length(levels(df2$id)))
    
    for(i in seq_along(levels)){
        # assign level via data.frame to get actual value
        # Ref: http://stackoverflow.com/questions/8774515/r-how-do-i-output-the-factor-level-from-a-for-loop-rather-than-the-index
        lvl <- data.frame(level = levels[i])
        subset <- subset.data.frame(df2, df2$id==as.character(lvl$level), select=2:67)
        averagesdf <- rbind(averagesdf, as.vector(colMeans(subset)))
    }
    
    averagesdf <- as.data.frame(averagesdf)
    avgnames <- names(df2[2:67])
    names(averagesdf) <- avgnames
    # prepend "Average-" to each variable name
    names(averagesdf) <- gsub("^(.*)", "Average-\\1", names(averagesdf))
    # name rows of new df with subject-activity pair
    row.names(averagesdf) <- levels(df2$id)
    
    # add cols for subject and activity back in just to be extra tidy
    subjectvals <- gsub("[A-Za-z]*([0-9]*)-.*$", "\\1", levels)
    activityvals <- gsub("[A-Za-z]*[0-9]*-(.*)$", "\\1", levels)
    averagesdf <- data.frame("subject"=subjectvals, "activity"=activityvals, averagesdf)
    
    #print(averagesdf[1:10,1:5])
    write.table(averagesdf, file="averages.txt", row.names=FALSE)
    
}