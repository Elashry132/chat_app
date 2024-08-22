const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendNotificationOnMessage = functions.firestore
  .document("chat_rooms/{chatRoomId}/messeges/{messageId}")
  .onCreate(async (snapshot, context) => {
    const messege = snapshot.data();

    try {
      const recieverDoc = await admin
        .firestore()
        .collection("users")
        .doc(messege.receiverId)
        .get();
      if (!recieverDoc.exists) {
        console.log("User not found");
        return null;
      }

      const recieverData = recieverDoc.data();
      const token = recieverData.fcmToken;

      if (!token) {
        console.log("Token not found");
        return null;
      }

      //updated message payload for 'send' method
      const messagePayload = {
        token: token,
        notification: {
          title: "New Message",
          body: "${message.senderEmail} says: ${message.message}",
        },
        andorid: {
          notification: {
            clickAction: "FLUTTER_NOTIFICATION_CLICK",
          },
        },
        apns: {
          notification: {
            clickAction: "FLUTTER_NOTIFICATION_CLICK",
          },
        },
      };

      //send the notification
      const response = await admin.messaging().send(messagePayload);
      console.log("Notification sent successfully:", response);
      return response;
    } catch (error) {
      console.error("Error sending notification", error);
      if (error.code && error.messege) {
        return { error: error.code, message: error.messege };
      }
      throw new Error("failed to send notfication");
    }
  });
