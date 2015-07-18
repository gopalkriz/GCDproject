#COursera #Getting and Cleaning Data
#https://class.coursera.org/getdata-030/human_grading
###
#Study Topic: wearable computing
#data collected from accelerometers Samsung Galaxy S smartphone
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
###
library(httr)
library(curl)
library(plyr)
library(tidyr)
library(knitr)
###
#download file
getwd();dir()
if(!file.exists("./UCI_HAR_dataset")){dir.create("./UCI_HAR_dataset")}
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#download.file(fileURL, destfile= "./UCI_HAR_dataset/download.zip")# not used method="curl"
#Unzip the folder and files
#unzip(zipfile="./UCI_HAR_dataset/UCI_HAR_dataset.zip",exdir="./UCI_HAR_dataset")
#
DataPath <- file.path("." , "UCI_HAR_dataset")
FileList<-list.files(DataPath, recursive=TRUE)
FileList
###
# do not input files from Inertial Signals folder or root folder
# Activity, Subject and Features for data in data frame
dataActivityTest  <- read.table(file.path(DataPath, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(DataPath, "train", "Y_train.txt"),header = FALSE)
dataSubjectTrain <- read.table(file.path(DataPath, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(DataPath, "test" , "subject_test.txt"),header = FALSE)
dataFeaturesTest  <- read.table(file.path(DataPath, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(DataPath, "train", "X_train.txt"),header = FALSE)
#str(dataframename) to view all the six tables
###
#Merge the Test and Training sets
#step1 merge rows first
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)
#step2 give header names to the variables
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(DataPath, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2
#step3 merge columns last
##delete##dataCombine <- cbind(dataSubject, dataActivity)
##delete##Data <- cbind(dataFeatures, dataCombine)
datafullset <- cbind(dataSubject, dataActivity, dataFeatures)
###
#compare and match names of column, make a subset as per match
newdataNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
selectedNames <- c(as.character(newdataNames), "subject", "activity" )
datasubset <- subset(datafullset,select=selectedNames)
str(datasubset)
###
# change the activity fields to charater by the name
datasubset$activity <- as.character(datasubset$activity)
datasubset$activity[datasubset$activity == 1] <- "Walking"
datasubset$activity[datasubset$activity == 2] <- "Walking Upstairs"
datasubset$activity[datasubset$activity == 3] <- "Walking Downstairs"
datasubset$activity[datasubset$activity == 4] <- "Sitting"
datasubset$activity[datasubset$activity == 5] <- "Standing"
datasubset$activity[datasubset$activity == 6] <- "Laying"
datasubset$activity <- as.factor(datasubset$activity)
head(datasubset$activity,30)# Result should show 6Levels (ie factor variable)
###
#more Header Name cleaning
names(datasubset)<-gsub("^t", "time", names(datasubset))
names(datasubset)<-gsub("^f", "frequency", names(datasubset))
names(datasubset)<-gsub("Acc", "Accelerometer", names(datasubset))
names(datasubset)<-gsub("Gyro", "Gyroscope", names(datasubset))
names(datasubset)<-gsub("Mag", "Magnitude", names(datasubset))
names(datasubset)<-gsub("BodyBody", "Body", names(datasubset))
names(datasubset)#check
###
#
dataMaster<-aggregate(. ~subject + activity, datasubset, mean)
dataMaster<-dataMaster[order(dataMaster$subject,dataMaster$activity),]
write.table(dataMaster, file = "tidydata.txt",row.name=FALSE)
###
#Codebook
knit2html("codebook.Rmd")
###end###