## ETL Decisions

### Decision 1 — Standardizing Date Format
Problem: The raw dataset contained inconsistent date formats such as DD-MM-YYYY and YYYY/MM/DD, which can cause issues during analysis.

Resolution: All dates were converted into a standard SQL DATE format (YYYY-MM-DD) before loading into the dim_date table.

### Decision 2 — Handling NULL Values
Problem: Some records contained NULL values for important attributes like product category or sales amount.

Resolution: Missing category values were replaced using consistent category names, and rows with missing sales amounts were cleaned before loading.

### Decision 3 — Category Name Standardization
Problem: Product categories in the raw dataset had inconsistent casing such as "electronics", "Electronics", and "ELECTRONICS".

Resolution: All category names were standardized into a consistent format (Electronics, Clothing, Groceries) before loading them into the dim_product table.