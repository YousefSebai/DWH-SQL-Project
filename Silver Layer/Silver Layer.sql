CREATE OR ALTER PROCEDURE Silver.Load_silver AS
BEGIN
	DECLARE @Start_time DATETIME , @end_time DATETIME , @batch_start_time DATETIME , @batch_end_time DATETIME;
	BEGIN TRY
    SET @batch_start_time = GETDATE();
	print '=========================================================';
	print 'Loading Silver Layer';
	print '=========================================================';

	print '=========================================================';
	print 'Loading CRM Tables';
	print '=========================================================';

	PRINT '>> Truncating Table : Silver.crm_cust_info ' ;
	TRUNCATE TABLE Silver.crm_cust_info ;
	PRINT '>> Inserting Date Into : Silver.crm_cust_info'

	INSERT INTO Silver.crm_cust_info (cst_id ,cst_key , cst_firstname ,cst_lastname , cst_maritalstatus , cst_gender , cst_create_date)


	SELECT cst_id,
	cst_key ,
	TRIM(cst_firstname) as firstname,
	TRIM(cst_lastname) as lastname,
	CASE WHEN UPPER(TRIM(cst_maritalstatus)) = 'S' then 'Single'
		 WHEN UPPER(TRIM(cst_maritalstatus)) = 'M' then 'Married'
		 else 'n/a'
		 end as Marrital_Status ,

	CASE WHEN UPPER(TRIM(cst_gender)) = 'M' then 'Male'
		 WHEN UPPER(TRIM(cst_gender)) = 'F' then 'Female'
		 else 'n/a'
		 end as Gender ,
	cst_create_date 

	FROM (

	SELECT * , ROW_NUMBER() OVER(PARTITION BY cst_id  ORDER BY cst_create_date ) as Duplicatesss
	FROM Bronze.crm_cust_info
	WHERE cst_id is NOT NULL
	) t 
	WHERE Duplicatesss = 1
	-------------------------------------------------------------------
	SET @end_time = GETDATE();
	PRINT '>> Load Duration :' + CAST(DATEDIFF(SECOND , @start_time , @end_time) as NVARCHAR) + 'Seconds'
	PRINT '------------------------------------------------------------------'

	---------------------------------------------- loading crm_prd
	SET @Start_time = GETDATE()
	PRINT '>> Truncating Table : Silver.crm_prd_info ' ;
	TRUNCATE TABLE Silver.crm_prd_info ;
	PRINT '>> Inserting Date Into : Silver.crm_prd_info'


	INSERT INTO Silver.crm_prd_info ( prd_id ,  cat_id , prd_key , prd_nm , prd_cost , prd_line , prd_start_dt , prd_end_date)

	SELECT 
		prd_id, 
		REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
		SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
		prd_nm,
		COALESCE(prd_cost, 0) AS prd_cost,
		CASE UPPER(TRIM(prd_line)) 
			WHEN 'M' THEN 'Mountain'
			WHEN 'R' THEN 'Road'
			WHEN 'T' THEN 'Touring'
			WHEN 'S' THEN 'Other Sales'
			ELSE 'n/a'
		END AS prd_line ,
		cast(prd_start_dt as date) as prd_start_date , 
		-- Use DATEADD to subtract one day from the next start date
		CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 as date) AS prd_end
	FROM Bronze.crm_prd_info

	SET @end_time = GETDATE();
	PRINT '>> Load Duration :' + CAST(DATEDIFF(SECOND , @start_time , @end_time) as NVARCHAR) + 'Seconds'
	PRINT '------------------------------------------------------------------'


	SET @Start_time = GETDATE()
	PRINT '>> Truncating Table : Silver.crm_sales_details ' ;
	TRUNCATE TABLE Silver.crm_sales_details ;
	PRINT '>> Inserting Date Into : Silver.crm_sales_details'
	-------------------------------------------------------------------------------------------------------------------
	INSERT INTO Silver.crm_sales_details (sls_ord_num , sls_prd_key , sls_cust_id , sls_ord_dt ,sls_ship_dt ,sls_due_dt ,sls_quantity , sls_sales ,sls_price)

	SELECT sls_ord_num , sls_prd_key , sls_cust_id , sls_ord_dt , sls_ship_dt ,sls_due_dt , sls_quantity ,
	CASE WHEN sls_sales IS NULL OR sls_sales <= 0 or sls_sales  != sls_quantity * sls_price THEN sls_quantity * sls_price
			ELSE sls_sales
	END as sls_Sales ,
	CASE WHEN sls_price IS NULL OR sls_price <= 0 THEN sls_sales / NULLIF(sls_quantity , 0)
			ELSE sls_price
	END AS sls_Price
	FROM Bronze.crm_sales_details

	-----------------------------------------------------------------------------------------------------------
	SET @end_time = GETDATE();
	PRINT '>> Load Duration :' + CAST(DATEDIFF(SECOND , @start_time , @end_time) as NVARCHAR) + 'Seconds'
	PRINT '------------------------------------------------------------------'


	SET @Start_time = GETDATE()
	PRINT '>> Truncating Table : Silver.erp_cust_az12 ' ;
	TRUNCATE TABLE Silver.erp_cust_az12 ;
	PRINT '>> Inserting Date Into : Silver.erp_cust_az12' ;

	INSERT INTO Silver.erp_cust_az12 ( CID , Age , gender)

	SELECT RIGHT(CID,10) as CID , DATEDIFF(year , BDATE ,GETDATE()) as Age , 
	CASE  UPPER(TRIM(GEN)) WHEN  'M' THEN 'Male'
			WHEN 'F' THEN 'Female'
			WHEN '' THEN 'n/a'
			ELSE COALESCE(GEN , 'n/a')
	END AS gender

	FROM Bronze.erp_cust_az12

	------------------------------------------------------------------------------------------------
	SET @end_time = GETDATE();
	PRINT '>> Load Duration :' + CAST(DATEDIFF(SECOND , @start_time , @end_time) as NVARCHAR) + 'Seconds'
	PRINT '------------------------------------------------------------------'


	SET @Start_time = GETDATE()
	PRINT '>> Truncating Table : Silver.erp_loc_A101 ' ;
	TRUNCATE TABLE Silver.erp_loc_A101 ;
	PRINT '>> Inserting Date Into : Silver.erp_loc_A101';

	INSERT INTO Silver.erp_loc_A101 (CID , CNTRY)

	SELECT REPLACE(CID , '-' , '') as CID ,
	CASE TRIM(CNTRY) WHEN 'DE' Then 'Germany'
					 WHEN 'USA' THEN 'United States'
					 WHEN 'US' THEN 'United States'
					 WHEN  '' THEN 'n/a'
					 ELSE COALESCE(TRIM(CNTRY ), 'n/a')
	END AS Country 
	FROM Bronze.erp_loc_A101

	--------------------------------------------------------------------------------------------
	SET @end_time = GETDATE();
	PRINT '>> Load Duration :' + CAST(DATEDIFF(SECOND , @start_time , @end_time) as NVARCHAR) + 'Seconds'
	PRINT '------------------------------------------------------------------'

	SET @Start_time = GETDATE()
	PRINT '>> Truncating Table : Silver.erp_PX_CAT_G1V2 ' ;
	TRUNCATE TABLE Silver.erp_PX_CAT_G1V2 ;
	PRINT '>> Inserting Date Into : Silver.erp_PX_CAT_G1V2';

	INSERT INTO Silver.erp_PX_CAT_G1V2 (ID , CAT , SUBCAT , MAINTAINENCE)

	SELECT ID ,
	CAT ,
	SUBCAT ,
	MAINTAINENCE
	FROM Bronze.erp_PX_CAT_G1V2;

	SET @end_time = GETDATE();
	PRINT '>> Load Duration :' + CAST(DATEDIFF(SECOND , @start_time , @end_time) as NVARCHAR) + 'Seconds'
	PRINT '------------------------------------------------------------------'

	SET @batch_end_time = GETDATE();
		PRINT '==============================='
		PRINT 'Loading Silver Layer is Completed '
		PRINT 'Total Load Duration :' + CAST(DATEDIFF(Second , @batch_start_time , @batch_end_time) as NVARCHAR) + 'Seconds' 
		PRINT '>> -------------------';

  END TRY 
  BEGIN CATCH 
	  PRINT'===================================='
	  PRINT'ERROR OCCURED DURING LOADING BRONZE LAYER'
	  PRINT 'ERROR MESSAGE' +ERROR_MESSAGE()
	  PRINT 'ERROR MESSAGE' + CAST(ERROR_NUMBER() as NVARCHAR);
	  PRINT 'ERROR MESSAGE' +CAST(ERROR_NUMBER() as NVARCHAR);
  END CATCH
	


END 