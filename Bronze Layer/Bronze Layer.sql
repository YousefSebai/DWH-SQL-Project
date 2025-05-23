USE [DataWarehouse]
GO
/****** Object:  StoredProcedure [Bronze].[load_Bronze]    Script Date: 4/6/2025 3:37:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   PROCEDURE [Bronze].[load_Bronze] as 
BEGIN 
	    TRUNCATE TABLE Bronze.crm_cust_info
		BULK INSERT Bronze.crm_cust_info 
		FROM 'C:\Users\pc\OneDrive\Desktop\dwhproject\source_crm\cust_info.csv'
		WITH (

			  FIRSTROW = 2 ,
			  FIELDTERMINATOR = ',',
			  TABLOCK

		);
	
	    TRUNCATE TABLE Bronze.crm_prd_info	
		BULK INSERT Bronze.crm_prd_info 
		FROM 'C:\Users\pc\OneDrive\Desktop\dwhproject\source_crm\prd_info.csv'
		WITH (

			  FIRSTROW = 2 ,
			  FIELDTERMINATOR = ',',
			  TABLOCK

		);


	    TRUNCATE TABLE Bronze.crm_Sales_details
		BULK INSERT Bronze.crm_Sales_details
		FROM 'C:\Users\pc\downloads\sales_details.csv'
		WITH (

			  FIRSTROW = 2 ,
			  FIELDTERMINATOR = ',',
			  TABLOCK ,
			  MAXERRORS = 100

		);

		TRUNCATE TABLE Bronze.erp_cust_az12
		BULK INSERT Bronze.erp_cust_az12
		FROM 'C:\Users\pc\OneDrive\Desktop\dwhproject\source_erp\CUST_AZ12.csv'
		WITH (

			  FIRSTROW = 2 ,
			  FIELDTERMINATOR = ',',
			  TABLOCK

		);
		TRUNCATE TABLE Bronze.erp_loc_A101
		BULK INSERT Bronze.erp_loc_A101
		FROM 'C:\Users\pc\OneDrive\Desktop\dwhproject\source_erp\LOC_A101.csv'
		WITH (

			  FIRSTROW = 2 ,
			  FIELDTERMINATOR = ',',
			  TABLOCK

		);
		TRUNCATE TABLE Bronze.erp_PX_CAT_G1V2
		BULK INSERT Bronze.erp_PX_CAT_G1V2
		FROM 'C:\Users\pc\OneDrive\Desktop\dwhproject\source_erp\PX_CAT_G1V2.csv'
		WITH (

			  FIRSTROW = 2 ,
			  FIELDTERMINATOR = ',',
			  TABLOCK

	);
END