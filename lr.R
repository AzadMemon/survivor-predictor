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

# Training
trainData <- read.csv("train.csv")
trainData <- model.matrix(
  ~ Survived + Pclass + Sex + Age + SibSp + Parch + Fare + Embarked, 
  dat = trainData
)
trainDataX <- t(trainData[,-c(1,2)])
trainDataX <- rbind(1, trainDataX)
trainDataY <- t(trainData[,2])


gradFunction <- function (lambda, X, Y) {
  numTrainExamples <- ncol(X)
  
  function (theta) {
    h <- sigmoid(theta %*% X)
    return(1/numTrainExamples * ((h - Y) %*% t(X))) #+ cbind(0, lambda/numTrainExamples * thetaWithoutBias)
  }
}

costFunction <- function (lambda, X, Y) {
  numTrainExamples <- ncol(X)
  
  function (theta) {
    h <- sigmoid(theta %*% X)
    -1/numTrainExamples * sum(Y*log(h) + (1-Y)*log(1-h)) #+ lambda/(2*numTrainExamples)*sum(thetaWithoutBias %*% t(thetaWithoutBias))
  }
}

#J = 1/m * [(-1 .* y') * log(sigmoid(X*theta)) - (1 .- y') * log(1 .- sigmoid(X*theta))]
#grad = 1/m .* [X' * (sigmoid(X*theta) - y)]

initialTheta <- matrix(0, 1, 10)
#lambda <- 3

fn <- costFunction(lambda, trainDataX, trainDataY)
gr <- gradFunction(lambda, trainDataX, trainDataY)

result <- optim(initialTheta, fn, gr, method="BFGS", control=list(maxit=500,trace=4))


# Testing
testData <- read.csv("test.csv")
testData <- model.matrix(
  ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked,
  dat = testData
)
testData <- t(testData)
testData <- rbind(1, testData)

predictions <- round(t(sigmoid(result$par %*% testData)))

write.csv(predictions, file="output.csv", row.names = FALSE, col.names = c("Survived"))


