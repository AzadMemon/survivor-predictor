## README

This is a solution for the [Titanic Kaggle Challenge](https://www.kaggle.com/c/titanic#description).

The tutorial I followed to go about the feature engineering and imputation was largely learned from [this kaggle tutorial](https://www.kaggle.io/svf/924638/c05c7b2409e224c760cdfb527a8dcfc4/__results__.html#introduction).

# Disclaimer
I began this project as an attempt to apply some of the knowledge that I gained from taking the Coursera Machine Learning course offered by Andrew Ng. I initially implemented the solution using logistic regression. Instead of doing any feature engineering, I simply threw out columns that I couldn't convert to binary representations, such as names, and replaced missing data with a number unused in the data such as -1 for age.

After submitting and getting a score of 0.45/1, I decided to do the tutorial that accompanied this challenge in an attempt to learn some feature engineering methods (and increase my score).

I'm also relatively new to R so if you have any feedback, feel free to make an issue!

# Setup
You can either setup in Rstudio, or write the scrip in any editor and run in the terminal using the command `Rscript <file>`

# Steps
1. Read in the training data set
```
trainData <- read.csv("train.csv")
```

2. Try and get an idea of the data you're dealing with
```
str(trainData)
```
```
'data.frame':	891 obs. of  12 variables:
 $ PassengerId: int  1 2 3 4 5 6 7 8 9 10 ...
 $ Survived   : int  0 1 1 1 0 0 0 0 1 1 ...
 $ Pclass     : int  3 1 3 1 3 3 1 3 3 2 ...
 $ Name       : Factor w/ 891 levels "Abbing, Mr. Anthony",..: 109 191 358 277 16 559 520 629 417 581 ...
 $ Sex        : Factor w/ 2 levels "female","male": 2 1 1 1 2 2 2 2 1 1 ...
 $ Age        : num  22 38 26 35 35 NA 54 2 27 14 ...
 $ SibSp      : int  1 1 0 1 0 0 0 3 0 1 ...
 $ Parch      : int  0 0 0 0 0 0 0 1 2 0 ...
 $ Ticket     : Factor w/ 681 levels "110152","110413",..: 524 597 670 50 473 276 86 396 345 133 ...
 $ Fare       : num  7.25 71.28 7.92 53.1 8.05 ...
 $ Cabin      : Factor w/ 148 levels "","A10","A14",..: 1 83 1 57 1 1 131 1 1 1 ...
 $ Embarked   : Factor w/ 4 levels "","C","Q","S": 4 2 4 4 4 3 4 4 4 2 ...
```

The output shows the label for the column, the type that R has inferred for that column, followed by a sample of the data in the column.

Two things should pop out at this point:
  1. `data.frame`
  2. `Factor`

The first is a fundamental data structure in R. I as a beginner knew of data structures such as `matrix` and `vector`, but `data.frame` was new.
`data.frame` is described as sort of a matrix like structure. In this case, the columns represent a training example, and the rows represent a feature.

`Factor` are akin to enumerated types in other languages. They take on a limited number of different values.

3. Feature Engineering
..1. One of the first things we can tackle, relatively easily, is names. We have well formatted names with titles. We can easily get the last name (thereby identifying families), as well as titles. This way we can attempt to see relations between survival and size of family, or title.
