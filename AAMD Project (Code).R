setwd("C:/Users/dell/Desktop/AAMD Data")

list.files()
data <- read.csv("Train.csv")
colSums(is.na(data))
unique(data$Outlet_Size)
data$Outlet_Size[data$Outlet_Size == ""] <- NA
data$Item_Weight[data$Item_Weight == ""] <- NA
colSums(is.na(data))
any(duplicated(data))
unique_counts <- lapply(data, function(x) length(unique(x)))
cat_cols <- colnames(data)[!sapply(data, is.numeric)]
cat("Categorical Columns:", cat_cols, "\n")
num_cols <- colnames(data)[sapply(data, is.numeric)]
cat("Numerical Columns:", num_cols, "\n")
cat("Categorical Columns:", cat_cols, "\n")
mode_value <- names(which.max(table(data$Outlet_Size)))
data$Outlet_Size[is.na(data$Outlet_Size)] <- mode_value
colSums(is.na(data))
mean_value <- mean(data$Item_Visibility)
data$Item_Visibility[data$Item_Visibility == 0] <- mean_value
library(dplyr)
mean_item_weight <- mean(data$Item_Weight)
data <- data %>%
  mutate(Item_Weight = ifelse(is.na(Item_Weight),
                              mean(Item_Weight, na.rm = TRUE),
                              Item_Weight))
mean_item_weight <- mean(data$Item_Weight)
unique(data$Item_Fat_Content)
data$Item_Fat_Content <- gsub("^LF$", "Low Fat", data$Item_Fat_Content, ignore.case = TRUE)
data$Item_Fat_Content <- gsub("^reg$", "Regular", data$Item_Fat_Content, ignore.case = TRUE)
data$Item_Fat_Content <- gsub("^low fat$", "Low Fat", data$Item_Fat_Content, ignore.case = TRUE)
unique(data$Item_Fat_Content)
data <- data %>%
  mutate(Gap = 2013 - Outlet_Establishment_Year)
data <- data %>%
  mutate(Category = case_when(
    Item_Type %in% c("Soft Drinks", "Hard Drinks") ~ "Drinkable",
    Item_Type %in% c("Dairy", "Meat", "Fruits and Vegetables", "Baking Goods", "Snack Foods",
                     "Frozen Foods", "Breakfast", "Canned", "Breads", "Starchy Foods", "Seafood") ~ "Eatables",
    Item_Type %in% c("Household", "Health and Hygiene", "Others") ~ "Non-Consumable"
  ))

data$Item_Fat_Content[data$Category == 'Non-Consumable'] <- 'insignificant'
table(data$Item_Fat_Content)

identifer_freq_table <- table(data$Outlet_Identifier)

barplot(identifer_freq_table, 
        main = "Distribution of Outlet Identifiers",
        xlab = "Outlet Identifier",
        ylab = "Count",
        col = "black",
        border = "white",
        las = 2)
outlet_size_freq_table <- table(data$Outlet_Size)

barplot(outlet_size_freq_table, 
        main = "Distribution of Outlet Sizes",
        xlab = "Outlet Size",
        ylab = "Count",
        col = "black",
        border = "white",
        las = 2)
location_freq_table <- table(data$Outlet_Location_Type)

barplot(location_freq_table, 
        main = "Distribution of Outlet Location Types",
        xlab = "Outlet Location Type",
        ylab = "Count",
        col = "black",
        border = "white",
        las = 2)
Type_freq_table <- table(data$Outlet_Type)

barplot(Type_freq_table, 
        main = "Distribution of Outlet Types",
        xlab = "Outlet Type",
        ylab = "Count",
        col = "black",
        border = "white",
        las = 2)

freq_table <- table(data$Category)
print(freq_table)
barplot(freq_table, 
        main = "Item Types",
        xlab = "New Item Types",
        ylab = "Frequency",
        col = "black",
        border = "white")
str(data)
relevant_vars <- data[c("Item_Weight", "Item_Visibility", "Item_MRP", "Outlet_Establishment_Year", "Gap", "Item_Outlet_Sales")]
corr_matrix <- cor(relevant_vars)
cor_sales <- corr_matrix[,"Item_Outlet_Sales"]
cor_sales <- cor_sales[!is.na(cor_sales)]
cor_sales <- cor_sales[order(abs(cor_sales), decreasing = TRUE)]
print(cor_sales)
relevant_vars <- data[c("Item_Weight", "Item_Visibility", "Item_MRP", "Outlet_Establishment_Year", "Gap", "Item_Outlet_Sales")]
corr_matrix <- cor(relevant_vars)
heatmap(corr_matrix, 
        annot = TRUE,         # Add annotation (correlation coefficients)
        cmap = "coolwarm",    # Color palette for heatmap
        cexCol = 0.8,         # Column label font size
        cexRow = 0.8,         # Row label font size
        main = "Correlation Matrix Heatmap",  # Heatmap title
        show_colnames = TRUE, # Show column names
        show_rownames = TRUE, # Show row names
        symm = TRUE,          # Make the heatmap symmetric
        margins = c(10, 10)   # Set margins for row and column names
)
library(corrplot)
relevant_vars <- data[c("Item_Weight", "Item_Visibility", "Item_MRP", "Outlet_Establishment_Year", "Gap", "Item_Outlet_Sales")]
corr_matrix <- cor(relevant_vars)
corrplot(corr_matrix, method = "color", type = "upper", order = "hclust",
         tl.col = "black", tl.srt = 45, tl.pos = "lt", diag = FALSE)
library(gplots)
relevant_vars <- data[c("Item_Weight", "Item_Visibility", "Item_MRP", "Outlet_Establishment_Year", "Gap", "Item_Outlet_Sales")]
corr_matrix <- cor(relevant_vars)

dev.new()

heatmap.2(corr_matrix,
          main = "Correlation Matrix Heatmap",
          xlab = "Variables",
          ylab = "Variables",
          col = colorRampPalette(c("white", "blue"))(100),
          key = TRUE,
          key.title = "Correlation",
          key.xlab = NULL,
          key.ylab = NULL,
          density.info = "none",
          trace = "none",
          cexRow = 1.0,
          cexCol = 1.0,
          labRow = rownames(corr_matrix),
          labCol = colnames(corr_matrix),
          srtRow = 45,
          offsetRow = 0.5,
          cex.main = 1.2,
          cex.axis = 0.8,
          cex.lab = 0.8,
          labels = TRUE)
plot(data$Item_MRP,data$Item_Outlet_Sales,
     main = "Item MRP vs Item Sales",
     xlab = "Item MRP",
     ylab = "Item Sales",
     col = "blue",
     pch = 16,
     cex = 0.8)

library(ggplot2)
ggplot(data, aes(x = Item_MRP, y = Item_Outlet_Sales)) +
  geom_point(color = "blue", size = 3) +
  labs(title = "Item MRP vs Item Sales",
       x = "Item MRP",
       y = "Item Sales") +
  theme_minimal()
dev.new()

clean_data <- data


library(caret)

cols_to_encode <- c("Item_Identifier", "Item_Type", "Outlet_Identifier")

for (col in cols_to_encode) {
  clean_data[[col]] <- as.integer(factor(clean_data[[col]]))
}

library(dplyr)
library(caret)

cols_to_one_hot <- c("Item_Fat_Content", "Outlet_Size", "Outlet_Location_Type", "Outlet_Type", "Category")

dummy_data <- predict(dummyVars(~., data = clean_data[cols_to_one_hot]), newdata = clean_data)
clean_data <- cbind(clean_data, dummy_data)

clean_data <- clean_data[, !(names(clean_data) %in% c("Item_Fat_Content", "Outlet_Size", "Outlet_Location_Type", "Outlet_Type"))]
clean_data <- clean_data[, !colnames(clean_data) %in% "Category"]

train <- clean_data[1:4262, ]
test <- clean_data[4263:8523, ]

formula <- formula(Item_Outlet_Sales ~ Item_Identifier + Item_Weight + Item_Visibility + Item_Type + Item_MRP +
                     Outlet_Identifier + Outlet_Establishment_Year + Item_Fat_Contentinsignificant +
                     `Item_Fat_ContentLow Fat` + Outlet_SizeHigh + Outlet_SizeMedium +
                     `Outlet_Location_TypeTier 1` + `Outlet_Location_TypeTier 2` +
                     `Outlet_TypeGrocery Store` + `Outlet_TypeSupermarket Type1` +
                     `Outlet_TypeSupermarket Type2` + CategoryDrinkable)

model <- lm(formula, data = train)

summary(model)

colSums(is.na(clean_data))

clean_data <- clean_data[, !colnames(clean_data) %in% "Category"]

col_has_na <- colSums(is.na(clean_data)) > 0
print(col_has_na)

str(clean_data)

trainpreds <- model$fitted.values
testpreds <- predict(model,
                     test,
                     type = "response")
allpreds <- c(trainpreds, testpreds)

write.csv(allpreds, file = "Item_Outlet_Sales_preds_final.csv")

absolute_error_train <- abs(trainpreds - train$Item_Outlet_Sales)
percentage_error_train <- (absolute_error_train / train$Item_Outlet_Sales) * 100
mape_train <- mean(percentage_error_train)

absolute_error <- abs(testpreds - test$Item_Outlet_Sales)
percentage_error <- (absolute_error / test$Item_Outlet_Sales) * 100
mape_test <- mean(percentage_error)


# Decision Tree -----------------------------------------------------------

library(rpart)
library(rpart.plot)

model_dt <- rpart(formula = Item_Outlet_Sales~.,
                  data = train)
model_dt
rpart.plot(model_dt)

train_preds <- model_dt$fitted.values

test_preds <- predict(model_dt, test, type = "vector")

library(caret)
rmse <- RMSE(testpreds, test$Item_Outlet_Sales)
r_squared <- R2(pred = test_preds, obs = test$Item_Outlet_Sales)

cat("RMSE:", rmse, "\n")
cat("R-squared:", r_squared, "\n")

all_preds <- c(train_preds, test_preds)

write.csv(allpreds, file = "decisiontree_preds.csv")

# Install and load the necessary libraries
install.packages("xgboost")
library(xgboost)

# Prepare the data
train_matrix <- xgb.DMatrix(as.matrix(train[, -c(which(names(train) == "Item_Outlet_Sales"))]), label = train$Item_Outlet_Sales)
test_matrix <- xgb.DMatrix(as.matrix(test[, -c(which(names(test) == "Item_Outlet_Sales"))]), label = test$Item_Outlet_Sales)

# Set the XGBoost parameters
params <- list(
  objective = "reg:squarederror",  # Regression objective
  eval_metric = "rmse",            # Evaluation metric: Root Mean Squared Error
  max_depth = 6,                   # Maximum tree depth
  eta = 0.3,                       # Learning rate
  nrounds = 100                    # Number of boosting rounds
)

# Train the XGBoost model
xgb_model <- xgboost(params = params, data = train_matrix, nrounds = params$nrounds)

# Make predictions on the test data
xgb_preds <- predict(xgb_model, test_matrix)

# Calculate RMSE
rmse <- sqrt(mean((xgb_preds - test$Item_Outlet_Sales)^2))

# Calculate R-squared
r_squared <- 1 - sum((test$Item_Outlet_Sales - xgb_preds)^2) / sum((test$Item_Outlet_Sales - mean(test$Item_Outlet_Sales))^2)

# Print RMSE and R-squared
cat("RMSE:", rmse, "\n")
cat("R-squared:", r_squared, "\n")

summary(xgb_model)
str(train)
importance <- xgb.importance(model = xgb_model)
print(importance)
feature_importance <- importance[, c("Feature", "Gain")]
print(feature_importance)



