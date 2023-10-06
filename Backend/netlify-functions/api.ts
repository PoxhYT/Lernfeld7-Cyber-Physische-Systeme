require('dotenv').config();

import express from 'express';
import { initializeApp } from 'firebase/app';
import { getFirestore, collection, getDocs, addDoc, serverTimestamp } from 'firebase/firestore';
import serverless from 'serverless-http';

const app = express();

const firebaseConfig = {
    apiKey: process.env.FIREBASE_API_KEY,
    authDomain: process.env.FIREBASE_AUTH_DOMAIN,
    projectId: process.env.FIREBASE_PROJECT_ID,
    storageBucket: process.env.FIREBASE_STORAGE_BUCKET,
    messagingSenderId: process.env.FIREBASE_MESSAGING_SENDER_ID,
    appId: process.env.FIREBASE_APP_ID,
    measurementId: process.env.FIREBASE_MEASUREMENT_ID
};

let firebaseConnectionSuccessful = false;

try {
    const firebaseApp = initializeApp(firebaseConfig);
    getFirestore(firebaseApp); // This is just to initialize and check the connection, not storing it to a variable here
    firebaseConnectionSuccessful = true;
} catch (error) {
    console.error('Error initializing Firebase', error);
}

app.use(express.json());
const router = express.Router();

router.get('/getThermals', async (req, res) => {
    if (!firebaseConnectionSuccessful) {
        return res.status(500).send('Firebase connection unsuccessful');
    }

    try {
        const thermalsCollection = collection(getFirestore(), 'thermals');
        const thermalsSnapshot = await getDocs(thermalsCollection);
        const thermals = thermalsSnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
        res.json(thermals);
    } catch (error) {
        console.error("Error reading the database", error);
        res.status(500).send("Error reading the database");
    }
});

router.post('/temperatures', async (req, res) => {
    if (!firebaseConnectionSuccessful) {
        return res.status(500).send('Firebase connection unsuccessful');
    } else {
        const { temperature, humidity } = req.body;
        const dataToSave = {
            temperature,
            humidity,
            timestamp: new Date().getMilliseconds
        };

        try {
            const thermalsCollection = collection(getFirestore(), 'thermals');
            await addDoc(thermalsCollection, dataToSave);
            res.status(200).send('Data saved successfully');
        } catch (error) {
            console.error("Error saving to the database", error);
            res.status(500).send("Error saving to the database: " + error);
        }
    }

    /* try {
        const { temperature, humidity } = req.body;
        const dataToSave = {
            temperature,
            humidity,
            timestamp: serverTimestamp()
        };

        const thermalsCollection = collection(getFirestore(), 'thermals');
        await addDoc(thermalsCollection, dataToSave);

        res.status(200).send('Data saved successfully');
    } catch (error) {
        console.error("Error saving to the database", error);
        res.status(500).send("Error saving to the database");
    } */
});

router.get('/firebase-status', (req, res) => {
    if (firebaseConnectionSuccessful) {
        res.status(200).send('Firebase connection successful');
    } else {
        res.status(500).send('Firebase connection unsuccessful');
    }
});

app.use(router);

app.use(`/.netlify/functions/api`, router);

export const handler = serverless(app);
export default app;
