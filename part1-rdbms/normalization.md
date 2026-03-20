## Anomaly Analysis

### Insert Anomaly
If a new product is introduced but no order has been placed yet, we cannot insert that product into the system because the table requires order-related fields (like order_id). This prevents storing independent product information.

### Update Anomaly
If a customer's city needs to be updated (e.g., from Mumbai to Pune), it must be updated in multiple rows where that customer appears. Missing even one row will lead to inconsistent data.

### Delete Anomaly
If we delete the last order of a customer, we may also lose all information about that customer, including their name and city, even though we may want to retain customer details.

## Normalization Justification

The argument that keeping all data in a single table is simpler is misleading, especially when dealing with real-world datasets like orders_flat.csv. While a single table may appear easier to manage initially, it introduces serious data integrity and consistency issues.

In the given dataset, customer, product, and order information are all stored together. This leads to redundancy, where the same customer details (such as name and city) are repeated across multiple rows. As a result, any update to customer information must be applied in multiple places, increasing the risk of inconsistencies. For example, if a customer's city changes and not all rows are updated, the database will contain conflicting information.

Additionally, insert anomalies occur when we cannot add new products or customers without creating a corresponding order, limiting flexibility. Delete anomalies are also problematic — removing an order can unintentionally delete important customer or product information.

By normalizing the data into separate tables (such as Customers, Orders, Products, and Sales Representatives), we eliminate redundancy and ensure better data integrity. Each entity is stored independently, and relationships are maintained using foreign keys. This makes updates safer, inserts more flexible, and deletions less risky.

Therefore, normalization is not over-engineering but a necessary step for building scalable, consistent, and reliable database systems.