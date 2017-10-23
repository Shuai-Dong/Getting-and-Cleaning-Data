##download and unzip files to local
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, "dataset.zip")
unzip("dataset.zip")

#read files
features<- read.table("UCI HAR Dataset/features.txt", header = FALSE)
x_train<- read.table("UCI HAR Dataset/train/x_train.txt", header = FALSE)
subject_train<- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
x_test<- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
subject_test<- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
y_train<- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
y_test<- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)

#rename subject dataset
names(x_train)<-features[,2]
names(subject_train)<-"subject"
names(x_test)<-features[,2]
names(subject_test)<-"subject"

#rename train dataset
names(y_train)<-"activity"
train_activity<-as.vector(y_train[,1])
names(y_test)<-"activity"
test_activity<-as.vector(y_test[,1])

#adding descriptive activity names to name the activities in the data set
library(plyr)
train_activity<-mapvalues(train_activity, from = c("1", "2","3","4","5","6"), to = c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING"))
train<-data.frame(subject_train,activity=train_activity,x_train)
test_activity<-mapvalues(test_activity, from = c("1", "2","3","4","5","6"), to = c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING"))
test<-data.frame(subject_test,activity=test_activity,x_test)

#combine both train and test dataset
allData<-rbind(train, test)

#identify the activitity measurements that have mean or standard deviation
toMatch<-c("mean","std")

#subset only the measurements on the mean and standard deviation for each measurement. 
allData_sub<-allData[grep(paste(toMatch,collapse = "|"),features[,2])]

#
allData$activity <- as.factor(allData$activity)
allData$subject <- as.factor(allData$subject)    
measurements<-names(allData[3:79])
allDatamelt<-melt(allData, id=c("subject","activity"))
allDatameltmean<-dcast(allDatamelt,subject + activity~variable,mean)
                           
write.table(allDatameltmean,"allData_sub_mean.txt",row.names=TRUE,quote=FALSE)
