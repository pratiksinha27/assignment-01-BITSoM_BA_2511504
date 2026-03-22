## Architecture Recommendation

For a fast-growing food delivery startup collecting GPS logs, customer text reviews, payment transactions, and restaurant menu images, I would recommend a **Data Lakehouse** architecture. Here are three specific reasons.

**Reason 1 — Heterogeneous data formats in one system.** The startup collects at least four fundamentally different data types: structured payments, semi-structured GPS logs (JSON), unstructured text reviews, and binary menu images. A traditional Data Warehouse like Redshift only handles structured, schema-on-write data and cannot store raw GPS streams or images without heavy pre-processing. A Data Lakehouse stores all formats in object storage (Amazon S3 or GCS) while Apache Iceberg or Delta Lake layers add ACID transactions and SQL querying on top — handling every data type without moving it.

**Reason 2 — Mixed workloads: OLTP, OLAP, and ML together.** Payments need ACID writes. Business intelligence (weekly revenue by restaurant, delivery heatmaps) needs OLAP aggregations. ML pipelines for ETA prediction and fraud detection need bulk raw feature access. A Data Lakehouse supports all three: Apache Spark for batch ML, Databricks SQL for BI dashboards, and a lightweight operational layer for writes — eliminating data duplication across separate systems.

**Reason 3 — Schema evolution without downtime.** A fast-growing startup changes its data model frequently. A Data Warehouse enforces rigid schema-on-write — ALTER TABLE on a billion-row fact table is slow and risky. Delta Lake's schema-on-read lets new fields be added without breaking existing pipelines, keeping engineering velocity high as the company scales from thousands to millions of daily orders.
