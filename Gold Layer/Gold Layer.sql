EXEC Silver.Load_silver;

CREATE VIEW Gold.Dim_Customers as
SELECT 
    ROW_NUMBER() OVER(order BY cst_id ) as Customer_key ,
	ci.cst_id ,
	ci.cst_key,
	ci.cst_firstname ,
	ci.cst_lastname ,
	ci.cst_gender,
	ci.cst_maritalstatus ,
	ci.cst_create_date,
	ca.Age ,
	la.CNTRY
FROM Silver.crm_cust_info ci 
LEFT JOIN Silver.erp_cust_az12 ca
ON ci.cst_key =ca.CID 
LEFT JOIN Silver.erp_loc_A101 la
ON ci.cst_key = la.CID ;

----------------------------------------------------- lets CREATE Product DIm
CREATE VIEW Gold.Dim_Products as 
SELECT 
    ROW_NUMBER() OVER(ORDER BY P1.prd_start_dt , P1.prd_key) AS Product_key ,
	P1.prd_id AS Product_id,
	P1.prd_key AS Product_number,
	P1.prd_nm AS Product_name,
	P1.cat_id AS Category_ID,
	P2.CAT AS Category,
	P2.SUBCAT AS Sub_Category,
	P2.MAINTAINENCE,
	P1.prd_cost AS Cost,
	P1.prd_line AS Product_Line,
	P1.prd_start_dt AS Start_date
FROM Silver.crm_prd_info P1
LEFT JOIN Silver.erp_PX_CAT_G1V2 P2
ON P1.cat_id = P2.ID ;



CREATE VIEW Gold.Fact_Sales as 

SELECT sd.sls_ord_num AS Order_number,
Pr.Product_key,
Cr.Customer_key,
sd.sls_ord_dt AS Order_Date,
sd.sls_ship_dt AS Shipping_Date,
sd.sls_due_dt AS Due_Date,
sd.sls_sales AS Sales ,
sd.sls_quantity AS Quantity,
sd.sls_price AS Price
FROM Silver.crm_sales_details sd 
LEFT JOIN Gold.Dim_Products Pr
ON sd.sls_prd_key = Pr.Product_number 
LEFT JOIN Gold.Dim_Customers Cr
ON sd.sls_cust_id = Cr.cst_id ;
