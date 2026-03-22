## Anomaly Analysis

### Insert Anomaly
An insert anomaly occurs when new data cannot be added without other dependent data.

In the orders_flat.csv file, a new sales representative cannot be inserted unless they are associated with an order. For example, sales representative Anita Desai (SR02) only appears in rows where orders exist. If a new representative like “Pooja Mehta” joins but has no orders yet, there is no way to store her details independently.

Affected columns: sales_rep_id, sales_rep_name, sales_rep_email, office_address

---

### Update Anomaly
An update anomaly occurs when the same data is repeated across multiple rows and must be updated in all of them.

Customer Vikram Singh (C005) appears in multiple rows (e.g., rows 9, 19, 20, 28). If his city changes from Mumbai to Pune, every row must be updated. Missing even one row leads to inconsistent data, where the same customer appears in different cities.

Affected columns: customer_city, customer_email

---

### Delete Anomaly
A delete anomaly occurs when deleting a record unintentionally removes other important data.

Product Webcam (P008) appears only in one row (e.g., row 13). If that order is deleted, all information about the product (name, category, price) is lost, even though the product still exists.

Affected columns: product_id, product_name, category, unit_price

---

## Normalization Justification

At first glance, keeping everything in one table may seem simpler, but in practice it creates several issues. In the dataset, customer, product, and sales representative information is repeated across multiple rows. For instance, Vikram Singh appears in several rows. If his city changes, every occurrence must be updated. Missing even one update creates inconsistent data. Similarly, product details like “Pen Set” are duplicated across rows. Any price change would require updating all rows, increasing the risk of errors.

The delete anomaly is also critical. If the only order containing a product like “Webcam” is removed, all product information is lost. This results in loss of valuable business data.

In my opinion, normalization helps solve these issues by separating data into related tables such as customers, products, sales_reps, orders, and order_items. Each entity is stored only once, eliminating redundancy. Updates become consistent, and deletions do not remove unrelated data.

Therefore, normalization to Third Normal Form (3NF) is essential for maintaining data integrity, consistency, and scalability in real-world systems.