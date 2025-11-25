# Firestore rules & indexes (snippet)

- **Purpose:** These rules ensure that only authenticated users can read events, and only the owner can create/update an event record that lists them as `ownerId`. User documents in `users` are accessible only by the user whose UID matches the document id.

- **Why this protects data:**
  - By requiring `request.auth != null` for reads, anonymous access is blocked and only signed-in users can see event data.
  - By checking the authenticated UID against the `ownerId` field for writes, you prevent users from creating or modifying events on behalf of other users.
  - Restricting access to the `users/{userId}` document to the matching `userId` prevents one user from reading or modifying another user's profile data.

- **Indexes:** The provided `firestore.indexes.json` suggests an index on `createdAt` for sorted queries and a composite index on (`ownerId`, `createdAt`) for querying events by owner with a time sort. Deploy these indexes when you need queries that order or filter by these fields.

Deploy notes:
- Use the Firebase CLI to deploy rules and indexes: `firebase deploy --only firestore:rules,firestore:indexes` (adjust based on your project setup).
