## Vector DB Use Case

Honestly, a traditional keyword search would not work well here. The problem is simple — keyword search only finds exact words. If a lawyer searches "termination clauses" but the contract says "exit conditions" or "dissolution of agreement," the search returns nothing. Legal documents are full of this kind of indirect language, so keyword-based search misses a lot of important sections.

I think the bigger issue is that a 500-page contract has hundreds of sections, and manually reading through all of them every time is just not practical. A lawyer needs to ask a question in plain English and get the relevant section instantly.

This is where a vector database actually makes sense. The way it works is — you first split the contract into smaller chunks, maybe paragraph by paragraph. Then each chunk is converted into a vector embedding using a model like all-MiniLM-L6-v2. This embedding basically captures the meaning of that paragraph as numbers. All these embeddings get stored in a vector database like Pinecone.

When a lawyer types "What are the termination clauses?", that question also gets converted into an embedding. The vector database then finds the paragraphs whose embeddings are closest in meaning to the question — this is called similarity search. It does not care about exact words, only meaning.

So even if the contract uses different wording, the right section still comes up. For a law firm dealing with hundreds of contracts daily, this saves enormous time and reduces the chance of missing something important.