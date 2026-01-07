const { MongoClient } = require('mongodb');
const fs = require('fs');

async function main() {
    const uri = 'mongodb://127.0.0.1:27017'; // MongoDB server
    const client = new MongoClient(uri);

    try {
        await client.connect();
        const db = client.db('fleximart'); // database name
        const collection = db.collection('products'); // collection name

        // ==========================
        // 1️⃣ Load Data
        // ==========================
        const productsData = JSON.parse(fs.readFileSync('products_catalog.json', 'utf-8'));
        await collection.deleteMany({}); // clear previous data
        await collection.insertMany(productsData);
        console.log('✅ Data loaded successfully!');

        // ==========================
        // 2️⃣ Find Electronics under 50k
        // ==========================
        const electronicsUnder50k = await collection.find(
            { category: "Electronics", price: { $lt: 50000 } },
            { projection: { _id: 0, name: 1, price: 1, stock: 1 } }
        ).toArray();
        console.log('\n📌 Electronics products under 50k:\n', electronicsUnder50k);

        // ==========================
        // 3️⃣ Products with avg rating >= 4
        // ==========================
        const productsWithHighRating = await collection.aggregate([
            { $unwind: "$reviews" },
            { $group: {
                _id: "$product_id",
                name: { $first: "$name" },
                avgRating: { $avg: "$reviews.rating" }
            }},
            { $match: { avgRating: { $gte: 4.0 } } },
            { $project: { _id: 0, product_id: "$_id", name: 1, avgRating: 1 } }
        ]).toArray();
        console.log('\n📌 Products with average rating >= 4.0:\n', productsWithHighRating);

        // ==========================
        // 4️⃣ Add a new review to ELEC001
        // ==========================
        await collection.updateOne(
            { product_id: "ELEC001" },
            { $push: { reviews: { user_id: "U999", rating: 4, comment: "Good value", date: new Date() } } }
        );
        console.log('\n✅ Added new review to ELEC001');

        // ==========================
        // 5️⃣ Average price by category
        // ==========================
        const avgPriceByCategory = await collection.aggregate([
            { $group: {
                _id: "$category",
                avg_price: { $avg: "$price" },
                product_count: { $sum: 1 }
            }},
            { $project: { _id: 0, category: "$_id", avg_price: 1, product_count: 1 } },
            { $sort: { avg_price: -1 } }
        ]).toArray();
        console.log('\n📌 Average price by category:\n', avgPriceByCategory);

    } catch (err) {
        console.error(err);
    } finally {
        await client.close();
    }
}

main();
