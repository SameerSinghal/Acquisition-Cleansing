## Procedure loads data from TRAIN and TEST segments
## Extracts data relating to mean and standard deviation for each measurement.
## Loads Descriptive Labels for activities loaded to refer in data set
## Loads Features relating to Mean and STD extracted for scoping the data analysis
## Merges the training and the test sets to create one data set.



setwd("C:/Users/ssinghal/Documents/R Data/UCI HAR Dataset")

getFeatures<-read.table("features.txt")["V2"]


## Reading TRAIN and TEST data sets

setwd("train")
xtrain<-read.table("X_train.txt")
names(xtrain)<-getFeatures$V2
ytrain<-read.table("y_train.txt")
names(ytrain)<-names(ytrain)<-"labels"
subject_train<-read.table("subject_train.txt")
names(subject_train)<-"subjects"
setwd("../test/")
xtest<-read.table("X_test.txt")
names(xtest)<-getFeatures$V2
ytest<-read.table("y_test.txt")
names(ytest)<-"labels"
subject_test<-read.table("subject_test.txt")
names(subject_test)<-"subjects"
setwd("../")

## Reading in features and labels for limiting scope of analysis to MEAN / STD


labels <- read.table("activity_labels.txt")["V2"]
columns_means_std <-grep("mean|std",getFeatures$V2)
means_and_std_colnames<-colnames(xtest)[ columns_means_std]
xtest_collection<-cbind(subject_test,ytest,subset(xtest,select=means_and_std_colnames))
xtrain_collection<-cbind(subject_train,ytrain,subset(xtrain,select=means_and_std_colnames))

## Merge the training and the test sets to create one data set

xymerged <-rbind(xtest_collection, xtrain_collection)

## Create a second, independent tidy data set with the average of each variable for each activity and each subject

tidy<-aggregate(xymerged [,3:ncol(xymerged)],list(Subject= xymerged$subjects, Activity= xymerged $labels), mean)
tidy<-tidy[order(tidy$Subject),]

## Use descriptive activity names to name the activities in the data set

tidy$Activity<-labels[tidy$Activity,]
write.table(tidy, file="./tidydata.txt", sep="\t", row.names=FALSE)
