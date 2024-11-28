# Load necessary libraries
library(dplyr)

# Step 1: Load the data
# Load training and test datasets
train_data <- read.table("train/X_train.txt")
test_data <- read.table("test/X_test.txt")

# Load subject and activity data
train_subjects <- read.table("train/subject_train.txt")
test_subjects <- read.table("test/subject_test.txt")
train_activities <- read.table("train/y_train.txt")
test_activities <- read.table("test/y_test.txt")

# Step 2: Merge the training and test sets
all_data <- bind_rows(train_data, test_data)
all_subjects <- bind_rows(train_subjects, test_subjects)
all_activities <- bind_rows(train_activities, test_activities)

# Step 3: Extract mean and standard deviation columns
features <- read.table("features.txt")
mean_std_features <- grep("-(mean|std)\\(\\)", features$V2)
all_data <- all_data[, mean_std_features]

# Step 4: Replace activity numbers with descriptive names
activity_labels <- read.table("activity_labels.txt")
all_activities$V1 <- factor(all_activities$V1, levels = 1:6, labels = activity_labels$V2)

# Step 5: Combine the data into one data frame
combined_data <- cbind(all_subjects, all_activities, all_data)
names(combined_data)[1:2] <- c("Subject", "Activity")

# Step 6: Label the data with descriptive variable names
names(combined_data)[3:ncol(combined_data)] <- gsub("[-()]", "", features$V2[mean_std_features])

# Step 7: Create a tidy data set with the average of each variable for each activity and each subject
tidy_data <- combined_data %>%
  group_by(Subject, Activity) %>%
  summarise(across(everything(), mean))

# Save the tidy data
write.table(tidy_data, "tidy_data.txt", row.names = FALSE)
