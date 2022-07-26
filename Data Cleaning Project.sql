SELECT *
FROM Portfolio.dbo.NashVilleHousing


--standardize date format

SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM Portfolio.dbo.NashVilleHousing


UPDATE NashVilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashVilleHousing
ADD SaleDateConverted DATE;

UPDATE NashVilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)




--Populate Property Adress Data

SELECT *
FROM Portfolio.dbo.NashVilleHousing
--WHERE PropertyAddress is NULL
ORDER BY ParcelID


SELECT a.ParcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM Portfolio.dbo.NashVilleHousing a
JOIN Portfolio.dbo.NashVilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM Portfolio.dbo.NashVilleHousing a
JOIN Portfolio.dbo.NashVilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL




--Breaking out Address into Individual Colums (Address,City,State)

SELECT PropertyAddress
FROM Portfolio.dbo.NashVilleHousing
--WHERE PropertyAddress is NULL
--ORDER BY ParcelID


SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) AS Address

FROM Portfolio.dbo.NashVilleHousing


ALTER TABLE NashVilleHousing
ADD PropertySplitAddress Nvarchar(255);

UPDATE NashVilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashVilleHousing
ADD PropertySplitCity Nvarchar(255);

UPDATE NashVilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))



SELECT *
FROM Portfolio.dbo.NashVilleHousing



SELECT OwnerAddress
FROM Portfolio.dbo.NashVilleHousing


SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM Portfolio.dbo.NashVilleHousing




ALTER TABLE NashVilleHousing
ADD OwnerSplitAddress Nvarchar(255);

UPDATE NashVilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE NashVilleHousing
ADD OwnerSplitCity Nvarchar(255);

UPDATE NashVilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashVilleHousing
ADD OwnerSplitState Nvarchar(255);

UPDATE NashVilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


SELECT *
FROM Portfolio.dbo.NashVilleHousing



--Change Y and N to Yes and No in "Sold as Vacant" feild


SELECT DISTINCT(SoldASVacant), COUNT(SoldASVacant)
FROM Portfolio.dbo.NashVilleHousing
GROUP BY SoldASVacant
ORDER BY 2


SELECT SoldASVacant,
CASE WHEN SoldASVacant = 'Y' THEN 'YES'
	 WHEN SoldASVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant
	 END
FROM Portfolio.dbo.NashVilleHousing


UPDATE NashVilleHousing
SET SoldAsVacant = CASE WHEN SoldASVacant = 'Y' THEN 'YES'
	 WHEN SoldASVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant
	 END



--Romove Duplicates


WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) ROW_NUM

FROM Portfolio.dbo.NashVilleHousing
)
SELECT *
FROM RowNumCTE
WHERE ROW_NUM > 1
--ORDER BY PropertyAddress

SELECT *
FROM Portfolio.dbo.NashVilleHousing



--Delete Unsued Colums

SELECT *
FROM Portfolio.dbo.NashVilleHousing

ALTER TABLE Portfolio.dbo.NashVilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE Portfolio.dbo.NashVilleHousing
DROP COLUMN Saledate