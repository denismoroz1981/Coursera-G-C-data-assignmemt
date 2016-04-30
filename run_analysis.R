## download 
filename<-"getdata_dataset.zip"
if(!file.exists(filename)) {
  fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl,filename)
}
unzip(filename)

##selection
activity_labels<-read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features<-read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])
features_selected<-grep(".*mean.*|.*std.*",features[,2])
features_selected.names<-features[features_selected,2]

##load
X_train<-read.table("UCI HAR Dataset/train/X_train.txt")[features_selected]
y_train<-read.table("UCI HAR Dataset/train/y_train.txt")
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt")
X_test<-read.table("UCI HAR Dataset/test/X_test.txt")[features_selected]
y_test<-read.table("UCI HAR Dataset/train/y_test.txt")
subject_test<-read.table("UCI HAR Dataset/train/subject_test.txt")

##binding
train<-cbind(subject_train,y_train,X_train)
test<-cbind(subject_test,y_test,X_test)
database<-rbind(train,test)
colnames(database)<-c("subject","activity",features_selected.names)

##naming 
database$activity <- factor(database$activity, levels = activity_labels[,1], labels = activity_labels[,2])
database$subject<-as.factor(database$subject)

##melting and mean
library(reshape2)
database.melted<-melt(database,id=c("subject","activity"))
database.mean<-dcast(database.melted,subject + activity ~ variable,mean)

write.table(database.mean,"tidy.txt",row.names = FALSE,quote = FALSE)