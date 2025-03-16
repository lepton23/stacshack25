importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "BMODN9xVEPIcUOblSSaauM6JOPtso9pQdZltFZnOIz7eA5w6tICs6Q8GbhqO8VC22a0vddXC8_UN07aOWsxpwPQ",
  authDomain: "cache-money-e032d.firebaseapp.com",
  databaseURL: "https://cache-money-e032d-default-rtdb.europe-west1.firebasedatabase.app/",
  projectId: "cache-money-e032d",
  storageBucket: "...",
  messagingSenderId: "...",
  appId: "...",
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});