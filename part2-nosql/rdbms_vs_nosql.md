## Database Recommendation

For a healthcare startup building a patient management system, I would personally recommend **MySQL** as the primary database over MongoDB. The reasoning is as follows, and how the answer changes with a fraud detection module.

Healthcare data demands the highest level of consistency and transactional integrity. Patient records, prescriptions, lab results, and billing are deeply relational — a patient has appointments, each linked to a doctor, a diagnosis code, and an insurance claim. This structure maps naturally to a normalized SQL schema. More critically, **ACID compliance is non-negotiable**. Consider a prescription transaction: the prescription must be written, pharmacy inventory decremented, and a billing record created — all atomically. If any step fails, the entire transaction must roll back. A BASE system like MongoDB's default configuration allows partial writes, which in a clinical setting could mean a prescription recorded without an inventory update — a potentially dangerous inconsistency.

From the **CAP theorem** perspective, healthcare systems must prioritize Consistency and Partition Tolerance (CP) over availability. Returning stale or conflicting patient allergy data during a network partition is far more dangerous than returning an error and forcing a retry.

**Would the answer change for a fraud detection module?** Yes, partially. Fraud detection requires analyzing high-volume transaction logs, behavioral patterns, and graph-like relationships — flexible, semi-structured data at scale. This workload suits a **hybrid architecture**: MySQL handles core clinical records with full ACID guarantees, while MongoDB (or a graph database like Neo4j) handles the fraud detection pipeline's event logs and behavioral feature store. The two systems operate independently, each optimized for its specific workload.

Therefore, the recommendation is MySQL as the primary system, with MongoDB as a complementary analytical layer for fraud detection.
