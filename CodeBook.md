## Project Description
This project takes data from a study in which 30 subjects performed 6 different activities while carrying a waist-mounted smartphone with embedded inertial sensors. This project merges the data from the study's training and test datasets into one data frame, extracting only the measurements on the mean and standard deviation for each measurement. The activity and variable names are modified to be more descriptive. From this data frame, a second data frame is generated with the average of each variable calculated for each subject-activity pair. This second data frame is written out to a file "averages.txt".

##Study design and data processing

###Collection of the raw data
The variables selected for the source database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 
Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

* mean(): Mean value
* std(): Standard deviation
* mad(): Median absolute deviation 
* max(): Largest value in array
* min(): Smallest value in array
* sma(): Signal magnitude area
* energy(): Energy measure. Sum of the squares divided by the number of values. 
* iqr(): Interquartile range 
* entropy(): Signal entropy
* arCoeff(): Autorregresion coefficients with Burg order equal to 4
* correlation(): correlation coefficient between two signals
* maxInds(): index of the frequency component with largest magnitude
* meanFreq(): Weighted average of the frequency components to obtain a mean frequency
* skewness(): skewness of the frequency domain signal 
* kurtosis(): kurtosis of the frequency domain signal 
* bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window
* angle(): Angle between to vectors

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

* gravityMean
* tBodyAccMean
* tBodyAccJerkMean
* tBodyGyroMean
* tBodyGyroJerkMean

The complete list of variables of each feature vector is available in 'features.txt'

For more information about the source data, see the [Human Activity Recognition Using Smartphones Data Set page (UCI)](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

###Notes on the original (raw) data 
Note that the original data included some instances where the word "Body" was duplicated. That duplication was corrected in this project.

##Creating the tidy datafile

###Guide to create the tidy data file
In order for the run_analylsis.R script to work, download the data set from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) and extract it into a subdirectory called "dataset". For example, you might choose to clone this repo into `~/r/GCDproject`. In that case, the data should be downloaded and extracted into `~/r/GCDproject/dataset`.

###Cleaning of the data
In order of execution, the following is an overview of what the script run_analysis() does:

1. Load necessary r libraries
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

Note that only variables with calculated mean or standard deviation were retained. While some variables in the source data set have "mean" and "std" in the name, this script only retains those with "mean()" and "std()" since those seem to best match the request in the assignment. If one wanted to modify the script to include those other variables, it wouldn't take much work.

See the [ReadMe](README.md) for further information about how the script works.

##Description of the variables in the averages.txt file
The resulting dataset "averages.txt" is 68 columns by 180 rows. The 180 rows cover 30 subjects (numbered "1" through "30") each performing 6 activities ("Walking", "WalkingUpstairs", "WalkingDownstairs", "Sitting", "Standing", and "Laying".

The variable names are modified from the source data to more-readable names in this script.
* "t" is expanded to "time"
* "f" is expanded to "frequency"
* "Acc" is expanded to "Accelerometer"
* "Gyro" is expanded to "Gyroscope"
* "Mag" is expanded to "Magnitude"
* "()" are removed from "mean()" "std()"
* "BodyBody" is corrected to "Body"

###subject   

Class: Factor
Levels: 1 to 30

* 1      :  6  
* 10     :  6  
* 11     :  6  
* 12     :  6  
* 13     :  6  
* 14     :  6  
* (Other):144  

###activity 

Class: Factor
Levels: All 6 are listed below

* Laying           :30  
* Sitting          :30  
* Standing         :30  
* Walking          :30  
* WalkingDownstairs:30  
* WalkingUpstairs  :30  

###Average.timeBodyAccelerometer.Mean.X

Class: Numeric

* Min.   :0.2216                      
* 1st Qu.:0.2712                      
* Median :0.2770                      
* Mean   :0.2743                      
* 3rd Qu.:0.2800                      
* Max.   :0.3015                      

###Average.timeBodyAccelerometer.Mean.Y

Class: Numeric

* Min.   :-0.040514                   
* 1st Qu.:-0.020022                   
* Median :-0.017262                   
* Mean   :-0.017876                   
* 3rd Qu.:-0.014936                   
* Max.   :-0.001308                   

###Average.timeBodyAccelerometer.Mean.Z

Class: Numeric

* Min.   :-0.15251                    
* 1st Qu.:-0.11207                    
* Median :-0.10819                    
* Mean   :-0.10916                    
* 3rd Qu.:-0.10443                    
* Max.   :-0.07538                    

###Average.timeGravityAccelerometer.Mean.X

Class: Numeric

* Min.   :-0.6800                        
* 1st Qu.: 0.8376                        
* Median : 0.9208                        
* Mean   : 0.6975                        
* 3rd Qu.: 0.9425                        
* Max.   : 0.9745                        

###Average.timeGravityAccelerometer.Mean.Y

Class: Numeric

* Min.   :-0.47989                       
* 1st Qu.:-0.23319                       
* Median :-0.12782                       
* Mean   :-0.01621                       
* 3rd Qu.: 0.08773                       
* Max.   : 0.95659                       

###Average.timeGravityAccelerometer.Mean.Z

Class: Numeric

* Min.   :-0.49509                       
* 1st Qu.:-0.11726                       
* Median : 0.02384                       
* Mean   : 0.07413                       
* 3rd Qu.: 0.14946                       
* Max.   : 0.95787                       

###Average.timeBodyAccelerometerJerk.Mean.X

Class: Numeric

* Min.   :0.04269                         
* 1st Qu.:0.07396                         
* Median :0.07640                         
* Mean   :0.07947                         
* 3rd Qu.:0.08330                         
* Max.   :0.13019                         

###Average.timeBodyAccelerometerJerk.Mean.Y

Class: Numeric

* Min.   :-0.0386872                      
* 1st Qu.: 0.0004664                      
* Median : 0.0094698                      
* Mean   : 0.0075652                      
* 3rd Qu.: 0.0134008                      
* Max.   : 0.0568186                      

###Average.timeBodyAccelerometerJerk.Mean.Z

Class: Numeric

* Min.   :-0.067458                       
* 1st Qu.:-0.010601                       
* Median :-0.003861                       
* Mean   :-0.004953                       
* 3rd Qu.: 0.001958                       
* Max.   : 0.038053                       

###Average.timeBodyGyroscope.Mean.X

Class: Numeric

* Min.   :-0.20578                
* 1st Qu.:-0.04712                
* Median :-0.02871                
* Mean   :-0.03244                
* 3rd Qu.:-0.01676                
* Max.   : 0.19270                

###Average.timeBodyGyroscope.Mean.Y

Class: Numeric

* Min.   :-0.20421                
* 1st Qu.:-0.08955                
* Median :-0.07318                
* Mean   :-0.07426                
* 3rd Qu.:-0.06113                
* Max.   : 0.02747                

###Average.timeBodyGyroscope.Mean.Z

Class: Numeric

* Min.   :-0.07245                
* 1st Qu.: 0.07475                
* Median : 0.08512                
* Mean   : 0.08744                
* 3rd Qu.: 0.10177                
* Max.   : 0.17910                

###Average.timeBodyGyroscopeJerk.Mean.X

Class: Numeric

* Min.   :-0.15721                    
* 1st Qu.:-0.10322                    
* Median :-0.09868                    
* Mean   :-0.09606                    
* 3rd Qu.:-0.09110                    
* Max.   :-0.02209                    

###Average.timeBodyGyroscopeJerk.Mean.Y

Class: Numeric

* Min.   :-0.07681                    
* 1st Qu.:-0.04552                    
* Median :-0.04112                    
* Mean   :-0.04269                    
* 3rd Qu.:-0.03842                    
* Max.   :-0.01320                    

###Average.timeBodyGyroscopeJerk.Mean.Z

Class: Numeric

* Min.   :-0.092500                   
* 1st Qu.:-0.061725                   
* Median :-0.053430                   
* Mean   :-0.054802                   
* 3rd Qu.:-0.048985                   
* Max.   :-0.006941                   

###Average.timeBodyAccelerometerMagnitude.Mean

Class: Numeric

* Min.   :-0.9865                            
* 1st Qu.:-0.9573                            
* Median :-0.4829                            
* Mean   :-0.4973                            
* 3rd Qu.:-0.0919                            
* Max.   : 0.6446                            

###Average.timeGravityAccelerometerMagnitude.Mean

Class: Numeric

* Min.   :-0.9865                               
* 1st Qu.:-0.9573                               
* Median :-0.4829                               
* Mean   :-0.4973                               
* 3rd Qu.:-0.0919                               
* Max.   : 0.6446                               

###Average.timeBodyAccelerometerJerkMagnitude.Mean

Class: Numeric

* Min.   :-0.9928                                
* 1st Qu.:-0.9807                                
* Median :-0.8168                                
* Mean   :-0.6079                                
* 3rd Qu.:-0.2456                                
* Max.   : 0.4345                                

###Average.timeBodyGyroscopeMagnitude.Mean

Class: Numeric

* Min.   :-0.9807                        
* 1st Qu.:-0.9461                        
* Median :-0.6551                        
* Mean   :-0.5652                        
* 3rd Qu.:-0.2159                        
* Max.   : 0.4180                        

###Average.timeBodyGyroscopeJerkMagnitude.Mean

Class: Numeric

* Min.   :-0.99732                           
* 1st Qu.:-0.98515                           
* Median :-0.86479                           
* Mean   :-0.73637                           
* 3rd Qu.:-0.51186                           
* Max.   : 0.08758                           

###Average.frequencyBodyAccelerometer.Mean.X

Class: Numeric

* Min.   :-0.9952                          
* 1st Qu.:-0.9787                          
* Median :-0.7691                          
* Mean   :-0.5758                          
* 3rd Qu.:-0.2174                          
* Max.   : 0.5370                          

###Average.frequencyBodyAccelerometer.Mean.Y

Class: Numeric

* Min.   :-0.98903                         
* 1st Qu.:-0.95361                         
* Median :-0.59498                         
* Mean   :-0.48873                         
* 3rd Qu.:-0.06341                         
* Max.   : 0.52419                         

###Average.frequencyBodyAccelerometer.Mean.Z

Class: Numeric

* Min.   :-0.9895                          
* 1st Qu.:-0.9619                          
* Median :-0.7236                          
* Mean   :-0.6297                          
* 3rd Qu.:-0.3183                          
* Max.   : 0.2807                          

###Average.frequencyBodyAccelerometerJerk.Mean.X

Class: Numeric

* Min.   :-0.9946                              
* 1st Qu.:-0.9828                              
* Median :-0.8126                              
* Mean   :-0.6139                              
* 3rd Qu.:-0.2820                              
* Max.   : 0.4743                              

###Average.frequencyBodyAccelerometerJerk.Mean.Y

Class: Numeric

* Min.   :-0.9894                              
* 1st Qu.:-0.9725                              
* Median :-0.7817                              
* Mean   :-0.5882                              
* 3rd Qu.:-0.1963                              
* Max.   : 0.2767                              

###Average.frequencyBodyAccelerometerJerk.Mean.Z

Class: Numeric

* Min.   :-0.9920                              
* 1st Qu.:-0.9796                              
* Median :-0.8707                              
* Mean   :-0.7144                              
* 3rd Qu.:-0.4697                              
* Max.   : 0.1578                              

###Average.frequencyBodyGyroscope.Mean.X

Class: Numeric

* Min.   :-0.9931                      
* 1st Qu.:-0.9697                      
* Median :-0.7300                      
* Mean   :-0.6367                      
* 3rd Qu.:-0.3387                      
* Max.   : 0.4750                      

###Average.frequencyBodyGyroscope.Mean.Y

Class: Numeric

* Min.   :-0.9940                      
* 1st Qu.:-0.9700                      
* Median :-0.8141                      
* Mean   :-0.6767                      
* 3rd Qu.:-0.4458                      
* Max.   : 0.3288                      

###Average.frequencyBodyGyroscope.Mean.Z

Class: Numeric

* Min.   :-0.9860                      
* 1st Qu.:-0.9624                      
* Median :-0.7909                      
* Mean   :-0.6044                      
* 3rd Qu.:-0.2635                      
* Max.   : 0.4924                      

###Average.frequencyBodyAccelerometerMagnitude.Mean

Class: Numeric

* Min.   :-0.9868                                 
* 1st Qu.:-0.9560                                 
* Median :-0.6703                                 
* Mean   :-0.5365                                 
* 3rd Qu.:-0.1622                                 
* Max.   : 0.5866                                 

###Average.frequencyBodyAccelerometerJerkMagnitude.Mean

Class: Numeric

* Min.   :-0.9940                                     
* 1st Qu.:-0.9770                                     
* Median :-0.7940                                     
* Mean   :-0.5756                                     
* 3rd Qu.:-0.1872                                     
* Max.   : 0.5384                                     

###Average.frequencyBodyGyroscopeMagnitude.Mean

Class: Numeric

* Min.   :-0.9865                             
* 1st Qu.:-0.9616                             
* Median :-0.7657                             
* Mean   :-0.6671                             
* 3rd Qu.:-0.4087                             
* Max.   : 0.2040                             

###Average.frequencyBodyGyroscopeJerkMagnitude.Mean

Class: Numeric

* Min.   :-0.9976                                 
* 1st Qu.:-0.9813                                 
* Median :-0.8779                                 
* Mean   :-0.7564                                 
* 3rd Qu.:-0.5831                                 
* Max.   : 0.1466                                 

###Average.timeBodyAccelerometer.StandardDeviation.X

Class: Numeric

* Min.   :-0.9961                                  
* 1st Qu.:-0.9799                                  
* Median :-0.7526                                  
* Mean   :-0.5577                                  
* 3rd Qu.:-0.1984                                  
* Max.   : 0.6269                                  

###Average.timeBodyAccelerometer.StandardDeviation.Y

Class: Numeric

* Min.   :-0.99024                                 
* 1st Qu.:-0.94205                                 
* Median :-0.50897                                 
* Mean   :-0.46046                                 
* 3rd Qu.:-0.03077                                 
* Max.   : 0.61694                                 

###Average.timeBodyAccelerometer.StandardDeviation.Z

Class: Numeric

* Min.   :-0.9877                                  
* 1st Qu.:-0.9498                                  
* Median :-0.6518                                  
* Mean   :-0.5756                                  
* 3rd Qu.:-0.2306                                  
* Max.   : 0.6090                                  

###Average.timeGravityAccelerometer.StandardDeviation.X

Class: Numeric

* Min.   :-0.9968                                     
* 1st Qu.:-0.9825                                     
* Median :-0.9695                                     
* Mean   :-0.9638                                     
* 3rd Qu.:-0.9509                                     
* Max.   :-0.8296                                     

###Average.timeGravityAccelerometer.StandardDeviation.Y

Class: Numeric

* Min.   :-0.9942                                     
* 1st Qu.:-0.9711                                     
* Median :-0.9590                                     
* Mean   :-0.9524                                     
* 3rd Qu.:-0.9370                                     
* Max.   :-0.6436                                     

###Average.timeGravityAccelerometer.StandardDeviation.Z

Class: Numeric

* Min.   :-0.9910                                     
* 1st Qu.:-0.9605                                     
* Median :-0.9450                                     
* Mean   :-0.9364                                     
* 3rd Qu.:-0.9180                                     
* Max.   :-0.6102                                     

###Average.timeBodyAccelerometerJerk.StandardDeviation.X

Class: Numeric

* Min.   :-0.9946                                      
* 1st Qu.:-0.9832                                      
* Median :-0.8104                                      
* Mean   :-0.5949                                      
* 3rd Qu.:-0.2233                                      
* Max.   : 0.5443                                      

###Average.timeBodyAccelerometerJerk.StandardDeviation.Y

Class: Numeric

* Min.   :-0.9895                                      
* 1st Qu.:-0.9724                                      
* Median :-0.7756                                      
* Mean   :-0.5654                                      
* 3rd Qu.:-0.1483                                      
* Max.   : 0.3553                                      

###Average.timeBodyAccelerometerJerk.StandardDeviation.Z

Class: Numeric

* Min.   :-0.99329                                     
* 1st Qu.:-0.98266                                     
* Median :-0.88366                                     
* Mean   :-0.73596                                     
* 3rd Qu.:-0.51212                                     
* Max.   : 0.03102                                     

###Average.timeBodyGyroscope.StandardDeviation.X

Class: Numeric

* Min.   :-0.9943                              
* 1st Qu.:-0.9735                              
* Median :-0.7890                              
* Mean   :-0.6916                              
* 3rd Qu.:-0.4414                              
* Max.   : 0.2677                              

###Average.timeBodyGyroscope.StandardDeviation.Y

Class: Numeric

* Min.   :-0.9942                              
* 1st Qu.:-0.9629                              
* Median :-0.8017                              
* Mean   :-0.6533                              
* 3rd Qu.:-0.4196                              
* Max.   : 0.4765                              

###Average.timeBodyGyroscope.StandardDeviation.Z

Class: Numeric

* Min.   :-0.9855                              
* 1st Qu.:-0.9609                              
* Median :-0.8010                              
* Mean   :-0.6164                              
* 3rd Qu.:-0.3106                              
* Max.   : 0.5649                              

###Average.timeBodyGyroscopeJerk.StandardDeviation.X

Class: Numeric

* Min.   :-0.9965                                  
* 1st Qu.:-0.9800                                  
* Median :-0.8396                                  
* Mean   :-0.7036                                  
* 3rd Qu.:-0.4629                                  
* Max.   : 0.1791                                  

###Average.timeBodyGyroscopeJerk.StandardDeviation.Y

Class: Numeric

* Min.   :-0.9971                                  
* 1st Qu.:-0.9832                                  
* Median :-0.8942                                  
* Mean   :-0.7636                                  
* 3rd Qu.:-0.5861                                  
* Max.   : 0.2959                                  

###Average.timeBodyGyroscopeJerk.StandardDeviation.Z

Class: Numeric

* Min.   :-0.9954                                  
* 1st Qu.:-0.9848                                  
* Median :-0.8610                                  
* Mean   :-0.7096                                  
* 3rd Qu.:-0.4741                                  
* Max.   : 0.1932                                  

###Average.timeBodyAccelerometerMagnitude.StandardDeviation

Class: Numeric

* Min.   :-0.9865                                         
* 1st Qu.:-0.9430                                         
* Median :-0.6074                                         
* Mean   :-0.5439                                         
* 3rd Qu.:-0.2090                                         
* Max.   : 0.4284                                         

###Average.timeGravityAccelerometerMagnitude.StandardDeviation

Class: Numeric

* Min.   :-0.9865                                            
* 1st Qu.:-0.9430                                            
* Median :-0.6074                                            
* Mean   :-0.5439                                            
* 3rd Qu.:-0.2090                                            
* Max.   : 0.4284                                            

###Average.timeBodyAccelerometerJerkMagnitude.StandardDeviation

Class: Numeric

* Min.   :-0.9946                                             
* 1st Qu.:-0.9765                                             
* Median :-0.8014                                             
* Mean   :-0.5842                                             
* 3rd Qu.:-0.2173                                             
* Max.   : 0.4506                                             

###Average.timeBodyGyroscopeMagnitude.StandardDeviation

Class: Numeric

* Min.   :-0.9814                                     
* 1st Qu.:-0.9476                                     
* Median :-0.7420                                     
* Mean   :-0.6304                                     
* 3rd Qu.:-0.3602                                     
* Max.   : 0.3000                                     

###Average.timeBodyGyroscopeJerkMagnitude.StandardDeviation

Class: Numeric

* Min.   :-0.9977                                         
* 1st Qu.:-0.9805                                         
* Median :-0.8809                                         
* Mean   :-0.7550                                         
* 3rd Qu.:-0.5767                                         
* Max.   : 0.2502                                         

###Average.frequencyBodyAccelerometer.StandardDeviation.X

Class: Numeric

* Min.   :-0.9966                                       
* 1st Qu.:-0.9820                                       
* Median :-0.7470                                       
* Mean   :-0.5522                                       
* 3rd Qu.:-0.1966                                       
* Max.   : 0.6585                                       

###Average.frequencyBodyAccelerometer.StandardDeviation.Y

Class: Numeric

* Min.   :-0.99068                                      
* 1st Qu.:-0.94042                                      
* Median :-0.51338                                      
* Mean   :-0.48148                                      
* 3rd Qu.:-0.07913                                      
* Max.   : 0.56019                                      

###Average.frequencyBodyAccelerometer.StandardDeviation.Z

Class: Numeric

* Min.   :-0.9872                                       
* 1st Qu.:-0.9459                                       
* Median :-0.6441                                       
* Mean   :-0.5824                                       
* 3rd Qu.:-0.2655                                       
* Max.   : 0.6871                                       

###Average.frequencyBodyAccelerometerJerk.StandardDeviation.X

Class: Numeric

* Min.   :-0.9951                                           
* 1st Qu.:-0.9847                                           
* Median :-0.8254                                           
* Mean   :-0.6121                                           
* 3rd Qu.:-0.2475                                           
* Max.   : 0.4768                                           

###Average.frequencyBodyAccelerometerJerk.StandardDeviation.Y

Class: Numeric

* Min.   :-0.9905                                           
* 1st Qu.:-0.9737                                           
* Median :-0.7852                                           
* Mean   :-0.5707                                           
* 3rd Qu.:-0.1685                                           
* Max.   : 0.3498                                           

###Average.frequencyBodyAccelerometerJerk.StandardDeviation.Z

Class: Numeric

* Min.   :-0.993108                                         
* 1st Qu.:-0.983747                                         
* Median :-0.895121                                         
* Mean   :-0.756489                                         
* 3rd Qu.:-0.543787                                         
* Max.   :-0.006236                                         

###Average.frequencyBodyGyroscope.StandardDeviation.X

Class: Numeric

* Min.   :-0.9947                                   
* 1st Qu.:-0.9750                                   
* Median :-0.8086                                   
* Mean   :-0.7110                                   
* 3rd Qu.:-0.4813                                   
* Max.   : 0.1966                                   

###Average.frequencyBodyGyroscope.StandardDeviation.Y

Class: Numeric

* Min.   :-0.9944                                   
* 1st Qu.:-0.9602                                   
* Median :-0.7964                                   
* Mean   :-0.6454                                   
* 3rd Qu.:-0.4154                                   
* Max.   : 0.6462                                   

###Average.frequencyBodyGyroscope.StandardDeviation.Z

Class: Numeric

* Min.   :-0.9867                                   
* 1st Qu.:-0.9643                                   
* Median :-0.8224                                   
* Mean   :-0.6577                                   
* 3rd Qu.:-0.3916                                   
* Max.   : 0.5225                                   

###Average.frequencyBodyAccelerometerMagnitude.StandardDeviation

Class: Numeric

* Min.   :-0.9876                                              
* 1st Qu.:-0.9452                                              
* Median :-0.6513                                              
* Mean   :-0.6210                                              
* 3rd Qu.:-0.3654                                              
* Max.   : 0.1787                                              

###Average.frequencyBodyAccelerometerJerkMagnitude.StandardDeviation

Class: Numeric

* Min.   :-0.9944                                                  
* 1st Qu.:-0.9752                                                  
* Median :-0.8126                                                  
* Mean   :-0.5992                                                  
* 3rd Qu.:-0.2668                                                  
* Max.   : 0.3163                                                  

###Average.frequencyBodyGyroscopeMagnitude.StandardDeviation

Class: Numeric

* Min.   :-0.9815                                          
* 1st Qu.:-0.9488                                          
* Median :-0.7727                                          
* Mean   :-0.6723                                          
* 3rd Qu.:-0.4277                                          
* Max.   : 0.2367                                          

###Average.frequencyBodyGyroscopeJerkMagnitude.StandardDeviation

Class: Numeric

* Min.   :-0.9976                                              
* 1st Qu.:-0.9802                                              
* Median :-0.8941                                              
* Mean   :-0.7715                                              
* 3rd Qu.:-0.6081                                              
* Max.   : 0.2878                                              

##Sources
* [Human Activity Recognition Using Smartphones Data Set page (UCI)](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
