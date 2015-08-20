# Coursera-GettingCleaningData-Project

This repo is for the Coursera [Getting and Cleaning Data](https://class.coursera.org/getdata-031/human_grading/view/courses/975115/assessments/3/submissions) class project. The file [run_analysis.R](run_analysis.R) is an R script that takes accelerometer data from Samsung Galaxy S smartphones and performs the following:

1. Merges the training and the test sets to create one data set.
1. Extracts only the measurements on the mean and standard deviation for each measurement. 
1. Uses descriptive activity names to name the activities in the data set
1. Appropriately labels the data set with descriptive variable names. 
1. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### Configuration
In order for the run_analylsis.R script to work, download the data set from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) and extract it into a subdirectory called "dataset". For example, you might choose to clone this repo into `~/r/GCDproject`. In that case, the data should be downloaded and extracted into `~/r/GCDproject/dataset`.

### Background Information
For information about the variables, the data structure, and how the source data was manipulated for this project, see [the Code Book](CodeBook.md)
