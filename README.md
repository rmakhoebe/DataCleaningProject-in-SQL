# SQLPortfolioProject
For Portfolio_Project
The main objective of this project is to Explore the data using some SQL functions.
Started by dividing the original file into two csv files named CovidDeaths and CovidVaccinations.
The following tasks were completed:
1.	Calculate the percentage of deaths on the total cases in each location/continent (Make use of Aggregate function and Group By)
2.	Using CAST/CONVERT functions to convert data type
3.	Performing table JOINS
4.	Make use of Window Functions to do a Rolling Count calculation
5.	Creating CTEs to further calculate values from the result table 
6.	Create a Temp Table as an alternative to a CTE
7.	Creating View to store data for later visualizations




For DataCleaningProject
The main objective of this project is to use some SQL functions to clean the data and make it more usable.

•	Task 1:  Standardize a date format. Meaning to convert the SaleDate column from datetime format to Date format (without Timestamp).

[Challenge encountered: I used UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

In an attempt to alter the SaleDate column data type but it wouldn’t be updated. I opted for creating a new column named DateOfSale with Date data type, then populated it with contents from SaleDate column and then deleted the SaleDate column, using
ALTER TABLE NashvilleHousing
ADD DateOfSale Date;
UPDATE NashvilleHousing
SET DateOfSale = CONVERT(Date,SaleDate)
]

•	Task 2: Populate NULL values in PropertyAddress column. To do this, I looked into the Parcel_Id column and realized that entries with the same ParcelID have the same PropertyAddress and I therefore concluded that ParcelID is some code for PropertyAddress. To achieve the populating of NULL values I used a self-join and then a ISNULL function.

•	Task 3: Separate PropertyAddress into two columns using STRING function, Character Index (CHARINDEX) and LEN function.

•	Task 4: Make use of PARSENAME function to separate OwnerAddress (which is Address, City and State in one column). Because PARSENAME function only works with a period(.), we use REPLACE function to replace (,) with (.)  in the OwnerAddress column. 

•	Task 5: Illustrate use of CASE Statements: In SoldAsVacant column we have 4entries (Yes, No, Y and N). I changed ‘Y’ and ‘N’ entries to ‘Yes’ and ‘No’ for uniform output.

•	Task 6: Remove duplicate entries using Window Function, ROW_NUMBER()

•	Task 7: Delete Unused columns using    
ALTER TABLE TableName

DROP COLUMN ColumnName(s)

