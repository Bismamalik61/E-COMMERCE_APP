const admin = require('firebase-admin');
const { faker } = require('@faker-js/faker');

// TODO: Replace with your service account key path
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function populateLargeDataset(count = 1000) {
    console.log(`Starting migration of ${count} products...`);
    const batchSize = 500;
    let b = db.batch();
    let counter = 0;

    for (let i = 0; i < count; i++) {
        const productRef = db.collection('products').doc();
        const product = {
            id: productRef.id,
            name: faker.commerce.productName(),
            description: faker.commerce.productDescription(),
            price: parseFloat(faker.commerce.price()),
            imageUrl: faker.image.url({ width: 800, height: 800, category: 'fashion' }),
            category: faker.helpers.arrayElement(['T-shirt', 'Pant', 'Shoes', 'Bag', 'Accessories']),
            rating: parseFloat((Math.random() * (5 - 3) + 3).toFixed(1))
        };

        b.set(productRef, product);
        counter++;

        if (counter === batchSize) {
            await b.commit();
            console.log(`Committed ${i + 1} products...`);
            b = db.batch();
            counter = 0;
        }
    }

    if (counter > 0) {
        await b.commit();
    }
    console.log('Finished populating products.');
}

async function simulateRapidCartUpdates(userId, iterations = 100) {
    console.log(`Simulating ${iterations} rapid cart updates for user: ${userId}`);
    const cartRef = db.collection('users').doc(userId).collection('cart');

    for (let i = 0; i < iterations; i++) {
        const productId = `test_product_${i % 10}`;
        await cartRef.doc(productId).set({
            product: {
                id: productId,
                name: `Test Product ${i % 10}`,
                price: 10.0,
                imageUrl: 'https://via.placeholder.com/150'
            },
            quantity: i + 1,
            timestamp: admin.firestore.FieldValue.serverTimestamp()
        });
        if (i % 10 === 0) console.log(`${i} updates done...`);
    }
    console.log('Finished rapid cart updates.');
}

populateLargeDataset(500); // restored to 500 for a solid volume test
// simulateRapidCartUpdates('some-user-id', 50); // Set a real UID from Firebase to test this
