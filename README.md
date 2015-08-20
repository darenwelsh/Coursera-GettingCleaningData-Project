# Coursera-GettingCleaningData-Project

This repo is for the Coursera [Getting and Cleaning Data](https://class.coursera.org/getdata-031/human_grading/view/courses/975115/assessments/3/submissions) class project. The file [run_analysis.R](run_analysis.R) is an R script that takes accelerometer data from Samsung Galaxy S smartphones and performs the following:

1. Merges the training and the test sets to create one data set.
1. Extracts only the measurements on the mean and standard deviation for each measurement. 
1. Uses descriptive activity names to name the activities in the data set
1. Appropriately labels the data set with descriptive variable names. 
1. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### Configuration
In order for the run_analylsis.R script to work, download the data set from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) and extract it into a subdirectory called "dataset". For example, you might choose to clone this repo into `~/r/GCDproject`. In that case, the data should be downloaded and extracted into `~/r/GCDproject/dataset`.

### Code Book
For information about the variables, the data structure, and how the source data was manipulated for this project, see [the Code Book](CodeBook.md)

### Script Rationale
In order of execution, the following is an overview of what the script run_analysis() does:

1. Load necessary R libraries
1. Read in the names of each of the 561 variables in the source data. This is assigned as a character vector pulling just the values and not the row numbers.
1. Read in the two sets of values for test subjects, bind them into one vector, convert that to a data frame and assign the name "subject" to that column
1. Read in the two sets of values for test activities, bind them into one vector, convert that to a data frame and assign the name "activity" to that column
1. Read in the two sets of values for the 561 variables recorded, bind them into one matrix, convert that to a data frame and assign the names read in earlier for each variable
1. Generate a subset of variables, pulling only those with "mean()" or "std()" in the name as that seemed to most appropriately meet the request in the assignment. Then create a new subset dataframe with all the values for just these requested variables.
1. Run through a series of gsub commands to modify the given variable names to something more readable
1. Generate the data frame with all the cleaned data
1. Six commands to changes numeric values of activities to more meaningful word values
1. Create a copy of this dataframe to be used in generating "averagesdf" later
1. Generate a new "id" column by combining values of "subject" with "activity". This is used later as a factor to split the data for mean calculations.
1. Create "levels", a list of the levels for the new "id" factor just created and initialize the new data frame "averagesdf"
1. Loop through each level (e.g. "Subject1-Walking", etc.)
  1. Assign a temporary variable "lvl" as a data frame to get the actual value of the level being evaluated in the for loop. This allows the use of the value (e.g. "Subject1-Walking") instead of a numeric id (e.g. "1") See [this page](http://stackoverflow.com/questions/8774515/r-how-do-i-output-the-factor-level-from-a-for-loop-rather-than-the-index) for background.
  1. Generate a subset of the data frame, pulling just the values for that subject-activity pair
  1. Append a new row to the resulting data frame ("averagesdf") with the mean calculated for each column
1. Reassign averagesdf as a data frame and reapply the appropriate column names
1. Prepend the column names with "Average-" to indicate that these values are averages of the original data
1. Name the rows of averagesdf using the subject-activity pairs
1. Add two columns to the "left" of the data frame with the "subject" and "activity" separated to keep things "tidy"
1. Write the resulting data set out to a .txt file