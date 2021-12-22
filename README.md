# Used Car Price Prediction

This is a data analytics project for IND E 427 at the University of Washington-Seattle. We predict used car prices using a range of methods like linear regression, random forests, while also using methods like LASSO to determine most significant factors affecting price. The analyzed dataset was pulled from Kaggle and shows U.S. used car listings on Craigslist.com, including 25 independent variables and 427,000 listings. After data preprocessing, we proceed with 13 variables and roughly 276,000 unique listings. Using LASSO, we find 'Odometer', 'Year', 'Transmission', and 'Cylinders' to be the most important factors in predicting used car prices (in order of decreasing importance). Further, we find that the random forest model boasts a 92.7 percent accuracy, while the sparse linear regression model boasts an accuracy of 72 percent.

Kaggle Dataset: https://www.kaggle.com/austinreese/craigslist-carstrucks-data/version/10

The ipynb file "Used_Vehicle_Data_Preprocessing" details the pre-analysis procedure, a majority of which is done using the Pandas library.

The R file "project" details the analysis procedure, all of which is done using various R packages. 

The PDF "Ugurel_Kim_Shawger_FinalReport_427" is the final report submitted to the instructor, recapping the entire procedure and providing discussion on findings.

We thank Prof. Shuai Huang (shuai.huang.ie@gmail.com) for a wonderful data analytics class as applied to system engineering.
