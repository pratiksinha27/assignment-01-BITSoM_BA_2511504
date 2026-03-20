## Vector DB Use Case

A traditional keyword-based search is not effective for large legal contracts because the same concept can be expressed using different words and phrases. For example, a lawyer searching for "termination clauses" may not find relevant sections if the exact keyword is not present, even though the concept exists in the document.

A vector database solves this problem using embeddings. Embeddings convert text into numerical vectors that capture the semantic meaning of the content rather than just keywords.

In a contract search system, each section of a contract is converted into embeddings and stored in a vector database. When a lawyer submits a query in natural language, it is also converted into an embedding. The system then performs a similarity search to find the most relevant sections based on meaning, not just exact word matching.

This approach significantly improves search accuracy and helps retrieve contextually relevant information. Therefore, vector databases are highly useful for intelligent document search systems such as legal contract analysis tools.


## Reflection

Through this assignment, I understood the key difference between traditional databases and vector databases. Traditional databases like MySQL or MongoDB are designed to store structured or semi-structured data and work well with exact queries and filters.

However, they are not suitable for semantic search tasks where meaning is more important than exact keywords.

Vector databases, on the other hand, are specifically designed for similarity search using embeddings, making them ideal for semantic search tasks. They allow us to search based on meaning, which is essential for applications like document search, recommendation systems, and AI-powered chatbots.

I also learned how embeddings play a crucial role in converting text into numerical representations that machines can understand and compare.

Overall, this assignment helped me understand how modern AI systems use vector databases to enable intelligent search and retrieval, which cannot be effectively achieved using traditional databases alone.