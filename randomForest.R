library('mice') # imputation
library('randomForest') # classification algorithm
library('dplyr') # data manipulation

clean <- function(trainData) {
  # Create title field
  trainData$Title <- gsub('(.*, (.*)\\..*)', '\\2', trainData$Name) # Memon, Mr. Azad - The more common case
  trainData$Title <- gsub('(^(.*)\\..*)', '\\2', trainData$Title) # Mr. Azad Memon
  
  # Keep relevant titles around
  # table(trainData$Title)
  # We see that Mr/Mrs/Miss are quite pouplar. Even Master. And the rest are quite rare
  
  rare_titles <- c('Capt', 'Col', 'Don', 'Dr', 'Johkheer', 'Lady', 'Major', 'Mlle', 'Mme', 'Ms', 'Rev', 'Sir', 'the Countess')
  
  trainData$Title[trainData$Title == 'Mlle'] <- 'Miss'
  trainData$Title[trainData$Title == 'Ms'] <- 'Miss'
  trainData$Title[trainData$Title == 'Mme'] <- 'Miss'
  trainData$Title[trainData$Title == 'Master'] <- 'Mr'
  trainData$Title[trainData$Title %in% rare_titles] <- 'Rare'
  
  # Does family size affect survival?
  trainData$Fsize <- trainData$SibSp + trainData$Parch + 1
  # We can group sizes of each family into large/small/singleton
  trainData$FsizeD[trainData$Fsize == 1] <- "singleton"
  trainData$FsizeD[trainData$Fsize > 1 & trainData$Fsize < 5] <- "small"
  trainData$FsizeD[trainData$Fsize > 4] <- "large"
  
  # Embarked is empty for two passengers. By using what they paid for their fare and their class, we can see where they fall
  # relative to others. In this case, they paid 80 dollars which is the average for 1st class embarking from 'C'
  trainData$Embarked[c(62, 830)] <- 'C'
  
  # Fare is also missing for one passenger. Similar to Embark, we can see what the distribution was for people embarking
  # from the same place for the same class. Then take the most likely pay (i.e the median)
  trainData$Fare[1309] <- median(trainData[testData$Pclass == '3' & trainData$Embarked == 'S',]$Fare, na.rm = TRUE)
  
  # We have plenty of ages missing in this case. We could use the same method we have so far, but predictive imputation is an option
  # Make variables factors into factors
  factor_vars <- c('PassengerId','Pclass','Sex','Embarked','Title','FsizeD')
  trainData[factor_vars] <- lapply(trainData[factor_vars], function(x) as.factor(x))
  set.seed(129)
  mice_mod <- mice(trainData[, !names(trainData) %in% c('PassengerId','Name','Ticket','Cabin','Survived')], method='rf') 
  mice_output <- complete(mice_mod)
  trainData$Age <- mice_output$Age
  trainData
}

trainData <- read.csv("train.csv")
testData <- read.csv("test.csv")

cleanedData <- clean(bind_rows(trainData, testData))
trainData <- cleanedData[1:891,]
testData <- cleanedData[892:1309,]

# ------------------------MODEL---------------------------
set.seed(754)
rf_model <- randomForest(factor(Survived) ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + Title + FsizeD, data = trainData)

plot(rf_model, ylim=c(0,0.36))
legend('topright', colnames(rf_model$err.rate), col=1:3, fill=1:3)


# -----------------------TEST------------------------------------

str(testData)
# Predict using the test set
prediction <- predict(rf_model, testData)
# Save the solution to a dataframe with two columns: PassengerId and Survived (prediction)
solution <- data.frame(PassengerID = testData$PassengerId, Survived = prediction)

# Write the solution to file
write.csv(solution, file = 'rf_mod_Solution.csv', row.names = F)