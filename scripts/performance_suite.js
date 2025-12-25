const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

/**
 * Utility to measure execution time
 */
async function measure(taskName, fn) {
    const start = Date.now();
    try {
        await fn();
        const end = Date.now();
        console.log(`[${taskName}] Success in ${end - start}ms`);
        return { success: true, time: end - start };
    } catch (e) {
        const end = Date.now();
        console.error(`[${taskName}] FAILED after ${end - start}ms: ${e.message}`);
        return { success: false, time: end - start, error: e.message };
    }
}

/**
 * 1. LOAD TESTING
 * Simulates normal expected user load (e.g., 50 concurrent checkouts)
 */
async function runLoadTest(concurrentUsers = 50) {
    console.log(`\n--- Starting LOAD TEST (${concurrentUsers} concurrent users) ---`);
    const tasks = [];
    for (let i = 0; i < concurrentUsers; i++) {
        tasks.push(measure(`User_${i}_Checkout`, async () => {
            const orderId = `load_test_${Date.now()}_${i}`;
            await db.collection('test_orders').doc(orderId).set({
                userId: `user_${i}`,
                amount: Math.random() * 100,
                status: 'completed',
                timestamp: admin.firestore.FieldValue.serverTimestamp()
            });
        }));
    }
    const results = await Promise.all(tasks);
    const avg = results.reduce((acc, r) => acc + r.time, 0) / results.length;
    console.log(`Load Test Complete. Average Latency: ${avg.toFixed(2)}ms`);
}

/**
 * 2. STRESS TESTING
 * Pushes the system to its limits by ramping up load until it breaks or slows down significantly.
 */
async function runStressTest() {
    console.log(`\n--- Starting STRESS TEST (Ramping up from 10 to 200 concurrent writes) ---`);
    const stages = [10, 50, 100, 200];
    for (const count of stages) {
        console.log(`Stress Stage: ${count} concurrent requests...`);
        const tasks = Array.from({ length: count }, (_, i) =>
            measure(`Stress_${count}_${i}`, () => db.collection('stress_test').add({ data: 'test', ts: Date.now() }))
        );
        const results = await Promise.all(tasks);
        const failures = results.filter(r => !r.success).length;
        const avg = results.reduce((acc, r) => acc + r.time, 0) / results.length;
        console.log(`Stage ${count} average: ${avg.toFixed(2)}ms. Failures: ${failures}`);
        if (failures > 0 || avg > 2000) {
            console.log("BREAKING POINT REACHED!");
            break;
        }
    }
}

/**
 * 3. SPIKE TESTING
 * Sudden, massive burst of requests (Simulates a Flash Sale)
 */
async function runSpikeTest(burstSize = 300) {
    console.log(`\n--- Starting SPIKE TEST (${burstSize} requests in one burst) ---`);
    // Simulate a sudden "flash sale" where everyone hits the db at once
    const tasks = Array.from({ length: burstSize }, (_, i) =>
        measure(`Spike_${i}`, () => db.collection('spike_test').add({ sale: 'FlashSale', ts: Date.now() }))
    );
    const results = await Promise.all(tasks);
    const failures = results.filter(r => !r.success).length;
    console.log(`Spike Test Complete. Success: ${burstSize - failures}/${burstSize}`);
}

/**
 * 4. CAPACITY TESTING
 * Determines the maximum sustainable load while maintaining acceptable latency (< 500ms)
 */
async function runCapacityTest() {
    console.log(`\n--- Starting CAPACITY TEST ---`);
    let concurrent = 20;
    while (concurrent <= 300) {
        const tasks = Array.from({ length: concurrent }, () =>
            db.collection('capacity_test').add({ ts: Date.now() })
        );
        const start = Date.now();
        await Promise.all(tasks);
        const duration = Date.now() - start;
        const avg = duration / concurrent;
        console.log(`Capacity: ${concurrent} users | Avg Latency: ${avg.toFixed(2)}ms`);

        if (avg > 500) { // Limit threshold
            console.log(`MAX CAPACITY REACHED at ${concurrent} concurrent users per second.`);
            break;
        }
        concurrent += 20;
    }
}

async function runFullSuite() {
    console.log("=== STARTING PERFORMANCE TESTING SUITE ===");
    await runLoadTest(30);
    await runCapacityTest();
    await runStressTest();
    await runSpikeTest(250);
    console.log("\n=== ALL PERFORMANCE TESTS COMPLETE ===");
    process.exit(0);
}

runFullSuite();
