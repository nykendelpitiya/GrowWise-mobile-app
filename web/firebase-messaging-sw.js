// web/firebase-messaging-sw.js
// Firebase service worker for FCM Web

importScripts("https://www.gstatic.com/firebasejs/10.12.2/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.12.2/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyA9-mgyMfSlhuogBLiWD2ceScUzZ6Mo0hk",
  authDomain: "growwise-app-9478f.firebaseapp.com",
  projectId: "growwise-app-9478f",
  storageBucket: "growwise-app-9478f.firebasestorage.app",
  messagingSenderId: "982637480206",
  appId: "1:982637480206:web:aa49248551109d1f8a6f5f",
  measurementId: "G-V4W7L41G7C",
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log("📩 Background Message:", payload);

  const title = payload.notification?.title || "GrowWise Alert 🌱";

  const notificationOptions = {
    body: payload.notification?.body || "You have a new GrowWise notification.",
    icon: "/icons/Icon-192.png",
    badge: "/icons/Icon-192.png",
    data: {
      click_action: payload.data?.click_action || "/",
    },
  };

  self.registration.showNotification(title, notificationOptions);
});

self.addEventListener("notificationclick", (event) => {
  event.notification.close();

  event.waitUntil(
    clients.matchAll({ type: "window", includeUncontrolled: true }).then((clientList) => {
      for (const client of clientList) {
        if ("focus" in client) {
          return client.focus();
        }
      }

      if (clients.openWindow) {
        return clients.openWindow("/");
      }
    })
  );
});