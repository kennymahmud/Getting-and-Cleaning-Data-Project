# Setting up the working directory 
setwd("C:\\Users\\Mahmud\\Documents\\CBU Folders\\October\\Coursera\\UCI HAR Dataset")

# calling the required packages
library(plyr)
library(data.table)

# Loading the data from my working directory 
Test <- read.table("test\\subject_test.txt", header = F)

xTest = read.table("test\\X_test.txt", header = F)

yTest = read.table("test\\y_test.txt", header = F)


Train = read.table("train\\subject_train.txt", header = F)

xTrain = read.table("train\\X_train.txt", header = F)

yTrain = read.table("train\\y_train.txt", header = F)


# Combining the data's into single one 
Data_Set <- rbind(Test,Train)


xData_Set <- rbind(xTest,xTrain)

yData_Set <- rbind(yTest,yTrain)

# Checking the dimension of the combined datasets
dim(Data_Set)

dim(xData_Set)

dim(yData_Set)

# Renaming the columns names
xData_Set_mean_std <- xData_Set[, grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2])]
names(xData_Set_mean_std) <- read.table("features.txt")[grep("-(mean|std)\\(\\)",
                                                            read.table("features.txt")[, 2]), 2] 
# to view my data 
View(xData_Set_mean_std)

yData_Set[, 1] <- read.table("activity_labels.txt")[yData_Set[, 1], 2]

names(yData_Set) <- "Activity"

names(Data_Set) <- "Subject"

summary(Data_Set)

# Combining all data set into one single file
All_Data_Set <- cbind(xData_Set_mean_std, yData_Set, Data_Set)
View(All_Data_Set)

# Giving all variables a descriptive names
names(All_Data_Set) <- make.names(names(All_Data_Set))
names(All_Data_Set) <- gsub('Acc',"Acceleration",names(All_Data_Set))
names(All_Data_Set) <- gsub('GyroJerk',"AngularAcceleration",names(All_Data_Set))
names(All_Data_Set) <- gsub('Gyro',"AngularSpeed",names(All_Data_Set))
names(All_Data_Set) <- gsub('Mag',"Magnitude",names(All_Data_Set))
names(All_Data_Set) <- gsub('^t',"TimeDomain.",names(All_Data_Set))
names(All_Data_Set) <- gsub('^f',"FrequencyDomain.",names(All_Data_Set))
names(All_Data_Set) <- gsub('\\.mean',".Mean",names(All_Data_Set))
names(All_Data_Set) <- gsub('\\.std',".StandardDeviation",names(All_Data_Set))
names(All_Data_Set) <- gsub('Freq\\.',"Frequency.",names(All_Data_Set))
names(All_Data_Set) <- gsub('Freq$',"Frequency",names(All_Data_Set))

View(All_Data_Set)

names(All_Data_Set)

# Creating the second data set using aggregate function
Second_data <- aggregate(. ~Subject + Activity, All_Data_Set, mean)
Second_data <- Second_data[order(Second_data$Subject,Second_data$Activity),]

# Saving my newly created data set into my working directory.
write.table(Second_data, file = "tidydata.txt",row.name=FALSE)
