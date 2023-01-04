# retreive data
pokemon <- read.csv(file = 'C:/Users/Kelly/Downloads/2022Sem1/DEEP/pokemon.csv')
pokemon
poke_backup <- pokemon
View(pokemon)

# mean imputation
library(dplyr)
pokemon %>%
  group_by(type1) %>%
  mutate(
    height_m = impute.mean(height_m),
    weight_kg = impute.mean(weight_kg),
    percentage_male = impute.mean(percentage_male)
  )

library(tidyr)

# height 
pokemon <- pokemon %>% 
                  group_by(type1) %>% 
                                  mutate(height_m = ifelse(is.na(height_m),
                                        mean(height_m, na.rm = T), height_m))

# weight
pokemon <- pokemon %>% 
                  group_by(type1) %>% 
                                  mutate(weight_kg = ifelse(is.na(weight_kg),
                                          mean(weight_kg, na.rm = T),weight_kg))

# percentage male
pokemon <- pokemon %>% 
                  group_by(type1) %>% 
                                  mutate(percentage_male = ifelse(is.na(percentage_male),
                                         mean(percentage_male, na.rm = T),percentage_male))

# drop columns
df = subset(pokemon, select = -c(abilities, japanese_name, generation,
                                 pokedex_number, name, classfication, 
                                 type1, type2))
41-8
dim(df) # confirmed

# change capture rate to float
x <- which(is.na(as.numeric(df$capture_rate))) 
x
df$capture_rate[x] 
df$capture_rate[x] <- 50 # impute to 50

df$capture_rate <- as.numeric(df$capture_rate)
summary(df)

# regression analysis

# MLR
fit = lm(capture_rate ~ ., data = df)
summary(fit)
# percentage_male, base_total, intercept have small p-values

# choosing a model w AIC, BIC
library(leaps)

# full model 
fit_full = lm(capture_rate ~ ., data = df)
# null model
fit_null <- lm(capture_rate ~ 1, data = df)

anova(lm(capture_rate ~ against_bug, data = df), # Null model
      fit_full, # Full model
      test = 'F')

# AIC forward to determine which model with whichi predictors is the best
step(fit_null, list(upper=fit_full), direction='forward') # 11 vars
# now backwards
step(fit_null, list(upper=fit_full), direction='backward') # null

# same thing but BIC
n <- nrow(df)
step(fit_null, list(upper=fit_full), direction='forward', k = log(n)) # 4 vars
# now backwards
step(fit_null, list(upper=fit_full), direction='backward', k = log(n)) # null

# evaluating aic model
best_fit_aic <- lm(capture_rate ~ base_total + percentage_male + hp + 
                    against_rock + attack + against_normal + against_fairy + 
                    against_ground + sp_attack + against_poison + against_dragon,
                  data = df)
summary(best_fit_aic)
AIC(best_fit_aic)
BIC(best_fit_aic)
summary(best_fit_aic)$adj.r.squared
plot(best_fit_aic)

# fitted lines 
plot(fitted(best_fit_aic), df$capture_rate); 
lines(fitted(best_fit_aic), fitted(best_fit_aic))

# Other quantities we care about:
coef(summary(best_fit_aic)) 
coef(best_fit_aic) # OLS estimates
summary(best_fit_aic)$sigma # S_hat
confint(best_fit_aic, 
        level = 0.95) # 95% confidence intervals for the regression coefs

# evaluating bic model
best_fit_bic <- lm(capture_rate ~ base_total + percentage_male + hp + 
                     against_rock, data = df)
summary(best_fit_bic)
AIC(best_fit_bic)
BIC(best_fit_bic)
summary(best_fit_bic)$adj.r.squared
plot(best_fit_bic)

# fitted lines 
plot(fitted(best_fit_bic), df$capture_rate); 
lines(fitted(best_fit_bic), fitted(best_fit_bic))

# Other quantities we care about:
coef(summary(best_fit_bic)) 
coef(best_fit_bic) # OLS estimates
summary(best_fit_bic)$sigma # S_hat
confint(best_fit_bic, 
        level = 0.95) # 95% confidence intervals for the regression coefs

# non linear models
library(mgcv)
library(faraway)

plot(df$base_total, df$capture_rate)
plot(df$percentage_male, df$capture_rate)
plot(df$hp, df$capture_rate)
plot(df$against_rock, df$capture_rate)
plot(df$attack, df$capture_rate)
plot(df$against_normal, df$capture_rate)
plot(df$against_fairy, df$capture_rate)
plot(df$against_ground, df$capture_rate)
plot(df$sp_attack, df$capture_rate)
plot(df$against_poison, df$capture_rate)
plot(df$against_dragon, df$capture_rate)

# partially additive model:
add_fit = gam(capture_rate ~ base_total + percentage_male + hp + 
                against_rock + attack + against_normal + against_fairy + 
                against_ground + sp_attack + against_poison + against_dragon,
              data = df)
summary(add_fit)
plot(add_fit, shade = TRUE) # +/- 2*SE
# very large error bars for instrumentalness variable plot

AIC(add_fit) # smaller AIC
BIC(add_fit)
summary(add_fit)$r.sq
# fitted lines
plot(fitted(add_fit), spotify$popularity); 
lines(fitted(add_fit), fitted(add_fit))



















