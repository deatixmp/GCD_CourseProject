# Getting and Cleaning Data Course Project - Coursera

#Clearing workspace...
rm(list=ls())

#Setting course directory, course project folder name and data folder name. 
#This assumes that inside the course directory, there is a folder for the project, and another inside this last for the data

coursefolder<-"C:/<username>../Data Science Specialization Coursera/3_Getting and Cleaning Data" #Define your main working directory here 
projectfolder<-"Course Project" #Define your course project folder name here 
datafolder<-"UCI HAR Dataset" #Define your dataset folder name here (if data already downloaded and unzipped)

setwd(paste(coursefolder,projectfolder,sep="/"))

#Checking if .zip file exists, if not, download and unzip it
if(!file.exists("UCI HAR Dataset.zip"){
            download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","./UCI HAR Dataset.zip")
            dldate <- date()
		unzip("UCI HAR Dataset.zip")
}

#moving to the data folder to load files
setwd(paste(coursefolder,projectfolder,datafolder,sep="/"))

#Reading main files...
activity_labels<-read.csv("activity_labels.txt",sep=" ",header=FALSE,col.names=c("id","Activity.Label"))
features_names<-read.csv("features.txt",sep=" ",header=FALSE,col.names=c("id","Feature.Name"))

#Reading test/train files...
	#Test
subject_test<-read.csv("test/subject_test.txt",sep="",header=FALSE,col.names=c("Subject.Id"))
data_test<-read.csv("test/X_test.txt",sep="",header=FALSE)
labels_test<-read.csv("test/y_test.txt",sep="",header=FALSE,col.names="Label.Id")
	#Train
subject_train<-read.csv("train/subject_train.txt",sep="",header=FALSE,col.names=c("Subject.Id"))
data_train<-read.csv("train/X_train.txt",sep="",header=FALSE)
labels_train<-read.csv("train/y_train.txt",sep="",header=FALSE,col.names="Label.Id")

#Now that all necessary files have been loaded into R, go back to main directory
setwd(paste(coursefolder,projectfolder,sep="/"))

#Cleaning and preparing data sets
#Adding subjects and activity labels to each dataset
	#Test
data_test_2<-cbind(data_test,subject_test)
data_test_2<-cbind(data_test_2,labels_test)
	#Train
data_train_2<-cbind(data_train,subject_train)
data_train_2<-cbind(data_train_2,labels_train)

#Merging test and train data
data<-rbind(data_train_2,data_test_2)

#Labeling variable names
	#Adding the new names to the features vector. Taking only the 'Feature.Name' column
features_names_2<-(rbind(features_names["Feature.Name"],data.frame(Feature.Name=tail(names(data_train_2),2))))
	#Labeling the variables
names(data)<-features_names_2[[1]]
	
#Naming activities with descriptive names
data<-merge(data,activity_labels,by.x="Label.Id",by.y="id",all.x=TRUE,sort=FALSE)

#*****TIDY DATASET 1 MEAN AND STD VARIABLES ONLY******
#Identifying columns indexes corresponding to mean and standard deviation measurements to be kept for tidy data set
toextract_columns_indexes<-c(grep("Subject.Id",names(data)),grep("Activity.Label",names(data)),grep("Label.Id",names(data)),grep("mean",names(data)),grep("std",names(data)))

#Extracting labels and mean and std columns only
tidy_data<-data[toextract_columns_indexes]

#*****TIDY DATASET 2 WITH AVERAGE OF EACH VARIABLE FOR EACH SUBJECT AND ACTIVITY******
#Label.Id and the rest of non numeric columns are ignored to calculate averages over the rest of variables only

tidy_data_2<-aggregate(data[!(names(data) %in% c("Label.Id","Activity.Label","Subject.Id"))],by=data[c("Activity.Label","Subject.Id")],FUN=mean))

#Writing the dataset into a .csv file
con<-file(description="dataset_avgfeatures.txt",open="wt")
write.table(tidy_data_2,file=con,row.names=FALSE)
close(con)

