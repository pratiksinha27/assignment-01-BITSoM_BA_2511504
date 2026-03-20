## Storage Systems

I have used four different databases in this design, each one for a specific goal.

**PostgreSQL** is used for Goal 1 and Goal 2. This database stores all live patient data like admissions, medicines, and treatment history. I chose this because it is fast and reliable for day to day hospital work. It also supports strong data consistency which is important when doctors are reading and writing patient records at the same time.

**Amazon S3** is used for all four goals. It works like a big storage folder where we keep all raw files like lab reports, images, and old records. The ML model for Goal 1 also uses this data for training. I chose S3 because it is cheap, scalable, and can store any type of file. I used Apache Spark as the ETL pipeline to move data from S3 to Redshift because Spark can process large amounts of data very fast.

**Redshift** is used for Goal 3. When management wants monthly reports like how many beds were used or what was the cost of each department, we need to scan a lot of data at once. Redshift is a columnar database built for this kind of heavy analysis. A normal database like PostgreSQL would be too slow for this type of query.

**InfluxDB** is used for Goal 4. ICU machines send data every second like heart rate and blood pressure. I chose InfluxDB because it is specially made for this type of time series sensor data and handles it much faster than a regular database.

## OLTP vs OLAP Boundary

OLTP means the live working database. In my design, OLTP ends at PostgreSQL. All the daily work like adding a new patient, writing a prescription, or searching patient history happens here. This system needs to be fast and always available for doctors.

OLAP means the database used for analysis and reports. In my design, OLAP starts at Redshift. Every night, data is copied from PostgreSQL and S3 to Redshift using the Apache Spark ETL pipeline. All the heavy report queries run on Redshift so that the live system does not slow down. This separation ensures that doctors are never affected when management is running large report queries at the same time.

InfluxDB is separate from both. It only handles real time ICU data and sends it directly to Grafana for live monitoring.

## Trade-offs

The biggest problem in my design is that PostgreSQL and Redshift are two separate databases. Data has to be copied from one to the other every night using the ETL pipeline. This means there can be a delay of up to 24 hours before new data shows up in the reports. If the nightly ETL job fails, the report will have missing data.

To fix this problem, instead of copying data every night, we can use a method called CDC which stands for Change Data Capture. A tool called Debezium watches every change happening in PostgreSQL and sends small updates to Redshift through Kafka every 15 to 30 minutes. This way the reports are almost up to date and we do not lose any data even if one system has a problem.