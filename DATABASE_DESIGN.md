# Database Design - EventEase

## Entity-Relationship Diagram (ERD)

### Overview
EventEase uses **Cloud Firestore** as its NoSQL database. The database structure consists of two main collections: `users` and `events`, with embedded documents for attendee relationships.

---

## ERD Visual Representation

```
┌─────────────────────────────────────┐
│            USERS                    │
├─────────────────────────────────────┤
│ PK: uid (String)                    │
│──────────────────────────────────────│
│    email (String, Required)         │
│    displayName (String, Required)   │
│    photoUrl (String, Optional)      │
│    bio (String, Optional)           │
│    location (String, Optional)      │
│    createdAt (Timestamp, Required)  │
│    lastLoginAt (Timestamp)          │
│    eventsCreated (Number)           │
│    eventsAttended (Number)          │
└─────────────────────────────────────┘
         │ 1
         │ creates
         │
         │ *
┌─────────────────────────────────────┐
│            EVENTS                   │
├─────────────────────────────────────┤
│ PK: eventId (String)                │
│ FK: userId (String) → USERS.uid     │
│──────────────────────────────────────│
│    title (String, Required)         │
│    description (String, Required)   │
│    category (String, Required)      │
│    date (Timestamp, Required)       │
│    time (String, Required)          │
│    location (String, Required)      │
│    imageUrl (String, Optional)      │
│    maxAttendees (Number, Optional)  │
│    currentAttendees (Number)        │
│    attendees (Array<String>)        │
│    createdAt (Timestamp, Required)  │
│    updatedAt (Timestamp, Required)  │
└─────────────────────────────────────┘
```

---

## Collection Details

### 1. USERS Collection
**Collection Path**: `/users/{uid}`

| Field Name      | Data Type  | Constraints                | Description                                |
|----------------|------------|----------------------------|--------------------------------------------|
| **uid**        | String     | Primary Key, Unique, Not Null | Firebase Authentication User ID           |
| email          | String     | Required, Unique           | User's email address                       |
| displayName    | String     | Required                   | User's full name                          |
| photoUrl       | String     | Optional                   | URL to user's profile picture              |
| bio            | String     | Optional, Max: 500 chars   | User biography/description                 |
| location       | String     | Optional                   | User's city or location                    |
| createdAt      | Timestamp  | Required, Auto-generated   | Account creation timestamp                 |
| lastLoginAt    | Timestamp  | Auto-updated               | Last successful login timestamp            |
| eventsCreated  | Number     | Default: 0                 | Count of events user has created          |
| eventsAttended | Number     | Default: 0                 | Count of events user has RSVP'd to        |

**Indexes:**
- Primary Index: `uid` (automatic)
- Composite Index: `email` (for user lookup)

**Security Rules:**
```javascript
match /users/{userId} {
  allow read: if request.auth != null;
  allow write: if request.auth != null && request.auth.uid == userId;
}
```

**Sample Document:**
```json
{
  "uid": "abc123xyz789",
  "email": "john.doe@example.com",
  "displayName": "John Doe",
  "photoUrl": "https://imagekit.io/profiles/john123.jpg",
  "bio": "Tech enthusiast and event organizer",
  "location": "Kigali, Rwanda",
  "createdAt": "2024-11-01T10:30:00Z",
  "lastLoginAt": "2024-11-25T08:15:00Z",
  "eventsCreated": 5,
  "eventsAttended": 12
}
```

---

### 2. EVENTS Collection
**Collection Path**: `/events/{eventId}`

| Field Name         | Data Type        | Constraints                    | Description                                |
|-------------------|------------------|--------------------------------|--------------------------------------------|
| **eventId**       | String           | Primary Key, Unique, Not Null  | Auto-generated unique event identifier     |
| **userId**        | String           | Foreign Key → users.uid, Not Null | Reference to event organizer              |
| title             | String           | Required, Max: 100 chars       | Event title/name                          |
| description       | String           | Required, Max: 2000 chars      | Detailed event description                 |
| category          | String (Enum)    | Required                       | Event category: Conference, Workshop, Sports, Social |
| date              | Timestamp        | Required, Must be future       | Event date and time                        |
| time              | String           | Required, Format: "HH:mm"      | Event start time                          |
| location          | String           | Required                       | Event venue/address                        |
| imageUrl          | String           | Optional                       | URL to event cover image                   |
| maxAttendees      | Number           | Optional, Min: 1, Default: ∞   | Maximum number of attendees allowed        |
| currentAttendees  | Number           | Default: 0, Calculated         | Current count of RSVPs                     |
| attendees         | Array\<String\>  | Default: []                    | Array of user IDs who RSVP'd              |
| createdAt         | Timestamp        | Required, Auto-generated       | Event creation timestamp                   |
| updatedAt         | Timestamp        | Required, Auto-updated         | Last modification timestamp                |

**Indexes:**
- Primary Index: `eventId` (automatic)
- Composite Index: `userId` + `createdAt` (for user's events query)
- Composite Index: `category` + `date` (for filtered event lists)
- Composite Index: `date` (for upcoming events query)

**Security Rules:**
```javascript
match /events/{eventId} {
  allow read: if request.auth != null;
  allow create: if request.auth != null;
  allow update, delete: if request.auth != null && 
                         resource.data.userId == request.auth.uid;
}
```

**Sample Document:**
```json
{
  "eventId": "evt_2024_conference_001",
  "userId": "abc123xyz789",
  "title": "Flutter Africa 2024",
  "description": "Annual Flutter developer conference featuring workshops, talks, and networking opportunities.",
  "category": "Conference",
  "date": "2024-12-15T09:00:00Z",
  "time": "09:00",
  "location": "Kigali Convention Centre, Rwanda",
  "imageUrl": "https://imagekit.io/events/flutter-africa-2024.jpg",
  "maxAttendees": 200,
  "currentAttendees": 87,
  "attendees": [
    "abc123xyz789",
    "def456uvw012",
    "ghi789rst345"
  ],
  "createdAt": "2024-11-01T12:00:00Z",
  "updatedAt": "2024-11-25T14:30:00Z"
}
```

---

## Relationships

### 1. User → Events (One-to-Many)
**Relationship Type**: One user can create many events

- **Parent Entity**: USERS
- **Child Entity**: EVENTS
- **Foreign Key**: `events.userId` references `users.uid`
- **Cardinality**: 1:N (One-to-Many)
- **Delete Rule**: Cascade (when user deleted, their events should be handled)

**Query Example:**
```dart
// Get all events created by a specific user
FirebaseFirestore.instance
  .collection('events')
  .where('userId', isEqualTo: currentUserId)
  .orderBy('createdAt', descending: true)
  .get();
```

### 2. User ↔ Events (Many-to-Many via Array)
**Relationship Type**: Users can RSVP to many events; Events can have many attendees

- **Implementation**: Array field `attendees` in EVENTS collection
- **Join Mechanism**: Store user UIDs in `attendees` array
- **Cardinality**: M:N (Many-to-Many)
- **Constraints**: 
  - User can RSVP only once per event (array prevents duplicates)
  - Cannot exceed `maxAttendees` limit

**Query Examples:**
```dart
// Get all events user has RSVP'd to
FirebaseFirestore.instance
  .collection('events')
  .where('attendees', arrayContains: currentUserId)
  .get();

// Add user to event attendees
eventRef.update({
  'attendees': FieldValue.arrayUnion([userId]),
  'currentAttendees': FieldValue.increment(1)
});

// Remove user from event attendees
eventRef.update({
  'attendees': FieldValue.arrayRemove([userId]),
  'currentAttendees': FieldValue.increment(-1)
});
```

---

## Database Constraints & Validation

### Business Rules Implemented

1. **User Registration**
   - Email must be unique across system
   - Display name required and cannot be empty
   - Password minimum 6 characters (Firebase Auth)

2. **Event Creation**
   - User must be authenticated
   - Event date must be in the future
   - Category must be one of: Conference, Workshop, Sports, Social
   - maxAttendees must be > 0 if specified

3. **RSVP System**
   - User cannot RSVP to their own event
   - User cannot RSVP twice to the same event
   - Cannot RSVP if event is at capacity (currentAttendees >= maxAttendees)
   - Automatic attendee count updates

4. **Authorization**
   - Only event organizer (userId) can update/delete event
   - Only authenticated users can create events
   - Users can only edit their own profile

---

## Firestore Security Rules (Complete)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return request.auth.uid == userId;
    }
    
    // USERS Collection Rules
    match /users/{userId} {
      // Anyone authenticated can read user profiles
      allow read: if isAuthenticated();
      
      // Users can only create/update their own profile
      allow create: if isAuthenticated() && isOwner(userId);
      allow update: if isAuthenticated() && isOwner(userId);
      
      // Prevent deletion (optional - can be changed)
      allow delete: if false;
    }
    
    // EVENTS Collection Rules
    match /events/{eventId} {
      // Anyone authenticated can read events
      allow read: if isAuthenticated();
      
      // Any authenticated user can create events
      allow create: if isAuthenticated() && 
                       request.resource.data.userId == request.auth.uid &&
                       request.resource.data.title.size() > 0 &&
                       request.resource.data.date is timestamp;
      
      // Only event organizer can update/delete
      allow update: if isAuthenticated() && 
                       resource.data.userId == request.auth.uid;
      
      allow delete: if isAuthenticated() && 
                       resource.data.userId == request.auth.uid;
    }
  }
}
```

### Security Rule Explanation

1. **Authentication Check**: All operations require user authentication
2. **Profile Privacy**: Users can read any profile but only modify their own
3. **Event Permissions**:
   - Create: Must be authenticated and set userId to own UID
   - Read: All authenticated users can view events
   - Update/Delete: Only the event organizer (matching userId)
4. **Data Validation**:
   - Event title cannot be empty on creation
   - Event date must be a valid timestamp
   - User ID must match authenticated user

---

## Indexes Required

### Composite Indexes (Create in Firebase Console)

1. **Events by User and Date**
   ```
   Collection: events
   Fields: userId (Ascending), createdAt (Descending)
   ```

2. **Events by Category and Date**
   ```
   Collection: events
   Fields: category (Ascending), date (Ascending)
   ```

3. **Upcoming Events**
   ```
   Collection: events
   Fields: date (Ascending), createdAt (Descending)
   ```

4. **User's Attended Events**
   ```
   Collection: events
   Fields: attendees (Array-Contains), date (Descending)
   ```

### Creating Indexes

**Option 1: Firebase Console**
- Navigate to Firestore → Indexes → Composite
- Click "Create Index"
- Add fields with specified sort orders

**Option 2: Error-Driven Creation**
- Run queries in the app
- Firebase will provide index creation links in error messages
- Click the link to auto-create required index

---

## Data Migration & Seeding

### Sample Data Structure for Testing

```dart
// Sample Users
final sampleUsers = [
  {
    'uid': 'user001',
    'email': 's.payang@alustudent.com',
    'displayName': 'Sougnabe Payang',
    'location': 'Kigali, Rwanda',
    'bio': 'Mobile developer and tech enthusiast',
    'eventsCreated': 3,
    'eventsAttended': 5,
    'createdAt': FieldValue.serverTimestamp(),
  },
  // Add more sample users...
];

// Sample Events
final sampleEvents = [
  {
    'eventId': 'evt001',
    'userId': 'user001',
    'title': 'Flutter Workshop 2024',
    'description': 'Learn Flutter app development from scratch',
    'category': 'Workshop',
    'date': Timestamp.fromDate(DateTime(2024, 12, 15, 10, 0)),
    'time': '10:00',
    'location': 'ALU Kigali Campus',
    'maxAttendees': 50,
    'currentAttendees': 12,
    'attendees': ['user002', 'user003', 'user004'],
    'createdAt': FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
  },
  // Add more sample events...
];
```

---

## Database Performance Optimization

### Best Practices Implemented

1. **Denormalization**
   - Store `currentAttendees` count directly (instead of counting array)
   - Cache user display name and photo in events (reduces reads)

2. **Efficient Queries**
   - Use `limit()` for paginated event lists
   - Filter by category before ordering by date
   - Use `arrayContains` for user's RSVP'd events

3. **Write Optimization**
   - Batch writes for multiple updates
   - Transaction for RSVP (ensure capacity check + increment)

4. **Read Optimization**
   - Enable offline persistence
   - Cache frequently accessed data locally
   - Use `get()` with `source: cache` when appropriate

### Transaction Example (RSVP with Capacity Check)

```dart
Future<void> rsvpToEvent(String eventId, String userId) async {
  final eventRef = FirebaseFirestore.instance.collection('events').doc(eventId);
  
  return FirebaseFirestore.instance.runTransaction((transaction) async {
    final eventSnapshot = await transaction.get(eventRef);
    final event = eventSnapshot.data()!;
    
    final currentCount = event['currentAttendees'] as int;
    final maxAttendees = event['maxAttendees'] as int?;
    
    // Check capacity
    if (maxAttendees != null && currentCount >= maxAttendees) {
      throw Exception('Event is at full capacity');
    }
    
    // Update in single transaction
    transaction.update(eventRef, {
      'attendees': FieldValue.arrayUnion([userId]),
      'currentAttendees': FieldValue.increment(1),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  });
}
```

---

## Backup & Recovery Strategy

### Firestore Automatic Backups
- Enable automatic exports to Cloud Storage
- Schedule: Daily at 2:00 AM UTC
- Retention: 30 days
- Location: `gs://eventease-backups/firestore-exports/`

### Manual Backup Command
```bash
gcloud firestore export gs://eventease-backups/manual-backup-$(date +%Y%m%d)
```

---

## Database Schema Evolution

### Version History

**v1.0** (November 2024)
- Initial schema with users and events collections
- Basic RSVP system with attendees array
- Email/password and Google authentication

**Future Enhancements (v2.0)**
- Add `comments` subcollection under events
- Add `notifications` collection for push notifications
- Add `event_categories` collection for dynamic categories
- Add `friendships` collection for social features
- Add geolocation fields (latitude, longitude) for proximity search

---

## Monitoring & Analytics

### Firestore Usage Metrics to Track
- Read/Write operations per day
- Storage size growth
- Active connections
- Query performance (slow queries)
- Index usage statistics

### Firebase Console Monitoring
- Navigate to Firestore → Usage tab
- Set up alerts for quota approaching limits
- Monitor billing for unexpected spikes

---

## Conclusion

This database design supports EventEase's core functionality with:
- ✅ Clear entity relationships
- ✅ Proper indexing for query performance
- ✅ Robust security rules protecting user data
- ✅ Scalable schema supporting future features
- ✅ ACID compliance through Firestore transactions
- ✅ Real-time synchronization across devices

The NoSQL structure provides flexibility while maintaining data integrity through application-level validation and Firebase security rules.
