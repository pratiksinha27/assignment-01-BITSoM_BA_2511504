## Storage Systems

This design uses five storage systems, each matched to a specific goal.

**PostgreSQL (Goals 1 & 2)** stores all live operational patient data — admissions, prescriptions, treatment history, and doctor notes. PostgreSQL provides full ACID compliance, which is non-negotiable in healthcare: if a prescription update fails halfway, the entire transaction must roll back to prevent dangerous partial records. Its mature support for complex relational queries and row-level security makes it right for a system where multiple doctors access the same record simultaneously.

**Amazon S3 / Data Lake (All Goals)** acts as the central raw storage layer. Lab reports, medical imaging files, historical patient records, and ICU telemetry archives land here in their original formats. S3 is cost-effective at petabyte scale and format-agnostic. Apache Spark ETL pipelines run nightly to move cleaned data into Redshift. The ML training dataset for the readmission model is also sourced from S3.

**Redshift (Goal 3)** is the data warehouse for management reporting. Monthly reports on bed occupancy and department-wise costs require aggregating millions of rows — workloads that would cripple the OLTP PostgreSQL instance. Redshift's columnar storage and massively parallel execution make these queries fast. A star schema (fact_admissions, dim_department, dim_date) is maintained here.

**Pinecone / Vector Database (Goal 2)** enables plain-English patient history queries. Records from PostgreSQL are chunked and embedded using Bio-ClinicalBERT. When a doctor asks "Has this patient had a cardiac event before?", the question is embedded and matched via Approximate Nearest Neighbor search. Retrieved chunks are passed to an LLM (RAG pipeline) to generate a grounded natural-language answer — impossible with keyword-based SQL alone.

**InfluxDB (Goal 4)** handles real-time ICU vitals. Devices publish readings every few seconds via Apache Kafka. InfluxDB is optimized for high-frequency time-series writes and sub-second range queries, feeding live Grafana bedside dashboards.

## OLTP vs OLAP Boundary

The OLTP boundary ends at PostgreSQL. All real-time clinical operations — patient registration, prescriptions, appointments — happen here, prioritizing low latency and ACID consistency.

The OLAP boundary begins at Redshift. Nightly Airflow pipelines extract snapshots from PostgreSQL and load them into Redshift dimension and fact tables. All management analytics run against Redshift, keeping OLTP load-free. InfluxDB operates independently for real-time streaming. Pinecone is a read-only semantic index derived from PostgreSQL data.

## Trade-offs

The primary trade-off is **data freshness vs. system isolation**. Nightly batch ETL means management dashboards always show yesterday's data — up to 24 hours stale. In a fast-moving hospital, this can affect resource planning decisions.

**Mitigation:** Implement Change Data Capture using Debezium, which monitors PostgreSQL's Write-Ahead Log and streams row-level changes through Apache Kafka into Redshift with 5–15 minute latency. High-priority metrics like current bed count use CDC. Lower-priority metrics like monthly cost summaries remain on nightly batch. This hybrid approach balances freshness with engineering cost and system stability.
