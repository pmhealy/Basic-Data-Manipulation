##  Exercise 1: Basic Data Manipulation

## Step 0
urlfile<-'https://raw.githubusercontent.com/pmhealy/Basic-Data-Manipulation/master/refine_original.csv'
refine_original<-read.csv(urlfile, header=TRUE, sep=",")
refine_df<-data.frame(refine_original)

## Step 1                       
## Remove whitespace
## Make lowercase
library(stringr)
str_trim(refine_df$company)
company_cleaning<-str_trim(tolower(refine_df$company))

## Standardise mis-spelt Company names
std_company <- c("philips", "akzo", "van houten","unilever")
library(stringdist)
(i <- amatch(company_cleaning,std_company,maxDist=3))

## Compare side by side values typed manually and corrections
data.frame(rawtext = tolower(refine_df$company), code = std_company[i])
clean_company<-as.factor(std_company[i])
levels(clean_company)

## Replace Company Variable with Cleaned Version
refine_df$company<-clean_company

## Step 2   
## Separate Product Code & Number into separate columns
library(tidyr)
refine_df<-separate(data = refine_df, col = Product.code...number, into = c("Product_Code", "Product_Number"), sep = "\\-")


## Step 3
## Add Product Categories
oldvalues <- c("p", "v", "x", "q")
newvalues <- factor(c("Smartphone", "TV", "Laptop", "Tablet"))  # Make this a factor
refine_df$Product_Category <- newvalues[ match(refine_df$Product_Code, oldvalues) ]
refine_df

## Step 4
## Add Full Address
library(dplyr)
refine_df<-unite(refine_df,"Full Address", address, city, country, sep=",", remove=FALSE)
refine_df


##### Dummy Variables for Company

library(dummies)
company_dummy<-dummy(clean_company)
colnames(company_dummy)[1] <- "company_akzo"
colnames(company_dummy)[2] <- "company_philips"
colnames(company_dummy)[3] <- "company_unilever"
colnames(company_dummy)[4] <- "company_van_houten"

##### Dummy Variables for Product Category

prod_dummy<-dummy(refine_df$Product_Category)
colnames(prod_dummy)[1] <- "product_laptop"
colnames(prod_dummy)[2] <- "product_smartphone"
colnames(prod_dummy)[3] <- "product_tablet"
colnames(prod_dummy)[4] <- "product_tv"

## Combine the Data & the Dummy Variables
refine_clean<-cbind(refine_df, company_dummy, prod_dummy)

## Export in csv format
write.csv(refine_clean, "C:/Users/Mark's/Desktop/Data Science/DataScienceAssignments/Basic Data Manipulation/refine_clean.csv")
