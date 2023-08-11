
/* Cleaning Data 

*/

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

-- There are null values with the same address




-- Populate Property Address Data

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
WHERE PropertyAddress is null
ORDER by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

-- Join table where  ParcelID is identical, and where UniqueId is different as it is unique to the row
-- We have 35 null cells to populate

Update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null


-- Break Address into City, State

Select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing

--the addresses are comma-separated

select 
substring(PropertyAddress,1,charindex(',',PropertyAddress) -1) as Address
,substring(PropertyAddress,charindex(',',PropertyAddress) +1, len(PropertyAddress)) as State

from PortfolioProject.dbo.NashvilleHousing

-- selecting until the state, removing comma then selecting the state

Alter table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

update NashvilleHousing
set PropertySplitAddress = substring(PropertyAddress,1,charindex(',',PropertyAddress) -1) 


alter table NashvilleHousing
add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
set PropertySplitCity =  substring(PropertyAddress,charindex(',',PropertyAddress) +1, len(PropertyAddress)) 

-- added new columns


-- Splitting Owner Address

Select
Parsename(replace(OwnerAddress,',','.'),3)
,Parsename(replace(OwnerAddress,',','.'),2)
,Parsename(replace(OwnerAddress,',','.'),1)
from PortfolioProject.dbo.NashvilleHousing

Alter table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

update NashvilleHousing
set OwnerSplitAddress = Parsename(replace(OwnerAddress,',','.'),3)

alter table NashvilleHousing
add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
set OwnerSplitCity = Parsename(replace(OwnerAddress,',','.'),2)
 
 alter table NashvilleHousing
add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
set OwnerSplitState = Parsename(replace(OwnerAddress,',','.'),1)
 

 --- Change soldasvacant from binary

 select Distinct(SoldAsVacant), count(SoldAsVacant)
 from PortfolioProject.dbo.NashvilleHousing
 Group by SoldAsVacant

 select SoldAsVacant
  from PortfolioProject.dbo.NashvilleHousing

  ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ALTER COLUMN SoldAsVacant VARCHAR(3);

 update NashvilleHousing
 set SoldAsVacant = case when SoldAsVacant = '0' then 'No'
       when SoldAsVacant = '1' then 'Yes'
	   else SoldAsVacant
	   end
  from PortfolioProject.dbo.NashvilleHousing


  --- Checking and Removing Duplicates
  
  with RowNumCTE as (

  select *
  ,row_number() Over (
  Partition by ParcelID,
               PropertyAddress,
			   SalePrice,
			   SaleDate,
			   LegalReference
			   order by ParcelID
			   ) row_num
from PortfolioProject.dbo.NashvilleHousing
)
Delete
from RowNumCTE
where row_num > 1

-- checked the amount of rows with the same unique identifiers, 104 rows with 1 duplicate
-- replaced select * with delete to remove duplicates




