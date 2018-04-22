#define where the new folder has been unziped then create a file : 28 file names
myfile = file.path("C:/Users/tancr/Desktop/data science/", "UCI HAR Dataset")
files = list.files(myfile, recursive=TRUE)
#show files
files


#### begin to create the data set of training and test ####

#Reading training tables 
x_train = read.table(file.path(myfile, "train", "X_train.txt"),header = FALSE)
y_train = read.table(file.path(myfile, "train", "y_train.txt"),header = FALSE)
subject_train = read.table(file.path(myfile, "train", "subject_train.txt"),header = FALSE)
#Reading the testing tables
x_test = read.table(file.path(myfile, "test", "X_test.txt"),header = FALSE)
y_test = read.table(file.path(myfile, "test", "y_test.txt"),header = FALSE)
subject_test = read.table(file.path(myfile, "test", "subject_test.txt"),header = FALSE)
#Read the features data
features = read.table(file.path(myfile, "features.txt"),header = FALSE)
#Read activity labels data
LabelsActivity = read.table(file.path(myfile, "activity_labels.txt"),header = FALSE)

### Objectif 3 ###

#Create Values to the Train Data then Create Values to the test data
#step 1
colnames(x_train) = features[,2]
colnames(y_train) = "activityId"
colnames(subject_train) = "subjectId"
#step 2
colnames(x_test) = features[,2]
colnames(y_test) = "activityId"
colnames(subject_test) = "subjectId"

#Create sanity check for the activity labels value
colnames(LabelsActivity) <- c('activityId','activityType')

#Merging the train and test data - important outcome of the project
mrg_train = cbind(y_train, subject_train, x_train)
mrg_test = cbind(y_test, subject_test, x_test)
#Create the main data table merging both table tables - this is the outcome of 1
setAll = rbind(mrg_train, mrg_test)

# Need step is to read all the values that are available
colNames = colnames(setAll)
#Need to get a subset of all the mean and standards and the correspondongin activityID and subjectID 
mean_and_std = (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))
#A subtset has to be created to get the required dataset
set_MeanAndStd <- setAll[ , mean_and_std == TRUE]

set_ActivityNames = merge(set_MeanAndStd, LabelsActivity, by='activityId', all.x=TRUE)

# New tidy set has to be created 
secTidy <- aggregate(. ~subjectId + activityId, set_ActivityNames, mean)
secTidy <- secTidy[order(secTidy$subjectId, secTidy$activityId),]

#Save new data
write.table(secTidy, "C:/Users/tancr/Desktop/data science/result.txt", row.name=FALSE)

