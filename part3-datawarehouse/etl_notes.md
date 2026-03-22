## ETL Decisions

### Decision 1 — Standardizing Inconsistent Date Formats

Problem: The `date` column in retail_transactions.csv contained three different formats across rows. For example, TXN5000 used `29/08/2023` (DD/MM/YYYY), TXN5001 used `12-12-2023` (DD-MM-YYYY), and TXN5002 used `2023-02-05` (ISO YYYY-MM-DD). This inconsistency made sorting and date-range filtering unreliable in practice — `29/08/2023` would sort before `2023-02-05` alphabetically even though it is a later date.

Resolution: All date values were standardized to ISO 8601 format (`YYYY-MM-DD`) using Python's `pd.to_datetime()` with `dayfirst=True` as the parsing rule (since the source data is India-based, DD-first formats are standard). Cleaned dates were then converted to integer `date_id` keys in YYYYMMDD format (e.g., `20230829`) for efficient indexing in `dim_date`.

---

### Decision 2 — Filling NULL store_city Values

Problem: The `store_city` column had 19 NULL/blank values across rows in retail_transactions.csv. These rows still had valid `store_name` values (e.g., `"Bangalore MG"`, `"Mumbai Central"`). Without city data, geographic analysis — such as revenue by city — would be incomplete, and these 19 rows would be silently excluded from location-based reports.

Resolution: A lookup dictionary was built from non-NULL rows, mapping each `store_name` to its `city` (e.g., `"Bangalore MG" → "Bangalore"`, `"Mumbai Central" → "Mumbai"`, `"Pune FC Road" → "Pune"`). All 19 NULL city values were then back-filled using this mapping before loading into `dim_store`. This preserved all 19 transactions rather than discarding them.

---

### Decision 3 — Standardizing Product Category Casing

Problem: The `category` column had severe inconsistency. The Electronics category appeared as both `"electronics"` (lowercase, e.g., TXN5000) and `"Electronics"` (Title Case, e.g., TXN5001). Grocery appeared as both `"Grocery"` and `"Groceries"` — two different spellings for the same logical category. This caused GROUP BY queries to split revenue into separate groups for the same category, understating category totals.

Resolution: Two transformations were applied. First, all values were converted to Title Case using `.str.title()`. Second, `"Grocery"` was mapped to `"Groceries"` via a canonical category dictionary (`{"Grocery": "Groceries", "electronics": "Electronics"}`). After this step, all five distinct stores map to exactly four clean categories: Electronics, Clothing, Groceries, and Furniture. The `dim_product` table was loaded exclusively with these standardized values.
