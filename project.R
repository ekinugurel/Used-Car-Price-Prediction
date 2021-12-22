```{r}
# Read data --------------------------------------------------------------------
setwd("C:/Users/ekino/OneDrive/Desktop/Autumn_2021/IND E 427/Course Project")
data <- read.csv(file = "scaledcardata.csv", header = TRUE)
str(data)
```

```{r}
# Data Preprocessing --------------------------------------------------------------------
data <- subset(data, select=-c(X))
X <- data[,1:12]
Y <- (data[,13])
Y <- as.factor(Y) 

data <- data.frame(X,Y)
names(data)[13] <- c("price")
data
```

```{r}
# Split into Training and Testing Data ---------------------------------------------------
smp_size = floor(0.5*nrow(data))
set.seed(124)

picked = sample(seq_len(nrow(data)),size=smp_size)
data.train <- data[picked,]
data.test <- data[-picked,]

trainX <- as.matrix(data.train[,1:12])
testX <- as.matrix(data.test[,1:12])
trainY <- as.matrix(data.train[,13])
testY <- as.matrix(data.test[,13])
```

```{r}
# LASSO Curve
require(glmnet)
fit = glmnet(trainX, trainY, family=c("gaussian"))

print(fit$beta)

plot(fit,label = TRUE)
```

```{r}
# CV-Fit Curve
cv.fit = cv.glmnet(trainX,trainY)

plot(cv.fit)
```

```{r}
# find the lambda value that results in the model with smallest MSE
cv.fit$lambda.min
```

```{r}
# Extract the fitted regression parameters of the linear regression model using this lambda value
coef(cv.fit, s = "lambda.min") 
```

```{r}
# predict using the best model selected by LASSO
y_hat <- predict(cv.fit, newx = testX, s = "lambda.min")

# use correlation to measure how close predictions are to the true outcome values of the data points
cor(y_hat, data.test$price)
```

```{r}
# same concept, but with MSE
mse <- mean((y_hat - data.test$price)^2)
mse
```
```{r}
# Now, we see which variables will be chosen as significant by LASSO
var_idx <- which(coef(cv.fit, s = "lambda.min") != 0)
var_idx
# Surprise! It's all of them. This means we did good job during preprocessing
# All of the remaining features are important
```
```{r}
library(randomForest)
rf.car <- randomForest( price ~ ., data = data.train, ntree = 100, nodesize = 20, mtry = 5)
rf.car
y_hat <- predict(rf.car, data.test,type="response")
```
```{r}
lm.data <- lm(price ~ ., data = data.train)
summary(lm.data)
lm.data.reduced <- step(lm.data, direction="backward", test="F")
anova(lm.data.reduced,lm.data)
```
```{r}
pred.lm <- predict(lm.data.reduced, data.test)
cor(pred.lm, data.test$price)
```

```{r}
n_folds = 10
N <- dim(data.train)[1]
folds_i <- sample(rep(1:n_folds, length.out = N))

# Linear Kernel
cv_err <- NULL
for (k in 1:n_folds) {
  test_i <- which(folds_i == k)
  data.train.cv <- data.train[-test_i, ]
  data.test.cv <- data.train[test_i, ]
  require( 'kernlab' )
  linear.svm <- ksvm(price ~ ., data=data.train.cv, type='C-svc', kernel='vanilladot', C=10)
  y_hat <- predict(linear.svm, data.test.cv)
  true_y <- data.test.cv$price
  cv_err[k] <-length(which(y_hat != true_y))/length(y_hat)
}
mean(cv_err)

# Radial Basis Kernel Gaussian
cv_err <- NULL
for (k in 1:n_folds) {
  test_i <- which(folds_i == k)
  data.train.cv <- data.train[-test_i, ]
  data.test.cv <- data.train[test_i, ]
  require( 'kernlab' )
  linear.svm <- ksvm(price ~ ., data=data.train.cv, type='C-svc', kernel='rbfdot', C=10)
  y_hat <- predict(linear.svm, data.test.cv)
  true_y <- data.test.cv$price
  cv_err[k] <-length(which(y_hat != true_y))/length(y_hat)
}
mean(cv_err)

# Polynomial Kernel
cv_err <- NULL
for (k in 1:n_folds) {
  test_i <- which(folds_i == k)
  data.train.cv <- data.train[-test_i, ]
  data.test.cv <- data.train[test_i, ]
  require( 'kernlab' )
  linear.svm <- ksvm(price ~ ., data=data.train.cv, type='C-svc', kernel='polydot', C=10)
  y_hat <- predict(linear.svm, data.test.cv)
  true_y <- data.test.cv$price
  cv_err[k] <-length(which(y_hat != true_y))/length(y_hat)
}

# Hyperbolic tangent kernel
mean(cv_err)
cv_err <- NULL
for (k in 1:n_folds) {
  test_i <- which(folds_i == k)
  data.train.cv <- data.train[-test_i, ]
  data.test.cv <- data.train[test_i, ]
  require( 'kernlab' )
  linear.svm <- ksvm(price ~ ., data=data.train.cv, type='C-svc', kernel='tanhdot', C=10)
  y_hat <- predict(linear.svm, data.test.cv)
  true_y <- data.test.cv$price
  cv_err[k] <-length(which(y_hat != true_y))/length(y_hat)
}
mean(cv_err)

```