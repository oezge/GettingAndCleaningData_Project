  
  ## This is an R script written to accomplish the course project for
  ## the course Getting and Cleaning Data which is about creating a tidy
  ## data set from the data given in
  ## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

  ## The first part includes merging the training and the test sets
  ## to get one dataset.
 
    ## I start with reading the data form the files : the first one is
    ## training data. I read the  training data, labels and subjects
    ## into three different data frames and combine them with cbind function
    ## In the end, I get a dataframe containing all the information in the
    ## given folders.

      ## Train dataset
    dataset_train <- read.table("UCI HAR Dataset/train/X_train.txt")
    train_act_lab <- read.table("UCI HAR Dataset/train/y_train.txt")
    train_sbj_lab <- read.table("UCI HAR Dataset/train/subject_train.txt")
    
    data_train <- cbind(dataset_train,train_act_lab,train_sbj_lab)
      ## Test dataset
    dataset_test <- read.table("UCI HAR Dataset/test/X_test.txt")
    test_act_lab <- read.table("UCI HAR Dataset/test/y_test.txt")
    test_sbj_lab <- read.table("UCI HAR Dataset/test/subject_test.txt")
    
    data_test <- cbind(dataset_test,test_act_lab,test_sbj_lab)
  
  ### The first request is to merge the train and test datasets.
  ### I do this with rbind and name it dataset
    dataset <- rbind(data_train,data_test)
    
  ### One problem here is that the names of the columns : they are not well 
  ### identified. They are just some numbers so far. This can be corrected/
  ### (or the column names can be overwritten) by the names in feature.txt
  ### file :
    column_names <- read.table("UCI HAR Dataset/features.txt")
    ## If one checks, columns names is a dataframe of two columns
    ## such that the second column is the one we need
    names(dataset) <- column_names$V2  
    ## However, I am not complete because the names for the last two columns 
    ## that I added at the very beginning are not contained in feature.txt
    ## file. I add the names of these columns by hand as follows :
    colnames(dataset)[562] <- "ActivityLabel"
    colnames(dataset)[563] <- "Subject"
  
  ### For the second request, I am supposed to extract the columns containing 
  ### std (standard deviation) and meann of correct  measurements which is the
  ### first 80 columns of data. Then picking the columns including mean and std
  ### can be done by select function from
  ### dplyr package. However, the way that columns are named results in an
  ### error for select (x, contains("mean")). One needs to play with the
  ### columns names a bit and make them suitable to r-listing rules.
  
    dataset_real <- dataset[,c(1:80,562,563)]
    # now, i need to play with the column names
    names(dataset_real) <- gsub("-",".",names(dataset_real))
    names(dataset_real) <- gsub("\\(","",names(dataset_real))
    names(dataset_real) <- gsub("\\)","",names(dataset_real))
    # Loading the required libary
    library(dplyr)
    # The mean
    dataset_real_mean <- select(dataset_real,contains("mean", 
                                                      ignore.case = TRUE))
    # The std
    dataset_real_std <- select(dataset_real,contains("std", 
                                                      ignore.case = TRUE))
  
  ### The third request asks to use descriptive activity names to rename the
  ### activies in data set. In my dataset, this corresponds to the column
  ### called ActivityLabel 
    activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt",
                                  stringsAsFactors = FALSE)
    for (i in 1:10299){
      index <- dataset_real$ActivityLabel[i]
      label <- activity_labels[index,2]
      dataset_real$ActivityLabel[i] <- label
    }
     
    ### The fourth request asks to appropriately label the dataset - application
    ###  of what i did in request 2 to whole data set
    names(dataset_real) <- gsub(",","0",names(dataset_real))
    names(dataset_real) <- gsub("tBody","timeBody",names(dataset_real))
    names(dataset_real) <- gsub("fBody","frequencyBody",names(dataset_real))
    
    ### The fifth request asks to create an independent dataset with
    ### the average of each variable for each activity and each subject.
      by_sbid_actlev <- group_by(dataset_real, Subject,ActivityLabel)
      final_data <- summarise_each(by_sbid_actlev, funs(mean))
      write.table(final_data, file = "finalData",row.name = FALSE)
    