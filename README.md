# GCDproject  for Coursera Project - Getting and Cleaning Data
Submitted by: gopalkriz date 18July2015
===================
https://class.coursera.org/getdata-030/human_grading/view/courses/975114/assessments/3/submissions

Project Description:

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected. 

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
Here are the data for the project:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following. 
 Merges the training and the test sets to create one data set.
 Extracts only the measurements on the mean and standard deviation for each measurement. 
 Uses descriptive activity names to name the activities in the data set
 Appropriately labels the data set with descriptive variable names. 

 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Good luck!
===================
Q1. Please upload the tidy data set created in step 5 of the instructions. Please upload your data set as a txt file created with write.table() using row.name=FALSE (do not cut and paste a dataset directly into the text box, as this may cause errors saving your submission).
===================
Q2. Please submit a link to a Github repo with the code for performing your analysis. The code should have a file run_analysis.R in the main directory that can be run as long as the Samsung data is in your working directory. The output should be the tidy data set you submitted for part 1. You should include a README.md in the repo describing how the script works and the code book describing the variables.
===================
Assignment Submission:
View the files
1. readme.md		(project description and script working)
2. codebook.rmd		(describing the variables)
3. run_analysis.r	(the code)
4. tidydata.txt		(output / result)

===================**********===================

ReadMe: Describing code-script working | view codebook for description of variables
Note: each stage is high-level; each would contain many operational steps /codelines /functions


##Stage1
Study the above project description thoroughly.
Download the dataset from the URL; unZip the files.
```
if(!file.exists("./UCI_HAR_dataset")){dir.create("./UCI_HAR_dataset")}
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile= "./UCI_HAR_dataset/download.zip")# not used method="curl"
unzip(zipfile="./UCI_HAR_dataset/UCI_HAR_dataset.zip",exdir="./UCI_HAR_dataset")
DataPath <- file.path("." , "UCI_HAR_dataset")
FileList<-list.files(DataPath, recursive=TRUE)
FileList
```

##Stage2
Study the dataset thoroughly. There is more data than needed.
We should Read only required data (test and train).Ignore the Inertial Signals.
```
# Activity, Subject and Features for data in data frame
dataActivityTest  <- read.table(file.path(DataPath, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(DataPath, "train", "Y_train.txt"),header = FALSE)
dataSubjectTrain <- read.table(file.path(DataPath, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(DataPath, "test" , "subject_test.txt"),header = FALSE)
dataFeaturesTest  <- read.table(file.path(DataPath, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(DataPath, "train", "X_train.txt"),header = FALSE)
#str(dataframename) to view all the six tables
```

##Stage3
Combining the varios datasets into a single dataset must be done carefully.
Note: the variable names for each data set are in seperate files, and need to be input as lists
Merge the Test and Training sets following the order as per three step.
```
#step1 merge rows first
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

#step2 give header names to the variables
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(DataPath, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

step3 merge columns last
datafullset <- cbind(dataSubject, dataActivity, dataFeatures)
```

##Stage4
The combined dataset contain many columns which are not needed for our analysis
Extract only the measurement for mean and standard deviation; purge rest of the unwanted columns
#compare and match names of column, make a subset as per match
```
newdataNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
selectedNames <- c(as.character(newdataNames), "subject", "activity" )
datasubset <- subset(datafullset,select=selectedNames)
str(datasubset)
```

##Stage5
The dataset is ready but is not tidy;

# The subject column remains unaltered as each numeral is the personID.

# change the activity fields to charater by the name; then convert to factor variable
```
datasubset$activity <- as.character(datasubset$activity)
datasubset$activity[datasubset$activity == 1] <- "Walking"
datasubset$activity[datasubset$activity == 2] <- "Walking Upstairs"
datasubset$activity[datasubset$activity == 3] <- "Walking Downstairs"
datasubset$activity[datasubset$activity == 4] <- "Sitting"
datasubset$activity[datasubset$activity == 5] <- "Standing"
datasubset$activity[datasubset$activity == 6] <- "Laying"
datasubset$activity <- as.factor(datasubset$activity)
head(datasubset$activity,30)
```
# Edit the Header Names to better convey the variable they represent (short codes are replaced)
```
names(datasubset)<-gsub("^t", "time", names(datasubset))
names(datasubset)<-gsub("^f", "frequency", names(datasubset))
names(datasubset)<-gsub("Acc", "Accelerometer", names(datasubset))
names(datasubset)<-gsub("Gyro", "Gyroscope", names(datasubset))
names(datasubset)<-gsub("Mag", "Magnitude", names(datasubset))
names(datasubset)<-gsub("BodyBody", "Body", names(datasubset))
names(datasubset)#check
```

##Stage6
Create second independent tidy dataset,with average of each variable for each activity and each subject.
```
dataMaster<-aggregate(. ~subject + activity, datasubset, mean)
dataMaster<-dataMaster[order(dataMaster$subject,dataMaster$activity),]
```

##Stage7
The datafields now hold the Mean-Values of the original Dataset,the Header names amend to represent this change.
```
#ignore first two columns to append MeanSA to all headers
colNamesubset <- colnames(dataMaster)
colNamesubset[3:68] <- paste(colnames(dataMaster[3:68]), "meanSA", sep= " ")
names(dataMaster)<- colNamesubset
```

##Stage8
This is the final tidy (second) dataset. Output it to external txt file as per instructions
Also make the Codebook using KnitR/ Rmakrkdown

```
write.table(dataMaster, file = "tidydata.txt",row.name=FALSE)
knit2html("codebook.Rmd")
```
###end###


===================
Info about the Datatables / Values / Vectors / Variables as used in the Rcode

fileURL			- stores the website URL of data
destfile		- stores the local folder location for downloading file
DataPath		- stores the local folder location for unzipping the downloaded file
FileList		- list of file names of entire dataset in all main/subfolders

Note: Train >> Training
dataActivityTest	- dataframe of read data from the respective file
dataActivityTrain	- dataframe of read data from the respective file
dataSubjectTrain	- dataframe of read data from the respective file
dataSubjectTest		- dataframe of read data from the respective file
dataFeaturesTest	- dataframe of read data from the respective file
dataFeaturesTrain	- dataframe of read data from the respective file
Note: all the files / full data set is not read; only required Test and Train six files.

dataSubject 		- Training and Test data in merged by Subject
dataActivity 		- Training and Test data in merged by Activity
dataFeatures 		- Training and Test data in merged by Features 
datafullset		- Combined Data of the above three datafile

dataFeaturesNames	- dataset of all the heading names; total 561
newdataNames		- a subjet of the above; extracting only fields with mean or std
selectedNames		- namelist from above file plus "subject" and "activity" fields

datasubset		- subjet of 'datafullset', extracting columns with header matching 'selectedNames'
dataMaster		- a new Dataset, aggregated by meanvalue from 'datasubset' by 'subject' and 'activity'
colNamesubset 		- temporary variable to make modification to the heading names	

datafullset	[representive of first tidydataset]
dataMaster	[representive of second independent tidy dataset, of average of each variable for each activity and each subject]

===================