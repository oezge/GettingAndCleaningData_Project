
# README

This is the ReadMe file written to explain how the script run_analysis.R works.

The first part includes merging the training and the test sets to get one dataset. I start with reading the data form the files : 

The code reads the  training data, labels and subjects given in the folder train into three different data frames and combine them with cbind function. In the end, I get a data frame containing all the information in the given folders. In the end, the data is stored in a data frame called "data_train".

A similar procedure is followed for the data in test folder.In the end, the data is stored in a data frame called "data_test"

The first request is to merge the train and test datasets. The code  uses rbind to combine two data sets created above, and name it "dataset"

To assign the correct names of the columns, the code reads the features.txt file to a data frame called column_names and then assigns the second column of this data frame to rename the columns of "dataset". However, this is not a complete renaming due to the last added two columns. They are renamed by colnames as "ActivityLabel" and "Subject".


The second request is to extract the columns containing std (standard deviation) and mean of correct  measurements which is the first 80 columns of data. Then picking the columns including mean and std can be done by select function from dplyr package. However, the way that columns are named results in an error for select (x, contains("mean")). This is overcomed by changing the names with gsub function. The required data are called data_set_real_mean and
dataset_real_std.

The code uses dataset_real for the rest of the assignments.

The third request is to use descriptive activity names to rename the activities in data set (which is the column corresponding to ActivityLabel in corresponding data). The code reads first the file activity_labels.txt that contains the names and numbering of activities. Then with the help of a for loop, the rows of column ActivityLabel is changed with the corresponding activity names. The key point here is, the function read.table transforms strings to factors. The code prevents this by 
"stringsAsFactors = FALSE".

The fourth request is to rename appropriately the columns of dataset_real. The code uses gsub for it. It alters the "-" into ".", "()" into "", "tBody" into "timebody" and "fBody" into "frequencyBody".

The fifth request asks to create an independent dataset with the average of each variable for each activity and each subject. The code uses the group_by function  from dplyr package to group the data with respect to subject and activity labels. The final, tidy data is created by summarise_each function which acted on the grouped data and took the means.  The final data has  180 rows with 82 columns. The first column is subject ids and the second one shows the activities. 
The first three columns look like as follows :

|Subject| ActivityLabel |timeBodyAcc.mean.X |  
--------|---------------|--------------------
|   1   |        LAYING |         0.2215982 | 
|   1   |       SITTING |         0.2612376 |  


