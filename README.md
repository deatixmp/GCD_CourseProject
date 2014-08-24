==================================================================
Human Activity Recognition Using Smartphones Dataset
Coursera Data Science Specialization - Getting and Cleanining Data
Course Project
==================================================================
By:David Faria. 
August 24th, 2014
==================================================================

The repository includes the following files:
=========================================

- 'README.md'

- 'Codebook.md': Explains the composition of the tidy data set (dataset_avgfeatures.csv) that results of running the R script.

- 'dataset_avgfeatures.csv': The resulting dataset in csv format.

- 'main.R': The R script that process data in order to create the tidy data set.

The process is explained here:
======================================

The whole process of extraction, load, cleaning and processing of data has been done in the 'main.R' script.

1.System preparation:
	-The workspace is cleared, and then the variables that define the main working directories are set
	-If the data file is not in the project folder, then it is downloaded and unzipped into the same folder.

2.Reading the data:
	-Data is read with read.csv, specifying that data is separated with  the separator is ‘white space’, that is one or more spaces, tabs, newlines or carriage returns.
	-Main files including metadata are read first. This includes the "features.txt" and the "activity_labels.txt" files.
	-Train and Test data are read separatedly one by one. The data concerning the activity labels and subjects for each observation are also loaded into R.

3.Cleaning and preparing data sets:
	-Subjects and activity labels data frames are appended to their corresponding train and test data frames.The result of this operation creates two new data frames (to avoid replacing original data)
	-Both data frames are then appended (merged) with rbin. Creating one data frame that contains test and train data.
	-The "features.txt" data is used to label variables of the merged dataset. This is done to all columns except for the 'subject.id' and the 'activity.labels', which were manually labeled.
	-To name the activities with descriptive names, the "activity_labels.txt" data is merged by the 'activity.id' column. This is the equivalent to a SQL inner join.

4.Tidy Dataset = Keeping average and mean columns only over the result of step 3.
	-This is done by identifying columns indexes corresponding to mean and standard deviation measurements to be kept for tidy data set

5.Creating the 2nd tidy data set, with the average of each variable for each subject and activity.
	-Function "aggregate" is used to apply the 'mean' function to the dataset that result of step 3.
		->This is done specifying the group over which the average is going to be calculated on. It is done by defining a character vector that is then assigned to the "by" parameter of the function.
		->Label.Id and the rest of non numeric columns are ignored to calculate averages over the rest of variables only
	-Then the dataset is written in a .csv file.
