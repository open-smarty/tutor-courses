install.packages("dbplot")

?A2barx
?anorexia
??anorexia

Sys.setenv(JAVA_HOME="C:/Program Files/Java/jdk-17")

library(sparklyr)
library(dplyr)
sc <- spark_connect(master = "local")


### Importing Data

## Using copy_to()

?mtcars

cars<-copy_to(sc,mtcars)

## Wranglings

##Base R
apply(mtcars,2,summary)
describe(mtcars)

### dplyr framework
?summarise_all

summarise_all(mtcars,mean)

### Show the equivalent in SQL
summarise_all(cars,mean)%>%
  show_query()

### Create a new variable called
## transmission with outcome:
## automatic and manual
cars<-cars%>%
  mutate(Transmission=
  ifelse(am==0,"automatic","manual"))
glimpse(cars)

#Transmission<-as.factor(pull(cars))
#cars<-cars%>%
#  mutate(Transmission=Transmission)
#glimpse(cars)
str(cars)

cars%>%
  group_by(Transmission)%>%
  summarise_all(mean)

###########################################
##Week 2: Models in R
##########################################

install.packages(c("tidyverse", "modelr", 
                   "splines","ggfortify",
                   "caret","mice","cvAUC",
                   "rpart.plot",
                   "rpart","nycflights13"))

str(sim1)
glimpse(sim1)

#####################################
## Scatter plot
#######################################
# Quick scatter plot
ggplot(sim1, aes(x, y)) +
  geom_point(size = 3, colour = "#1B3A6B") +
  labs(title ="sim1: Response vs Predictor")+
  theme_minimal()

#### Simple linear model

model1 <- function(a, data)
  {
  y<-a[1] +  a[2]*data$x
  return(y)
}
# intercept + slope * x
# Step 2: Root-Mean-Squared Error (RMSE)
measure_distance <- function(mod, data) {
  resid <- data$y- model1(mod, data) # prediction errors
  sqrt(mean(resid^2))
  # square root of mean squared error
}

measure_distance(c(7,1.5),data=sim1)
measure_distance(c(10,1.0),data=sim1)
measure_distance(c(5,2.5),data=sim1)

### Mean absolute error

MAD_distance <- function(mod, data) {
  resid <- data$y- model1(mod, data) # prediction errors
  mean(abs(resid))
  # square root of mean squared error
}

measure_distance(c(7,1.5),data=sim1)
MAD_distance(c(7,1.5),data=sim1)
MAD_distance(c(10,1.0),data=sim1)
MAD_distance(c(15,12.5),
             data=data.frame(x=anorexia$Prewt,
                             y=anorexia$Postwt))


################################################

best_mae<-optim(par=c(1,1),fn=MAD_distance,
                data=sim1)
best_mae$par

MAD_distance(c(4.364852, 2.048918),data=sim1)
MAD_distance(c(5, 3),data=sim1)


best_mse<-optim(par=c(1,1),fn=measure_distance,
                data=sim1)
best_mse$par
measure_distance(best_mse$par,data=sim1)

#### Using the inbuilt function lm
?lm

sim1_mod<-lm(formula=y~x, data=sim1)
summary(sim1_mod)

####################################################
## Week 3: Linear Models
##################################################
??cabbages
?cabbages

library(ggplot2)
## A scatter plot of the VitC verse Headwt

ggplot(data=cabbages,aes(x=HeadWt,y=VitC))+
  geom_point(size=3,color="red")+
  labs(title = "plot of Vitamin C on Head weight")


### Fitting model
Flm1<-lm(formula = VitC~HeadWt,data=cabbages)
summary(Flm1)
plot(Flm)

qf(p=0.95,df1=1,df2=58)


Flm<-lm(formula = VitC~HeadWt+Cult+Date,
        data=cabbages)
summary(Flm)
plot(Flm)

### Base R
par(mar=c(4,4,1,1))
plot(x=cabbages$HeadWt,y=cabbages$VitC,
     xlab="Headwt",ylab="VitC")
abline(Flm1,col="red",lwd=2)

locator()
### ggplot2

ggplot(data=cabbages,aes(x=HeadWt,y=VitC))+
  geom_point(size=3,color="red")+
  geom_abline(slope=Flm1$coefficients[2],
              intercept = Flm1$coefficients[1],
              color="blue",lwd=2)+
  labs(title = "plot of Vitamin C on Head weight")



??diamonds

###########################################
## Week 3: Models in R

##########################################
library(ggplot2);library(MASS);
library(dplyr)

predict.lm(object = Flm1,
  newdata = data.frame(HeadWt=c(2,4,8,20)))
head(cabbages)



#########################################
set.seed(101)    # Generate the same data
sim5 <- tibble(
  x = seq(0, 3.5 * pi, length = 50),
  y = 4 * sin(x) + rnorm(50)
)
plot(sim5)
# Fit natural splines with 1, 3, and 5 degrees of freedom
library(splines)
sp_mods <- list(
  df1 = lm(y ~ ns(x, 1), data = sim5),
  df3 = lm(y ~ ns(x, 3), data = sim5),
  df5 = lm(y ~ ns(x, 5), data = sim5)
)

library(modelr)
# Predict on a fine grid including slight extrapolation
grid5 <- sim5 |>
  data_grid(x = seq_range(x, n = 60, expand = 0.1)) |>
  gather_predictions(!!!sp_mods, .pred = "y")

ggplot(sim5, aes(x, y)) +
  geom_point(colour = "grey40") +
  geom_line(data = grid5, colour = "#C9A84C", linewidth = 1) +
  facet_wrap(~ model, labeller = label_both) +
  labs(title = "Natural splines: df = 1, 3, 5")


##############
?airquality
plot(x=airquality$Ozone,
     y=airquality$Solar.R,
     xlab = "Ozone (ppb)",
     ylab="Solar (lang)")
plot(x=AutoClaims$PAID)