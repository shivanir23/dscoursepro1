library(dplyr)
features <- read.table("./features.txt", col.names = c("n","func"))
activities <- read.table("./activity_labels.txt", col.names = c("num", "activity"))
subject_test <- read.table("./test/subject_test.txt", col.names = "sub")
x_test <- read.table("./test/X_test.txt", col.names = features$func)
y_test <- read.table("./test/y_test.txt", col.names = "num")
subject_train <- read.table("./train/subject_train.txt", col.names = "sub")
x_train <- read.table("./train/X_train.txt", col.names = features$func)
y_train <- read.table("./train/y_train.txt", col.names = "num")

x<-rbind(x_test,x_train)
y<-rbind(y_test,y_train)
subject<-rbind(subject_test,subject_train)
merge<-cbind(subject,x,y)
cleanedata<-merge%>% select(sub,num, contains("mean"), contains("std"))
head(cleanedata)
names(cleanedata)

names(cleanedata)[2]="activity"
names(cleanedata)<-gsub("Acc", "Accelerometer", names(cleanedata))
names(cleanedata)<-gsub("Gyro", "Gyroscope", names(cleanedata))
names(cleanedata)<-gsub("BodyBody", "Body", names(cleanedata))
names(cleanedata)<-gsub("Mag", "Magnitude", names(cleanedata))
names(cleanedata)<-gsub("^t", "Time", names(cleanedata), ignore.case = TRUE)
names(cleanedata)<-gsub("^f", "Frequency", names(cleanedata), ignore.case = TRUE)
names(cleanedata)<-gsub("tBody", "Body_time", names(cleanedata))
names(cleanedata)<-gsub("-mean()", "Mean", names(cleanedata), ignore.case = TRUE)
names(cleanedata)<-gsub("-std()", "Standard_deviation", names(cleanedata), ignore.case = TRUE)
names(cleanedata)<-gsub("-freq()", "Frequency", names(cleanedata), ignore.case = TRUE)
names(cleanedata)<-gsub("angle", "Angle", names(cleanedata))
names(cleanedata)<-gsub("gravity", "Gravity", names(cleanedata))

groupdata <-group_by(cleanedata,sub,activity)
## Get the average of each variable
summarisedata<-summarise_each(groupdata, funs(mean))
## Write the data out
write.table(summarisedata, "Avg_var_by_activity.txt", row.names = FALSE)
str(summarisedata)
summarisedata
