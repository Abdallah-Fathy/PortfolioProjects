
-- ***** DATA Cleaning PROJECT ******

-------------------------------------
-- Explore The Whole Data
select * 
from NashvilleHousing


-------------------------------------
-- Standrize Data Format

select SaleDateConverted, CONVERT(Date, SaleDate)
from NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
add SaleDateConverted Date

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

-------------------------------------



-- Populate Property Address date

select *
from NashvilleHousing
--where PropertyAddress is null
order by ParcelID

-- Fill THe Null Values in PropertyAddress with the address matched in ParcelID.
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, 
		ISNULL( a.PropertyAddress, b.PropertyAddress)
From NashvilleHousing a
JOIN NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ] 
where a.PropertyAddress is null


--  "We Can Use Stirng No Address If we have not The Accual Address"
Update a
SET PropertyAddress = ISNULL( a.PropertyAddress, b.PropertyAddress)
From NashvilleHousing a
JOIN NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ] 
where a.PropertyAddress is null

------------------------------------------------------------------------

-- Breaking Out Address Into Individual Culumns (Adress, City, State).





select PropertyAddress
from NashvilleHousing


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) AS Address,
SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS City
From NashvilleHousing


ALTER TABLE NashvilleHousing
add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) 


ALTER TABLE NashvilleHousing
add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


Select * 
From NashvilleHousing





Select OwnerAddress 
From NashvilleHousing


Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)  AS Address,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS City,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS State
From NashvilleHousing


ALTER TABLE NashvilleHousing
add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


ALTER TABLE NashvilleHousing
add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)





Select * 
From NashvilleHousing





------------------------------------------------------------------------

-- Change Y and N to Yes and No in "SoldAsVacant" field.




Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From NashvilleHousing
group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE when SoldAsVacant = 'Y' THEN 'Yes'
	   when SoldAsVacant = 'N' THEN 'No'
	   Else SoldAsVacant
	   End
From NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
				   when SoldAsVacant = 'N' THEN 'No'
				   Else SoldAsVacant
				   End



-------------------------------------------------------------------------

-- Remove Duplicates


WITH RowNumCTE AS (
Select *,
	ROW_NUMBER() OVER (
	Partition by parcelID,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by 
					UniqueID
				 ) row_num
From NashvilleHousing
--Order by parcelID

)
Select *   
From RowNumCTE
where row_num > 1
order by PropertyAddress





-------------------------------------------------------------------------

--- Dlete Unused Colunms


Select * 
From NashvilleHousing


ALTER TABLE NashvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict, SaleDate



-------------------------------------------------------------------------
