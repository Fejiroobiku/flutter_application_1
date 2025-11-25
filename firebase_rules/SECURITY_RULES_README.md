# Firestore Security Rules

## Overview

This directory contains Firestore security rules that protect your application data from unauthorized access and malicious modifications.

## Rules Summary

### Users Collection (`/users/{userId}`)

**Purpose:** Protect user profile information and personal data.

**Rules:**
- ✅ Users can read their own document
- ✅ Users can write to their own document
- ❌ Users cannot access other users' documents
- ❌ Users cannot create new user documents (must use Cloud Functions)

**Why This Protects Data:**
- Prevents users from viewing other users' email addresses or profile info
- Prevents unauthorized profile updates or impersonation
- Ensures user data remains private and secure

```javascript
match /users/{userId} {
  allow read, write: if request.auth.uid == userId;
}
```

### Events Collection (`/events/{eventId}`)

**Purpose:** Allow public event discovery while preventing unauthorized modifications.

**Rules:**
- ✅ All authenticated users can read events
- ✅ Only event organizer (uid) can create/update/delete
- ❌ Unauthenticated users cannot access events
- ❌ Non-organizers cannot modify events

**Why This Protects Data:**
- Prevents unauthorized event creation or spam
- Event organizers can only modify their own events
- Attendee lists and event details cannot be tampered with
- Maintains event data integrity and trust

```javascript
match /events/{eventId} {
  allow read: if request.auth != null;
  allow create: if request.auth != null && request.resource.data.uid == request.auth.uid;
  allow update, delete: if request.auth != null && resource.data.uid == request.auth.uid;
}
```

### Catch-All Rule

**Default Deny:** Any undefined collections or paths are blocked by default.

```javascript
match /{document=**} {
  allow read, write: if false;
}
```

## Firestore Indexes

Query performance requires proper indexing. The following indexes are recommended:

### Index 1: User Events Ordered by Date
- **Collection:** events
- **Fields:** uid (ASC) + createdAt (DESC)
- **Use Case:** Fetching user's events in reverse chronological order
- **Query:** `firestore.collection('events').where('uid', '==', userId).orderBy('createdAt', 'desc')`

### Index 2: All Events by Date
- **Collection:** events
- **Fields:** createdAt (DESC)
- **Use Case:** Fetching all events newest first
- **Query:** `firestore.collection('events').orderBy('createdAt', 'desc')`

### Index 3: Attendee Events Ordered by Date
- **Collection:** events
- **Fields:** attendeeIds (ASC) + createdAt (DESC)
- **Use Case:** Future feature - find events a user is attending
- **Query:** `firestore.collection('events').where('attendeeIds', 'array-contains', userId).orderBy('createdAt', 'desc')`

## Deployment

### Deploy Rules via Firebase CLI

```bash
# Install Firebase CLI (if not already installed)
npm install -g firebase-tools

# Login to Firebase
firebase login

# Deploy only Firestore rules
firebase deploy --only firestore:rules

# Deploy rules and indexes
firebase deploy --only firestore
```

### Deploy Rules via Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Navigate to **Firestore Database** → **Rules**
4. Copy the rules from `firestore.rules`
5. Click **Publish**

## Security Best Practices

✅ **Implemented:**
- Authentication required for all data access
- Organizer-only event modification
- User data isolation per UID
- Explicit deny-all catch-all rule
- Proper indexing for query performance

⚠️ **Future Enhancements:**
- Rate limiting on write operations (via Cloud Functions)
- Event attendance validation (verify attendee IDs exist)
- Audit logging for sensitive operations
- Data validation for required fields (via Cloud Functions)

## Testing Rules

### Firestore Rules Emulator

Test rules locally before deploying:

```bash
# Start emulator
firebase emulators:start --only firestore

# Run tests
firebase emulators:exec 'npm test'
```

### Manual Testing in Console

1. Go to Firebase Console → Firestore → Rules
2. Click **Simulate** (if available)
3. Test with different auth states and user IDs

## Common Issues & Solutions

**Issue:** "Permission denied" when reading events
- **Cause:** User not authenticated
- **Solution:** Ensure user is logged in before querying

**Issue:** "Permission denied" when updating own event
- **Cause:** `uid` field in event doesn't match auth.uid
- **Solution:** Verify event has correct `uid` when creating

**Issue:** Queries too slow or failing
- **Cause:** Missing Firestore indexes
- **Solution:** Deploy indexes from `firestore_indexes.json`

## Related Documentation

- [Firestore Security Rules Guide](https://firebase.google.com/docs/firestore/security/get-started)
- [Firebase Authentication](https://firebase.google.com/docs/auth)
- [Firestore Indexes](https://firebase.google.com/docs/firestore/query-data/indexing)
