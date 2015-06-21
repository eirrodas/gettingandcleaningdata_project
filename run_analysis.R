# Loading libraries
library(reshape2)
library(dplyr)
library(plyr)

setwd('./Documents/')

# Reading neccessary files
Y.test<-read.csv("./test/y_test.txt",colClasses="numeric",sep="",header=FALSE)
X.test<-read.csv("./test/X_test.txt",colClasses="numeric",sep="",header=FALSE)
Y.train<-read.csv("./train/y_train.txt",colClasses="numeric",sep="",header=FALSE)
X.train<-read.csv("./train/X_train.txt",colClasses="numeric",sep="",header=FALSE)
Activity.labels<-read.csv("./activity_labels.txt",colClasses="character",sep="",header=FALSE)
features<-read.csv("./features.txt",header=FALSE,colClasses="character",sep="")
Subjects.test<-read.csv("./test/subject_test.txt",header=FALSE,colClasses="numeric",sep="")
Subjects.train<-read.csv("./train/subject_train.txt",header=FALSE,colClasses="numeric",sep="")

# Merging Datasets
Subjects<-rbind(Subjects.train,Subjects.test)
X<-rbind(X.train, X.test)
Activity<-rbind(Y.train, Y.test)
Data<-cbind(Subjects,X,Activity)

# Created vector of features called "name"
names<-c("Subject",features[,2], "Activity")
# Change dataframe names
colnames(Data)<-names
# Create vector of activities
Activity.levels<-Activity.labels[,2]
Activity.levels<-gsub("_"," ",Activity.levels)
# Change Activity column to factor
# Add levels to Activity column
Data$Activity<-as.factor(Data$Activity)
levels(Data$Activity)<-Activity.levels
# Pattern matching Data(names) to subset Data columns containing characters "-mean()" and "-std()"
means<-cbind(Subjects,Activity,Data[,grepl("-mean()",names(Data),fixed=TRUE)])
std<-Data[,grepl("-std()",names(Data),fixed=TRUE)]
names(means)[1:2]=c("Subject","Activity")
cData<-cbind(means,std)
# Summarising method
groupData<-group_by(cData,Subject,Activity)
summary<-summarise_each(groupData,funs(mean))
summary$Activity<-as.factor(summary$Activity)
levels(summary$Activity)<-Activity.levels

#Creating table
write.table(summary,file="./summary.txt",row.names=FALSE)
