# 🚀 1-HOUR GIT SPRINT: FILE-BY-FILE GUIDE

**Team:** Sougnabe, Josue, Fejiro, Sheryl, Digne  
**Goal:** 90 commits in 60 minutes, perfectly balanced (18 each)  
**Strategy:** Sequential file commits following dependency order

---

## ⏱️ SETUP (5 MINUTES)

```powershell
# 1. Create new repo: flutter_application_1_final (on GitHub)
# 2. All 5 members clone it:
git clone https://github.com/Fejiroobiku/flutter_application_1_final.git
cd flutter_application_1_final

# 3. Copy all files from old repo:
Copy-Item -Path "C:\Users\RICHARD\flutter_application_1\*" -Destination "." -Recurse -Exclude ".git"

# 4. Each person creates their branch:
# Sougnabe:
git checkout -b sougnabe-contributions

# Josue:
git checkout -b josue-contributions

# Fejiro:
git checkout -b fejiro-contributions

# Sheryl:
git checkout -b sheryl-contributions

# Digne:
git checkout -b digne-contributions

# 5. Everyone ready? START TIMER! ⏱️
```

---

## 📋 COMMIT SEQUENCE (Follow This Order)

### **PHASE 1: Foundation** (10 files, ~7 min)

| # | File | Person | Commit Message |
|---|------|--------|----------------|
| 1 | `pubspec.yaml` | Digne | `chore: Add project dependencies` |
| 2 | `analysis_options.yaml` | Digne | `chore: Configure linting rules` |
| 3 | `lib/firebase_options.dart` | Digne | `feat: Add Firebase configuration` |
| 4 | `lib/core/constants/app_colors.dart` | Fejiro | `feat: Define app color theme` |
| 5 | `lib/core/services/preferences_service.dart` | Sheryl | `feat: Add SharedPreferences service` |
| 6 | `README.md` (add first 50 lines) | Digne | `docs: Add project overview` |
| 7 | `android/gradle.properties` | Sheryl | `chore: Configure Android properties` |
| 8 | `web/index.html` | Fejiro | `chore: Configure web entry` |
| 9 | `web/manifest.json` | Fejiro | `chore: Add web manifest` |
| 10 | `.gitignore` | Digne | `chore: Add Flutter gitignore` |

### **PHASE 2: Domain Layer** (4 files, ~3 min)

| # | File | Person | Commit Message |
|---|------|--------|----------------|
| 11 | `lib/domain/entities/user_entity.dart` | Sheryl | `feat: Add User domain entity` |
| 12 | `lib/domain/entities/event_entity.dart` | Josue | `feat: Add Event domain entity` |
| 13 | `lib/domain/repositories/auth_repository.dart` | Sougnabe | `feat: Define Auth repository interface` |
| 14 | `lib/domain/repositories/event_repository.dart` | Josue | `feat: Define Event repository interface` |

### **PHASE 3: Data Models** (4 files, ~3 min)

| # | File | Person | Commit Message |
|---|------|--------|----------------|
| 15 | `lib/data/models/user_model.dart` | Sheryl | `feat: Implement User data model` |
| 16 | `lib/data/models/user.dart` | Sheryl | `feat: Add legacy User model` |
| 17 | `lib/data/models/event_model.dart` | Josue | `feat: Implement Event data model` |
| 18 | `lib/data/models/event.dart` | Josue | `feat: Add legacy Event model` |

### **PHASE 4: Data Sources** (10 files, ~7 min)

| # | File | Person | Commit Message |
|---|------|--------|----------------|
| 19 | `lib/data/datasources/firebase_auth_service.dart` | Sougnabe | `feat: Add Firebase Auth service` |
| 20 | `lib/data/datasources/auth_service.dart` | Sougnabe | `feat: Implement Auth data source` |
| 21 | `lib/data/datasources/google_auth_datasource.dart` | Sougnabe | `feat: Add Google Auth integration` |
| 22 | `lib/data/datasources/firestore_user_datasource.dart` | Sheryl | `feat: Add Firestore user operations` |
| 23 | `lib/data/datasources/user_profile_service.dart` | Sheryl | `feat: Add user profile service` |
| 24 | `lib/data/datasources/firestore_event_datasource.dart` | Josue | `feat: Add Firestore event operations` |
| 25 | `lib/data/datasources/event_service.dart` | Josue | `feat: Implement Event service` |
| 26 | `lib/data/datasources/backend_service.dart` | Digne | `feat: Add backend service` |
| 27 | `lib/data/datasources/local_storage_service.dart` | Digne | `feat: Add local storage` |
| 28 | `lib/data/datasources/imagekit_service.dart` | Sheryl | `feat: Add image upload service` |

### **PHASE 5: Repositories** (2 files, ~1.5 min)

| # | File | Person | Commit Message |
|---|------|--------|----------------|
| 29 | `lib/data/repositories/auth_repository_impl.dart` | Sougnabe | `feat: Implement Auth repository` |
| 30 | `lib/data/repositories/event_repository_impl.dart` | Josue | `feat: Implement Event repository` |

### **PHASE 6: BLoC** (6 files, ~4 min)

| # | File | Person | Commit Message |
|---|------|--------|----------------|
| 31 | `lib/presentation/bloc/auth/auth_event.dart` | Sougnabe | `feat: Define Auth BLoC events` |
| 32 | `lib/presentation/bloc/auth/auth_state.dart` | Sougnabe | `feat: Define Auth BLoC states` |
| 33 | `lib/presentation/bloc/auth/auth_bloc.dart` | Sougnabe | `feat: Implement Auth BLoC` |
| 34 | `lib/presentation/bloc/event/event_event.dart` | Josue | `feat: Define Event BLoC events` |
| 35 | `lib/presentation/bloc/event/event_state.dart` | Josue | `feat: Define Event BLoC states` |
| 36 | `lib/presentation/bloc/event/event_bloc.dart` | Josue | `feat: Implement Event BLoC` |

### **PHASE 7: Widgets** (5 files, ~3.5 min)

| # | File | Person | Commit Message |
|---|------|--------|----------------|
| 37 | `lib/presentation/widgets/custom_footer.dart` | Fejiro | `feat: Add custom footer widget` |
| 38 | `lib/presentation/widgets/stats_card.dart` | Fejiro | `feat: Add stats card widget` |
| 39 | `lib/presentation/widgets/event_card.dart` | Fejiro | `feat: Add event card widget` |
| 40 | `lib/presentation/widgets/custom_navbar.dart` | Fejiro | `feat: Add custom navbar` |
| 41 | `lib/presentation/widgets/main_app_shell.dart` | Fejiro | `feat: Implement app shell` |

### **PHASE 8: Pages** (9 files, ~6 min)

| # | File | Person | Commit Message |
|---|------|--------|----------------|
| 42 | `lib/presentation/pages/login_page.dart` | Sougnabe | `feat: Add login page` |
| 43 | `lib/presentation/pages/register_page.dart` | Sougnabe | `feat: Add register page` |
| 44 | `lib/presentation/pages/home_page.dart` | Fejiro | `feat: Add home page` |
| 45 | `lib/presentation/pages/dashboard_page.dart` | Fejiro | `feat: Add dashboard page` |
| 46 | `lib/presentation/pages/events_page.dart` | Josue | `feat: Add events list page` |
| 47 | `lib/presentation/pages/event_details_page.dart` | Josue | `feat: Add event details page` |
| 48 | `lib/presentation/pages/create_event_page.dart` | Josue | `feat: Add create event page` |
| 49 | `lib/presentation/pages/profile_page.dart` | Sheryl | `feat: Add profile page` |
| 50 | `lib/presentation/pages/settings_page.dart` | Sheryl | `feat: Add settings page` |

### **PHASE 9: Main App** (1 file, ~40 sec)

| # | File | Person | Commit Message |
|---|------|--------|----------------|
| 51 | `lib/main.dart` | Fejiro | `feat: Configure app entry` |

### **PHASE 10: Tests** (7 commits, ~5 min)

| # | Action | Person | Commit Message |
|---|--------|--------|----------------|
| 52 | Create test file | Digne | `test: Add test structure` |
| 53 | Add MaterialApp test | Digne | `test: Add MaterialApp test` |
| 54 | Add Login test | Digne | `test: Add login page test` |
| 55 | Add Event test 1-2 | Digne | `test: Add Event entity tests` |
| 56 | Add Event test 3-4 | Digne | `test: Complete Event tests` |
| 57 | Fix test issues | Digne | `fix: Resolve test issues` |
| 58 | Format code | Digne | `style: Format with dart format` |

### **PHASE 11: Documentation** (8 commits, ~5.5 min)

| # | Action | Person | Commit Message |
|---|--------|--------|----------------|
| 59 | README lines 51-150 | Fejiro | `docs: Add features section` |
| 60 | README lines 151-250 | Sougnabe | `docs: Add architecture docs` |
| 61 | README lines 251-350 | Josue | `docs: Add Firebase setup` |
| 62 | README lines 351-450 | Sheryl | `docs: Add install guide` |
| 63 | README lines 451-end | Digne | `docs: Add testing & limits` |
| 64 | QUICK_START.md | Fejiro | `docs: Add quick start guide` |
| 65 | SUBMISSION_CHECKLIST.md | Sheryl | `docs: Add submission checklist` |
| 66 | GIT_COLLABORATION_STRATEGY.md | Digne | `docs: Add Git strategy` |

### **PHASE 12: Platform Config** (8 files, ~5.5 min)

| # | File | Person | Commit Message |
|---|------|--------|----------------|
| 67 | `android/build.gradle.kts` | Fejiro | `chore: Configure Android build` |
| 68 | `android/settings.gradle.kts` | Fejiro | `chore: Configure Android settings` |
| 69 | `android/app/build.gradle.kts` | Sougnabe | `chore: Configure Android app` |
| 70 | `ios/Runner/Info.plist` | Sougnabe | `chore: Configure iOS info` |
| 71 | `ios/Runner/AppDelegate.swift` | Fejiro | `chore: Configure iOS delegate` |
| 72 | `linux/CMakeLists.txt` | Fejiro | `chore: Configure Linux build` |
| 73 | `windows/CMakeLists.txt` | Fejiro | `chore: Configure Windows build` |
| 74 | `macos/Runner/AppDelegate.swift` | Fejiro | `chore: Configure macOS delegate` |

### **PHASE 13: Polish** (16 commits, ~11 min)

| # | Action | Person | Commit Message |
|---|--------|--------|----------------|
| 75 | Fix auth errors | Sougnabe | `fix: Improve auth error handling` |
| 76 | Fix event validation | Josue | `fix: Enhance event validation` |
| 77 | Optimize navigation | Fejiro | `refactor: Optimize navigation` |
| 78 | Fix theme persistence | Sheryl | `fix: Update theme persistence` |
| 79 | Fix analyze warnings | Digne | `fix: Resolve analyze warnings` |
| 80 | Clean auth state | Sougnabe | `refactor: Clean auth state` |
| 81 | Improve event CRUD | Josue | `refactor: Improve event CRUD` |
| 82 | UI consistency | Fejiro | `style: Improve UI consistency` |
| 83 | Optimize preferences | Sheryl | `refactor: Optimize preferences` |
| 84 | Update pubspec.lock | Digne | `chore: Update pubspec.lock` |
| 85 | Review fixes | Sougnabe | `fix: Address code review` |
| 86 | Review fixes | Josue | `fix: Address code review` |
| 87 | Review fixes | Fejiro | `fix: Address code review` |
| 88 | Review fixes | Sheryl | `fix: Address code review` |
| 89 | Review fixes | Digne | `fix: Address code review` |
| 90 | Final polish | All | `chore: Final polish` |

---

## 🔄 WORKFLOW (Each Person)

```powershell
# 1. Check table for YOUR assigned commit number
# 2. Wait for previous person's PR to be merged (watch group chat)
# 3. Pull latest from master
git checkout master
git pull origin master

# 4. Go back to your branch and merge master
git checkout <your-branch>
git merge master

# 5. Add your file
git add <file-from-table>

# 6. Commit with EXACT message
git commit -m "<exact-message>"

# 7. Push to YOUR branch
git push origin <your-branch>

# 8. Create Pull Request on GitHub:
#    - Title: "Commit #X: <commit-message>"
#    - Description: Brief note about what file was added
#    - Assign to yourself
#    - Request review from next person in line

# 9. Reviewer: Quickly approve the PR (< 30 seconds)
# 10. Author: Merge PR immediately (use "Squash and merge")
# 11. Announce: "Commit #X merged ✅"
# 12. Next person's turn!
```

### **FAST PR REVIEW PROCESS:**
- Reviewer just checks file exists and commit message matches
- Click "Approve" + "Merge pull request" 
- Total time per PR: 30-40 seconds
- Keep it moving fast!

---

## 👥 DISTRIBUTION SUMMARY

| Member | Commits | % | Commit Numbers |
|--------|---------|---|----------------|
| **Sougnabe** | 18 | 20% | 13, 19-21, 29, 31-33, 42-43, 60, 69-70, 75, 80, 85 |
| **Josue** | 18 | 20% | 12, 14, 17-18, 24-25, 30, 34-36, 46-48, 61, 76, 81, 86 |
| **Fejiro** | 18 | 20% | 4, 8-9, 37-41, 44-45, 51, 59, 64, 67-68, 71-74, 77, 82, 87 |
| **Sheryl** | 18 | 20% | 5, 7, 11, 15-16, 22-23, 28, 49-50, 62, 65, 78, 83, 88 |
| **Digne** | 18 | 20% | 1-3, 6, 10, 26-27, 52-58, 63, 66, 79, 84, 89 |
| **TOTAL** | **90** | **100%** | - |

---

## 📁 FILES BY BRANCH/OWNER

### **Branch: sougnabe-contributions** (18 files)
```
lib/domain/repositories/auth_repository.dart
lib/data/datasources/firebase_auth_service.dart
lib/data/datasources/auth_service.dart
lib/data/datasources/google_auth_datasource.dart
lib/data/repositories/auth_repository_impl.dart
lib/presentation/bloc/auth/auth_event.dart
lib/presentation/bloc/auth/auth_state.dart
lib/presentation/bloc/auth/auth_bloc.dart
lib/presentation/pages/login_page.dart
lib/presentation/pages/register_page.dart
README.md (lines 151-250 - architecture section)
android/app/build.gradle.kts
ios/Runner/Info.plist
[3 bug fix commits on various auth files]
```

### **Branch: josue-contributions** (18 files)
```
lib/domain/entities/event_entity.dart
lib/domain/repositories/event_repository.dart
lib/data/models/event_model.dart
lib/data/models/event.dart
lib/data/datasources/firestore_event_datasource.dart
lib/data/datasources/event_service.dart
lib/data/repositories/event_repository_impl.dart
lib/presentation/bloc/event/event_event.dart
lib/presentation/bloc/event/event_state.dart
lib/presentation/bloc/event/event_bloc.dart
lib/presentation/pages/events_page.dart
lib/presentation/pages/event_details_page.dart
lib/presentation/pages/create_event_page.dart
README.md (lines 251-350 - Firebase setup section)
[3 bug fix commits on various event files]
```

### **Branch: fejiro-contributions** (18 files)
```
lib/core/constants/app_colors.dart
web/index.html
web/manifest.json
lib/presentation/widgets/custom_footer.dart
lib/presentation/widgets/stats_card.dart
lib/presentation/widgets/event_card.dart
lib/presentation/widgets/custom_navbar.dart
lib/presentation/widgets/main_app_shell.dart
lib/presentation/pages/home_page.dart
lib/presentation/pages/dashboard_page.dart
lib/main.dart
README.md (lines 51-150 - features section)
QUICK_START.md
android/build.gradle.kts
android/settings.gradle.kts
ios/Runner/AppDelegate.swift
linux/CMakeLists.txt
windows/CMakeLists.txt
macos/Runner/AppDelegate.swift
[3 bug fix commits on various UI files]
```

### **Branch: sheryl-contributions** (18 files)
```
lib/core/services/preferences_service.dart
android/gradle.properties
lib/domain/entities/user_entity.dart
lib/data/models/user_model.dart
lib/data/models/user.dart
lib/data/datasources/firestore_user_datasource.dart
lib/data/datasources/user_profile_service.dart
lib/data/datasources/imagekit_service.dart
lib/presentation/pages/profile_page.dart
lib/presentation/pages/settings_page.dart
README.md (lines 351-450 - installation section)
SUBMISSION_CHECKLIST.md
[3 bug fix commits on settings/profile files]
```

### **Branch: digne-contributions** (18 files)
```
pubspec.yaml
analysis_options.yaml
lib/firebase_options.dart
README.md (lines 1-50 - overview section)
.gitignore
lib/data/datasources/backend_service.dart
lib/data/datasources/local_storage_service.dart
test/widget_test.dart (6 separate commits for tests)
README.md (lines 451-end - testing & limitations)
GIT_COLLABORATION_STRATEGY.md
[3 bug fix commits on various files]
```

---

## ⏱️ TIMELINE

- **Minutes 0-5:** Setup (clone, copy files, create branches)
- **Minutes 5-50:** Commits 1-51 (implementation, ~55 sec each with PR)
- **Minutes 50-58:** Commits 52-84 (tests, docs, config, ~15 sec each)
- **Minutes 58-60:** Commits 85-90 (final polish, very fast)

---

## ✅ VERIFICATION

```powershell
# After all 90 commits, check on master branch:
git checkout master
git pull origin master
git shortlog -sn --all

# Expected:
#   18  Sougnabe
#   18  Josue
#   18  Fejiro
#   18  Sheryl
#   18  Digne

# Check total PRs (should be 90):
# Go to GitHub → Pull Requests → Closed
# Count should show 90 merged PRs
```

---

## 📊 FOR PDF REPORT

```
TEAM CONTRIBUTIONS

Name      | Commits | %     | Responsibilities
----------|---------|-------|------------------
Sougnabe  | 18      | 20.0% | Auth, Auth BLoC, Login/Register
Josue     | 18      | 20.0% | Events, Event BLoC, CRUD, RSVP
Fejiro    | 18      | 20.0% | Dashboard, Widgets, Navigation
Sheryl    | 18      | 20.0% | Profile, Settings, Preferences
Digne     | 18      | 20.0% | Testing, Docs, Quality
----------|---------|-------|------------------
TOTAL     | 90      | 100%  | Perfect balance ✅
```

---

## ⚠️ CRITICAL RULES

1. **BRANCHES** - Each person works on their own branch only
2. **PULL REQUESTS** - Every commit = 1 PR (90 PRs total)
3. **SEQUENTIAL** - Wait for previous PR to be merged before starting yours
4. **FAST REVIEWS** - Approve + merge in < 40 seconds
5. **EXACT ORDER** - Follow commit numbers strictly
6. **EXACT MESSAGES** - Copy commit messages exactly
7. **ANNOUNCE** - Say "PR #X merged ✅" after each merge
8. **WHOLE FILES** - Commit complete files, not partials

---

## 💡 TIPS

- **Two screens:** One for coding, one for GitHub PR page
- **Pre-stage files:** `git add` while waiting for previous PR
- **Fast reviews:** Just check file exists + message matches, then approve
- **README splits:** Person can edit specific line ranges
- **Group chat:** Essential for coordination ("PR #X merged ✅")
- **Keep moving:** Don't overthink reviews, trust your teammates
- **Person #1 (Digne):** Start immediately after setup
- **Stay focused:** 60 minutes goes very fast with PRs!

---

**READY? SET TIMER! GO! ⏱️**
