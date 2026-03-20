## Storage Systems

I have used four different databases in this design, each one serving a specific purpose.

**PostgreSQL** is used for Goal 1 and Goal 2. This database stores all live patient data such as admissions, medicines, and treatment history. I chose this because it provides ACID transactions, high reliability, and strong data consistency, which are critical when multiple doctors are accessing and updating patient records simultaneously.

**Amazon S3** is used for all four goals. It acts as a scalable object storage system where we store raw files such as lab reports, medical images, and historical records. The machine learning model for Goal 1 also uses this data for training. I chose S3 because it is cost-effective, highly scalable, and capable of storing any type of data. Apache Spark is used as the ETL (Extract, Transform, Load) pipeline to process and move data from S3 to Redshift efficiently.

**Redshift** is used for Goal 3. When management requires monthly reports such as bed utilization or departmental costs, large volumes of data need to be analyzed. Redshift is a columnar data warehouse designed for such analytical workloads. A transactional database like PostgreSQL would be inefficient for these types of queries.

**InfluxDB** is used for Goal 4. ICU devices generate high-frequency time-series data such as heart rate and blood pressure. I chose InfluxDB because it is optimized for time-series data and can efficiently handle real-time data ingestion and querying.

## OLTP vs OLAP Boundary

OLTP refers to the live operational database. In this design, OLTP ends at PostgreSQL. All day-to-day operations such as patient registration, prescription updates, and record retrieval are handled here. This system must be fast, consistent, and highly available for healthcare professionals.

OLAP refers to systems used for analytical processing. In this design, OLAP starts at Redshift. Data from PostgreSQL and S3 is periodically processed and transferred to Redshift using an Apache Spark ETL (Extract, Transform, Load) pipeline. Analytical queries and reports are executed on Redshift to ensure that the OLTP system remains unaffected by heavy workloads.

InfluxDB operates separately as a specialized system for real-time ICU monitoring and directly feeds data to Grafana dashboards.

## Trade-offs

A key limitation of this design is the separation between PostgreSQL and Redshift. Data is transferred between these systems using batch ETL processes, which can introduce a delay of up to 24 hours before new data becomes available for reporting. Additionally, if the ETL pipeline fails, reports may become incomplete or outdated.

To address this issue, a Change Data Capture (CDC) approach can be implemented. Tools like Debezium can capture real-time changes from PostgreSQL and stream them through Kafka to Redshift at regular intervals (e.g., every 15–30 minutes). This reduces latency, improves data freshness, and ensures more reliable data synchronization across systems.
