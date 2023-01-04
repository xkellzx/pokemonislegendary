# pokemonislegendary
DEEP Fall 2022 Project - Predicting whether or not a given Pokemon is legendary based on its average stats

This is my first Python project. I was able to learn pandas, numpys, and scikit learn. I can now successfully clean data, visualizize data, and perform classification and regression.

First, I used a classification model to classify Pokemon as legendary or not. This model performed very well with a 99.17% accuracy score. The most important feature was the capture rate of the Pokemon.

Next, I used regression to predict the capture rate of a Pokemon to see if it matched my results from above. After trying linear regression, LASSO, Ridge, Elastic Net, and KNN, the method with the lowest mean squared error was LASSO. This model kept the following variables: base_total, hp, percentage_male. These results make sense as these 3 variables were also features that had some importance to classifying legnedary pokemone from the previous classification model. 

For fun, I decided to do the same thing in R but only with regression. I cleaned the data and ran different models. 

Contributions
Code written by Kelly Zeng with guidance from teammate Bryce Liu and mentor Jerry Jiang
Slides created by Kelly Zeng
