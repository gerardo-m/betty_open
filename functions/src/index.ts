import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {log} from "firebase-functions/logger";
admin.initializeApp();

// // Start writing functions
// // https://firebase.google.com/docs/functions/typescript

// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

export const sendInvitation = functions.firestore.
    document("participants/{participantId}").onCreate(
        async (snap, context) => {
          const newValue = snap.data();
          log("starting function with: ", newValue);
          if (newValue.eventOwnerId != newValue.userId) {
            const invitedSnapshot = await admin.firestore().
                collection("users").
                doc(newValue.userId).get();
            const invited = invitedSnapshot.data();
            if (invited != undefined) {
              log("Entering sent with:", invited);
              const response = await admin.messaging().sendToDevice(
                  invited.tokens,
                  {
                    notification: {
                      title: "Nueva invitación",
                      body: `Te han invitado al evento: ${newValue.eventName}`,
                    },
                    data: {
                      type: "eventInvitation",
                      eventId: newValue.eventId,
                    },
                  },
                  {

                    contentAvailable: true,

                    priority: "high",
                  }
              );
              log("device response", response);
            }
          }
        }
    );
