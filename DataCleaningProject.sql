
SELECT *
FROM NashvilleHousingProject;
--ORDER BY ParcelID;

--Convert SaleDate column to just Date format without Timesamp

--Option1
SELECT SaleDate, CONVERT(Date, SaleDate) as DateOfSale
FROM NashvilleHousingProject;

UPDATE NashvilleHousingProject
SET SaleDate = CONVERT (Date, SaleDate) ;

--Option2
ALTER TABLE NashvilleHousingProject
ADD DateOfSale DATE;

UPDATE NashvilleHousingProject
SET DateOfSale = CONVERT (Date, SaleDate);

--Populate PropertyAddress Column where there is no data

SELECT WithAddress.ParcelID, WithAddress.PropertyAddress,WithoutAddress.ParcelID, WithoutAddress.PropertyAddress,
		ISNULL(WithoutAddress.PropertyAddress, WithAddress.PropertyAddress)
FROM NashvilleHousingProject as WithAddress
JOIN NashvilleHousingProject as WithoutAddress
ON WithAddress.ParcelID = WithoutAddress.ParcelID
AND WithoutAddress.[UniqueID ]<> WithAddress.[UniqueID ];
--WHERE WithoutAddress.PropertyAddress is NULL;

UPDATE WithoutAddress
SET PropertyAddress = ISNULL(WithoutAddress.PropertyAddress, WithAddress.PropertyAddress)
FROM NashvilleHousingProject as WithAddress
JOIN NashvilleHousingProject as WithoutAddress
ON WithAddress.ParcelID = WithoutAddress.ParcelID
AND WithoutAddress.[UniqueID ]<> WithAddress.[UniqueID ]
WHERE WithoutAddress.PropertyAddress is NULL;



--BREAKING OUT PROPERTY ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY)
-- *start by splitting the address into two temp columns

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as City
FROM NashvilleHousingProject;

--Add the new address columns to the table and add populate the columns with data
--First Column called PropertyAddress2

ALTER TABLE NashvilleHousingProject
ADD PropertyAddress2 Nvarchar(255);

UPDATE NashvilleHousingProject
SET PropertyAddress2 = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1);

--Second column called PropertyAddresCity
ALTER TABLE NashvilleHousingProject
ADD PropertyAddressCity Nvarchar(255);


UPDATE NashvilleHousingProject
SET PropertyAddressCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress));



--BREAKING OUT OWNER ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE)

SELECT *
FROM NashvilleHousingProject;

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM NashvilleHousingProject;

ALTER TABLE NashvilleHousingProject
ADD OwnerAddress1 NVARCHAR(255);

UPDATE NashvilleHousingProject
SET OwnerAddress1 = PARSENAME(REPLACE(OwnerAddress,',','.'),3);


ALTER TABLE NashvilleHousingProject
ADD OwnerAddressCity NVARCHAR(255);

UPDATE NashvilleHousingProject
SET OwnerAddressCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2);


ALTER TABLE NashvilleHousingProject
ADD OwnerAddressState NVARCHAR(255);

UPDATE NashvilleHousingProject
SET OwnerAddressState = PARSENAME(REPLACE(OwnerAddress,',','.'),1);

--On Column 'SoldAsVacant' convert N to 'No' and Y to 'Yes'

Select DISTINCT(SoldAsVacant)
FROM NashvilleHousingProject;

SELECT SoldAsVacant,
	CASE
		WHEN SoldAsVacant = 'N' THEN 'No'
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		ELSE SoldAsVacant
	END
FROM NashvilleHousingProject;

UPDATE NashvilleHousingProject
SET SoldAsVacant = CASE
						WHEN SoldAsVacant = 'N' THEN 'No'
						WHEN SoldAsVacant = 'Y' THEN 'Yes'
						ELSE SoldAsVacant
					END;

--REMOVE DUPLICATES

WITH Row_orderCTE as (
SELECT*,
ROW_NUMBER() OVER (PARTITION BY ParcelID,
								PropertyAddress,
								SaleDate,
								SalePrice,
								LegalReference
								ORDER BY UniqueID) as row_num
FROM NashvilleHousingProject)

SELECT*
FROM Row_orderCTE
WHERE row_num > 1;

--DELETE UNUSED COLUMNS

SELECT*
FROM NashvilleHousingProject;

ALTER TABLE NashvilleHousingProject
DROP COLUMN PropertyAddress,OwnerAddress,TaxDistrict, SaleDate;
