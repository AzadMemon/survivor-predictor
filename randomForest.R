trainData <- read.csv("train.csv");

# Create title field
# Memon, Mr. Azad
trainData$Title <- gsub('(.*, (.*)\\..*)', '\\2', trainData$Name)
# Mr. Azad Memon
trainData$Title <- gsub('(^(.*)\\..*)', '\\2', trainData$Title)

# Keep relevant titles around
# table(trainData$Title)
# We see that Mr/Mrs/Miss are quite pouplar. Even Master. And the rest are quite rare

rare_titles <- c('Capt', 'Col', 'Don', 'Dr', 'Johkheer', 'Lady', 'Major', 'Mlle', 'Mme', 'Ms', 'Rev', 'Sir', 'the Countess')

trainData$Title[trainData$Title == 'Mlle'] <- 'Miss'
trainData$Title[trainData$Title == 'Ms'] <- 'Miss'
trainData$Title[trainData$Title == 'Mme'] <- 'Miss'
trainData$Title[trainData$Title %in% rare_titles] <- 'Rare'
