// OP1: insertMany() — insert all 3 documents from sample_documents.json

db.products.insertMany([
{
  product_id: "ELEC1001",
  name: "Samsung 55 inch Smart TV",
  category: "Electronics",
  price: 55000,
  brand: "Samsung",
  specifications: {
    screen_size: "55 inch",
    resolution: "4K",
    warranty_years: 2,
    voltage: "220V"
  },
  features: ["Smart TV","HDR","WiFi","Bluetooth"]
},

{
  product_id: "CLOTH2001",
  name: "Men's Denim Jacket",
  category: "Clothing",
  price: 3200,
  brand: "Levis",
  sizes_available: ["S","M","L","XL"],
  material: "Denim",
  colors: ["Blue","Black"]
},

{
  product_id: "GROC3001",
  name: "Organic Almonds",
  category: "Groceries",
  price: 850,
  brand: "Nature Fresh",
  expiry_date: new Date("2024-12-30"),
  nutritional_info: {
    protein: "21g",
    fat: "49g",
    fiber: "12g"
  }
}
]);


// OP2: find() — retrieve all Electronics products with price > 20000

db.products.find({
  category: "Electronics",
  price: { $gt: 20000 }
});


// OP3: find() — retrieve all Groceries expiring before 2025-01-01

db.products.find({
  category: "Groceries",
  expiry_date: { $lt: new Date("2025-01-01") }
});


// OP4: updateOne() — add a discount_percent field to a specific product

db.products.updateOne(
  { product_id: "ELEC1001" },
  { $set: { discount_percent: 10 } }
);


// OP5: createIndex() — create an index on category field

db.products.createIndex({ category: 1 });

// This index improves query performance when searching products by category.