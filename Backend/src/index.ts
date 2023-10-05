require('dotenv').config();

import { log } from 'console';
import express from 'express';
import { initializeApp } from 'firebase/app';
import { getFirestore, collection, getDocs, addDoc, serverTimestamp  } from 'firebase/firestore';
import { CLIENT_RENEG_LIMIT } from 'tls';

const app = express();
const PORT = 3000;

const firebaseConfig = {
    apiKey: process.env.FIREBASE_API_KEY,
    authDomain: process.env.FIREBASE_AUTH_DOMAIN,
    projectId: process.env.FIREBASE_PROJECT_ID,
    storageBucket: process.env.FIREBASE_STORAGE_BUCKET,
    messagingSenderId: process.env.FIREBASE_MESSAGING_SENDER_ID,
    appId: process.env.FIREBASE_APP_ID,
    measurementId: process.env.FIREBASE_MEASUREMENT_ID
};

const firebaseApp = initializeApp(firebaseConfig);
const db = getFirestore(firebaseApp);

app.use(express.json());

const getRandomNumber = (min: number, max: number) => {
    return Math.random() * (max - min) + min;
}

const sendTemperatureData = async () => {
    try {
        const temperature = getRandomNumber(20, 40);
        const humidity = getRandomNumber(20, 40);

        const response = await fetch('http://localhost:3000/temperatures', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ temperature, humidity })
        });

        const data = await response.text();
        console.log('Response:', data);
    } catch (error) {
        console.error('Error:', error);
    }
}

app.get('/', async (req, res) => {
    try {
        const testCollection = collection(db, 'thermals');
        const testSnapshot = await getDocs(testCollection);
        const testDocs = testSnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
        res.json(testDocs);
    } catch (error) {
        console.error("Error reading the database", error);
        res.status(500).send("Error reading the database");
    }
});

app.post('/temperatures', async (req, res) => {
    try {
        const { temperature, humidity } = req.body;

        const dataToSave = {
            temperature,
            humidity,
            timestamp: serverTimestamp()
        };

        const tempCollection = collection(db, 'thermals');
        await addDoc(tempCollection, dataToSave);

        res.status(200).send('Data saved successfully');
    } catch (error) {
        console.error("Error saving to the database", error);
        res.status(500).send("Error saving to the database");
    }
});

app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
    setInterval(sendTemperatureData, 2000);
});