# 1 PassengerId
# 2 Survived
# 3 Pclass
# 4 Name
# 5 Sex
# 6 Age
# 7 SibSp
# 8 Parch
# 9 Ticket
# 10 Fare
# 11 Cabin
# 12 Embarked

library(sigmoid)


gradFunction <- function (lambda, X, Y) {
  numTrainExamples <- ncol(X)
  
  function (theta) {
    h <- sigmoid(theta %*% X)
    thetaWithoutBias <- theta[-1]
    return(1/numTrainExamples * ((h - Y) %*% t(X))) + cbind(0, lambda/numTrainExamples * thetaWithoutBias)
  }
}

costFunction <- function (lambda, X, Y) {
  numTrainExamples <- ncol(X)
  
  function (theta) {
    h <- sigmoid(theta %*% X)
    thetaWithoutBias <- theta[-1]
    -1/numTrainExamples * sum(Y*log(h) + (1-Y)*log(1-h)) + lambda/(2*numTrainExamples)*sum(thetaWithoutBias %*% t(thetaWithoutBias))
  }
}


# Read in training data
trainData <- read.csv("train.csv")

# Convert the dataframe to a matrix 
options(na.action='na.pass')
trainData <- model.matrix(
  ~ Survived + Pclass + Sex + Age + SibSp + Parch + Fare + Embarked, 
  dat = trainData
)
trainData[is.na(trainData)] <- -1

# Set up X & Y
trainDataX <- t(trainData[,-c(1,2)])
trainDataX <- rbind(1, trainDataX)

trainDataY <- t(trainData[,2])

# Set up initialTheta & lambda
initialTheta <- matrix(0, 1, 10)
lambda <- 3

fn <- costFunction(lambda, trainDataX, trainDataY)
gr <- gradFunction(lambda, trainDataX, trainDataY)

result <- optim(initialTheta, fn, gr, method="BFGS", control=list(maxit=500,trace=4))

# Testing
testData <- read.csv("test.csv")

options(na.action='na.pass')
testData <- model.matrix(
  ~ PassengerId + Pclass + Sex + Age + SibSp + Parch + Fare + Embarked,
  dat = testData
)

# keep track of passengerIds
passengerIds <- testData[,2]

# Set NA to -1
testData <- testData[,-2]
testData[is.na(testData)] <- -1

testData <- t(testData)
testData <- rbind(1, testData)

# Calculate predictions
predictions <- round(t(sigmoid(result$par %*% testData)))

# Write to file
output <- cbind(passengerIds, predictions)
colnames(output) <- c("PassengerId", "Survived")
write.csv(output, file="output.csv", row.names = FALSE)


