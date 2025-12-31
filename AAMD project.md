# **Supermarket Item Sales Prediction (R)**

## **Overview**

This project analyzes and predicts supermarket item sales using historical retail data. The objective is to understand key drivers of item-level sales and compare the performance of multiple predictive models.

The analysis includes data cleaning, feature engineering, exploratory analysis, and predictive modeling using regression-based and tree-based methods in R.

---

## **Dataset**

* Source: Public retail dataset from Kaggle (BigMart-style supermarket sales data)

* Observations: 8,500+ item–outlet combinations

* Items: 1,559 products

* Outlets: 10 stores

### **Key Variables**

* Item attributes: weight, fat content, visibility, MRP, category

* Outlet attributes: size, location type, establishment year

* Target variable: `Item_Outlet_Sales`

---

## **Methods**

### **Data Preparation**

* Standardized categorical labels (e.g., fat content)

* Replaced zero visibility values with mean visibility by item

* Engineered additional features such as:

  * Outlet age gap

  * Item category groupings

* Removed or transformed identifiers where appropriate

### **Models Implemented**

1. Stepwise Linear Regression

2. Decision Tree Regression

3. XGBoost Regression

Models were evaluated using:

* Mean Absolute Percentage Error (MAPE)

* R-squared (R²)

The Decision Tree model achieved the lowest MAPE among the tested approaches.

---

## **How to Run**

1. Clone the repository

2. Open the project folder in RStudio

3. Ensure required packages are installed (see below)

4. Run the main R script in the `code/` folder

All file paths are relative, so the script should run without modification.

---

## **Requirements**

* R (version 4.0 or higher recommended)

### **R Packages Used**

* tidyverse

* dplyr

* ggplot2

* caret

* MASS

* rpart

* rpart.plot

* xgboost

* corrplot

(Optional) For full reproducibility, the project can be initialized with `renv`.

---

## **Results**

* Tree-based models outperformed linear regression in predictive accuracy

* Item visibility, MRP, and outlet characteristics were strong predictors of sales

* Feature engineering significantly improved model performance

Detailed results, tables, and visualizations are available in the project report.

---

## **Notes**

* The dataset is publicly available; no proprietary or sensitive data is included

* This project was completed as part of an undergraduate analytics course

* The repository is intended for academic and portfolio demonstration purposes

