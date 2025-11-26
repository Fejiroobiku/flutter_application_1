# 🚀 QUICK START GUIDE - EventEase Mobile Application

## 📱 Running the Application

### Prerequisites
- Flutter SDK ≥3.5.4
- Android Studio / VS Code with Flutter extensions
- Android emulator or physical device
- Firebase account configured

### Quick Commands

```powershell
# Install dependencies
flutter pub get

# Run on connected device
flutter run

# Run on specific device
flutter devices
flutter run -d <device-id>

# Run tests
flutter test

# Check code quality
flutter analyze

# Build APK
flutter build apk --release
```

## 🔥 Firebase Setup (If Starting Fresh)

1. **Install FlutterFire CLI:**
```powershell
dart pub global activate flutterfire_cli
```

2. **Configure Firebase:**
```powershell
flutterfire configure
```

3. **Enable Authentication Methods:**
   - Go to Firebase Console → Authentication
   - Enable Email/Password
   - Enable Google Sign-In

4. **Create Firestore Database:**
   - Go to Firebase Console → Firestore Database
   - Create database in production mode
   - Apply security rules from README

## 📸 Screenshots Needed for PDF Report

### App Screenshots (12 total):
1. Login page
2. Registration page (optional)
3. Dashboard with statistics
4. Events page with event cards
5. Event details page with RSVP
6. Create event form
7. Profile page
8. Settings page - Light theme
9. Settings page - Dark theme
10. Flutter test results (terminal)
11. Flutter analyze results (terminal)
12. Firebase Console showing data

### How to Capture Screenshots:

**On Emulator:**
- Click camera icon in emulator toolbar
- Screenshots saved to `Desktop/` or `Pictures/`

**Flutter Test Results:**
```powershell
flutter test > test_results.txt
# Take screenshot of terminal
```

**Flutter Analyze Results:**
```powershell
flutter analyze > analyze_results.txt
# Take screenshot showing "63 issues found" (all info-level)
```

## 🎥 Video Demo Script (10-15 minutes)

### Setup:
- Run app on emulator
- Open Firebase Console in browser
- Split screen: App (left) + Firebase (right)
- Start screen recording

### Demo Flow:

**1. Cold Start (1 min)**
```
- Close app completely
- Show device home screen
- Open EventEase from launcher
- Wait for app to load
```

**2. Register → Logout → Login (2 min)**
```
Sougnabe presents:
- Click "Register" on login page
- Fill: Name, Email, Password
- Click "Register" button
- Navigate to Profile
- Click "Logout"
- Return to login page
- Enter credentials
- Click "Login"
- Show error for wrong password
```

**3. Visit All Screens + Rotate (2 min)**
```
Fejiro presents:
- Dashboard → show statistics
- Events → show event list
- Create Event → show form
- Event Details → show one event
- Profile → show user info
- Settings → show preferences
- Rotate device to landscape (on Events page)
- Show no pixel overflow
```

**4. CRUD Operations with Firebase (4 min)**
```
Josue presents:
Split screen visible with Firebase Console

CREATE:
- Click "Create Event" tab
- Fill form: Title, Date, Location, Category
- Click "Create Event" button
- Switch to Firebase → Show new event in Firestore

READ:
- Go to Events page
- Show events loading from Firebase
- Switch to Firebase → Show events collection

UPDATE:
- Open event details
- Click "RSVP" button
- Show attendee count increase
- Switch to Firebase → Show attendees array updated

DELETE:
- Long-press on own event (or delete button)
- Confirm deletion
- Switch to Firebase → Show event removed
```

**5. State Update (2+ widgets) (1 min)**
```
Josue continues:
- Open event details page
- Click "RSVP" button
- Point out: Button text changes ("RSVP" → "Cancel RSVP")
- Point out: Attendee count updates
- Go back to Events page
- Point out: Event card shows updated RSVP status
```

**6. SharedPreferences Persistence (2 min)**
```
Sheryl presents:
- Go to Settings page
- Show current theme (Light)
- Change to Dark theme
- Show app instantly changes to dark mode
- Close app completely (kill from recents)
- Reopen EventEase from launcher
- Show Dark theme is still active
- Go to Settings → verify Dark selected
```

**7. Validation Error (1 min)**
```
Sougnabe demonstrates:
- Go to Login page
- Leave email empty
- Click "Login"
- Show error: "Please enter your email"
- Enter invalid email: "test"
- Show error: "Please enter a valid email"
- Show polite, user-friendly error messages
```

**Wrap-up (30 sec)**
```
Digne presents:
- Show test results: "All 6 tests passed"
- Show flutter analyze: "0 critical warnings"
- Thank you message
```

### Recording Tips:
- Speak clearly and confidently
- Explain what you're doing as you do it
- Don't rush - take time to show features
- If you make a mistake, keep going (single continuous recording)
- Ensure both phone and Firebase Console are readable

## 📝 PDF Report Sections Quick Reference

### Required Sections (in order):
1. **Cover Page** - Group info, project title
2. **Table of Contents** - Numbered with page numbers
3. **Introduction** - App overview, problem, solution
4. **Features** - All implemented features listed
5. **Architecture** - Clean Architecture + BLoC explanation
6. **ERD Diagram** - Users and Events collections
7. **Firebase Configuration** - Setup + security rules
8. **Screenshots** - 12 screenshots with captions
9. **Testing** - Widget tests + unit tests description
10. **Known Limitations** - 10 items from README
11. **Setup Instructions** - How to run the app
12. **Group Contributions** - Table with Git stats
13. **Methodology** - AI usage disclosure (<40%)
14. **References** - All sources cited

### Page Count Target: 20-30 pages

## ✅ Pre-Submission Checklist

**Code Quality:**
- [x] Flutter analyze: 0 avoid_print warnings ✅
- [x] All tests passing (6/6) ✅
- [x] No TODO/FIXME comments ✅
- [x] No sensitive data in repo ✅
- [x] Clean architecture maintained ✅

**Repository:**
- [x] All code committed ✅
- [x] Pushed to GitHub ✅
- [x] Public or shared access ✅
- [x] README comprehensive ✅
- [x] No build artifacts ✅

**Documentation:**
- [ ] PDF report complete (20 pages)
- [ ] All screenshots captured (12)
- [ ] ERD diagram created
- [ ] Group contributions table
- [ ] AI usage disclosed
- [ ] References cited
- [ ] Filename: `Group#_Final_Project_Submission.pdf`

**Video:**
- [ ] 10-15 minutes recorded
- [ ] All 7 actions demonstrated
- [ ] Every member presents
- [ ] 1080p quality
- [ ] Uploaded to YouTube/Drive
- [ ] Link included in PDF

## 🆘 Common Issues & Solutions

**Issue:** Firebase not initialized
```dart
Solution: Check lib/main.dart - Firebase.initializeApp() called in main()
```

**Issue:** Google Sign-In not working
```
Solution: Ensure SHA-1 fingerprint added to Firebase Console
Command: cd android; ./gradlew signingReport
```

**Issue:** Tests failing
```powershell
Solution: Run flutter clean; flutter pub get; flutter test
```

**Issue:** Build fails
```powershell
Solution: Check pubspec.yaml dependencies match Flutter version
Run: flutter doctor -v
```

**Issue:** Emulator not showing
```powershell
Solution: Check Android SDK installed
Run: flutter emulator --launch <emulator-name>
```

## 📧 Support

**For Technical Issues:**
- Check README.md for detailed documentation
- Review SUBMISSION_CHECKLIST.md for requirements
- Check Firebase Console for backend issues

**For Git Collaboration:**
- Follow GIT_COLLABORATION_STRATEGY.md
- Create new repository for proper workflow
- Use feature branches and pull requests

## 🎯 Score Optimization

**Current Strong Areas (85/100):**
- ✅ All technical implementation complete
- ✅ Clean Architecture perfect
- ✅ BLoC state management excellent
- ✅ All CRUD operations working
- ✅ Authentication with 2 methods
- ✅ Tests passing
- ✅ Code quality excellent

**Missing Points (15/100):**
- ❌ PDF Report (20 points) - 4-5 hours to complete
- ❌ Video Demo (5 points) - 2-3 hours to record
- ⚠️ Git Collaboration (2.5 point improvement possible)

**Priority:** Focus on PDF + Video = 25 points potential gain!

## 🚨 Remember

**Deadline:** November 28, 2025 @ 2:00 AM

**Days Remaining:** 1.5 days

**Automatic Zero If:**
- Running on web/desktop (must be mobile emulator/device)
- No PDF report submitted
- No video demo submitted

**You have 85-90 points from technical work!**  
**Just need to document it! 🚀**

---

**Last Updated:** November 26, 2025  
**Status:** Repository ready for submission ✅  
**Next Step:** Create PDF report and record video demo
