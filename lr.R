library(sigmoid)



gradFunction <- function (X, Y) {
  function (theta) {
    h <- sigmoid(initialTheta %*% X)
    1/m * (h - Y) * t(X)
  }
}

costFunction <- function (X, Y) {
  numTrainExamples <- ncol(trainDataX)
  
  function (theta) {
    h <- sigmoid(initialTheta %*% X)
    -1/numTrainExamples * sum(Y*log(h) + (1-Y)*log(1-h)) + lambda/(2*numTrainExamples)*sum(theta %*% t(theta))
  }
}

trainData <- read.csv("train.csv",stringsAsFactors=FALSE)

trainDataX <- t(cbind(1, trainData[,-c(1,2,4,9,11)]))
trainDataY <- t(trainData[,2])

# Need to clean up data
trim(trainDataX)
for (i in c(1:numTrainExamples)) {
  if (trainDataX[8,i] == "C") {
    trainDataX[8,i] <- 1
  } else if (trainDataX[8,i] == "Q") {
    trainDataX[8,i] <- 2
  } else {
    trainDataX[8,i] <- 3
  }
  
  if (trainDataX[3, i] == "male") {
    trainDataX[3, i] <- 1
  } else {
    trainDataX[3, i] <- 2
  }
  
  for (j in c(1:8)) {
    if (is.na(trainDataX[j,i])) {
      trainDataX[j, i] <- -1 
    } else {
      trainDataX[j, i] <- as.numeric(as.character(trainDataX[j, i]))
    }
  }
}

initialTheta<- matrix(0, 1, 10)
numTrainExamples <- ncol(trainDataX)
lambda <- 3

print(trainDataX[,1])

fn <- costFunction(trainDataX, trainDataY)
gr <- gradFunction(trainDataX, trainDataY)

result <- optim(initialTheta, fn, gr, method="L-BFGS-B", control=list(maxit=500,trace=4))

print(result)

