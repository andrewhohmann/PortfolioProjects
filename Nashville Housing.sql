/* 

Cleaning Data in SQL Queries

*/


Select *
From Portfolio.dbo.NashvilleHousing

-- Standardize Date Format

Select SalesDateConverted, CONVERT(date,SaleDate) 
From Portfolio.dbo.NashvilleHousing 

Update Portfolio.dbo.NashvilleHousing
Set SaleDate = CONVERT(date,SaleDate) 

Alter Table Portfolio.dbo.NashvilleHousing
Add SalesDateConverted Date;

Update Portfolio.dbo.NashvilleHousing
Set SalesDateConverted = CONVERT(date,SaleDate) 


--- Populate Property Address data

Select *
From Portfolio.dbo.NashvilleHousing
--Where PropertyAddress is null 
Order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From Portfolio.dbo.NashvilleHousing as a
Join Portfolio.dbo.NashvilleHousing as b
  on a.ParcelID = b.ParcelID 
  and a.[UniqueID ] <> b.[UniqueID ]
  Where a.PropertyAddress is null


  Update a
  set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
  From Portfolio.dbo.NashvilleHousing as a
Join Portfolio.dbo.NashvilleHousing as b
  on a.ParcelID = b.ParcelID 
  and a.[UniqueID ] <> b.[UniqueID ]
   Where a.PropertyAddress is null


   -- Breaking out Address into Individual Columns (Address, City, State)

   Select *
From Portfolio.dbo.NashvilleHousing
   
--Where PropertyAddress is null 
--Order by ParcelID

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
 , SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, Len(PropertyAddress)) as Town
From Portfolio.dbo.NashvilleHousing

Alter Table Portfolio.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update Portfolio.dbo.NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) 

Alter Table Portfolio.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update Portfolio.dbo.NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, Len(PropertyAddress))

Select *
From Portfolio.dbo.NashvilleHousing

---- Used Parsname to Split Columns

Select 
PARSENAME(Replace(OwnerAddress, ',', '.') , 3)
, PARSENAME(Replace(OwnerAddress, ',', '.') , 2)
, PARSENAME(Replace(OwnerAddress, ',', '.') , 1)
From Portfolio.dbo.NashvilleHousing


Alter Table Portfolio.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update Portfolio.dbo.NashvilleHousing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.') , 3) 

Alter Table Portfolio.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update Portfolio.dbo.NashvilleHousing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.') , 2)


Alter Table Portfolio.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update Portfolio.dbo.NashvilleHousing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.') , 1)


Select *
From Portfolio.dbo.NashvilleHousing


----Change Y and N to Yes and No in 'Sold as Vacant' field

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From Portfolio.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

Select SoldAsVacant
, case when SoldAsVacant = 'Y' Then 'Yes'
       when SoldAsVacant = 'N' Then 'No' 
	   Else SoldAsVacant
	   End
From Portfolio.dbo.NashvilleHousing

Update Portfolio.dbo.NashvilleHousing
Set SoldAsVacant = case when SoldAsVacant = 'Y' Then 'Yes'
       when SoldAsVacant = 'N' Then 'No' 
	   Else SoldAsVacant
	   End


Select *
From Portfolio.dbo.NashvilleHousing


---- Removing Duplicates

With RowNumCTE As(
Select *, 
  ROW_NUMBER() Over ( 
  Partition by ParcelID,
			   PropertyAddress,
			   SalePrice,
			   SaleDate,
			   LegalReference
			   Order by 
			      UniqueID
				  ) row_num

From Portfolio.dbo.NashvilleHousing
--Order by ParcelID
)
Delete 
From RowNumCTE
Where row_num > 1 
`--- order by PropertyAddress


---- Delete Unused Columns  


Select *
From Portfolio.dbo.NashvilleHousing

Alter Table Portfolio.dbo.NashvilleHousing
Drop Column OwnerAddress, PropertyAddress

Alter Table Portfolio.dbo.NashvilleHousing
Drop Column SaleDate