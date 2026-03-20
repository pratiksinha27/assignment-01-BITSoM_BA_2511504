## Anomaly Analysis

### Insert Anomaly

If a new product is introduced but no order has been placed yet, we cannot insert that product into the system because the table requires order-related fields (like order_id). This prevents storing independent product information.

Example: In orders_flat.csv, a new product cannot be added independently because product details are tied to order_id. Without an order, the product cannot be inserted into the dataset.

### Update Anomaly

If a customer's city needs to be updated (e.g., from Mumbai to Pune), it must be updated in multiple rows where that customer appears. Missing even one row will lead to inconsistent data.

Example: In orders_flat.csv, a customer such as "Raj Sharma" appears in multiple rows with city "Mumbai". If one row is updated to "Pune" while others remain unchanged, it leads to inconsistent data.

### Delete Anomaly

If we delete the last order of a customer, we may also lose all information about that customer, including their name and city, even though we may want to retain customer details.

Example: In orders_flat.csv, if the only order associated with a customer is deleted, all information about that customer is also lost, even if we want to retain customer records.

## Normalization Justification

The argument that keeping all data in a single table is simpler is misleading, especially when dealing with real-world datasets like orders_flat.csv. While a single table may appear easier to manage initially, it introduces serious data integrity and consistency issues.

In the given dataset, customer, product, and order information are all stored together. This leads to redundancy, where the same customer details (such as name and city) are repeated across multiple rows. For example, product details like product_name and price are repeated across several rows (e.g., rows 5, 12, and 18), increasing storage inefficiency. As a result, any update to customer or product information must be applied in multiple places, increasing the risk of inconsistencies. If even one row is missed during an update, the database will contain conflicting information.

Additionally, insert anomalies occur when we cannot add new products or customers without creating a corresponding order, limiting flexibility. Delete anomalies are also problematic — removing an order can unintentionally delete important customer or product information.

By normalizing the data into separate tables such as Customers, Orders, Products, and Sales Representatives, we eliminate redundancy and ensure better data integrity. Each entity is stored independently, and relationships are maintained using foreign keys. This makes updates safer, inserts more flexible, and deletions less risky.

Therefore, normalization is not over-engineering but a necessary step for building scalable, consistent, and reliable database systems.