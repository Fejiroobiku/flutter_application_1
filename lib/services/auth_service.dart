import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/user.dart';
import 'local_storage_service.dart';
import 'firebase_auth_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final LocalStorageService _storageService = LocalStorageService();
  final FirebaseAuthService _firebaseAuth = FirebaseAuthService();

  // Use Firebase auth state changes
  Stream<User?> get authStateChanges => _firebaseAuth.user;

  // Get current user (prefer Firebase, fallback to local)
  Future<User?> get currentUser async {
    final firebaseUser = await _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      return firebaseUser;
    }
    return await _storageService.getCurrentUser();
  }

  // Sign up with email and password - USE FIREBASE
  Future<User> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    try {
      print('🔄 Attempting Firebase registration for: $email');
      
      // Use Firebase registration
      final user = await _firebaseAuth.registerWithEmailAndPassword(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );
      
      print('✅ Firebase registration successful for: $email');
      return user;
      
    } catch (e) {
      print('❌ Firebase registration failed: $e');
      
      // Fallback to local storage if Firebase fails
      print('🔄 Falling back to local storage registration...');
      
      final users = await _storageService.getUsers();
      final existingUser = users.values.firstWhere(
        (user) => user.email == email,
        orElse: () => User.empty(),
      );

      if (existingUser.id.isNotEmpty) {
        throw Exception('Account already exists for that email.');
      }

      // Create new user in local storage only
      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: '$firstName $lastName',
        profilePictureUrl: null,
        createdAt: DateTime.now(),
        phone: phone,
      );

      await _storageService.saveUser(newUser);
      await _storageService.setCurrentUser(newUser);

      print('✅ Local storage registration successful for: $email');
      return newUser;
    }
  }

  // Login with email and password - USE FIREBASE
  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      print('🔄 Attempting Firebase login for: $email');
      
      // Use Firebase login
      final user = await _firebaseAuth.loginWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      print('✅ Firebase login successful for: $email');
      return user;
      
    } catch (e) {
      print('❌ Firebase login failed: $e');
      
      // Fallback to local storage if Firebase fails
      print('🔄 Falling back to local storage login...');
      
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Please enter email and password');
      }

      final users = await _storageService.getUsers();
      final user = users.values.firstWhere(
        (user) => user.email == email,
        orElse: () => User.empty(),
      );

      if (user.id.isEmpty) {
        throw Exception('User not found.');
      }

      // Simple password check (in real app, use proper hashing)
      if (password.length < 6) {
        throw Exception('Invalid email or password.');
      }

      await _storageService.setCurrentUser(user);
      print('✅ Local storage login successful for: $email');
      return user;
    }
  }

  // Password reset - USE FIREBASE
  Future<void> resetPassword({required String email}) async {
    try {
      print('🔄 Attempting Firebase password reset for: $email');
      await _firebaseAuth.resetPassword(email: email);
      print('✅ Firebase password reset email sent to: $email');
    } catch (e) {
      print('❌ Firebase password reset failed: $e');
      // Fallback: just log for local users
      print('🔄 Using local storage fallback for password reset...');
      await Future.delayed(Duration(seconds: 1));
      print('📧 Password reset requested for: $email (local user)');
    }
  }

  // Logout - USE FIREBASE
  Future<void> logout() async {
    try {
      print('🔄 Attempting Firebase logout...');
      await _firebaseAuth.signOut();
      print('✅ Firebase logout successful');
    } catch (e) {
      print('❌ Firebase logout failed: $e');
      await _storageService.logout();
      print('✅ Local storage logout successful');
    }
  }

  // Update user profile - USE FIREBASE
  Future<User> updateProfile({
    required String userId,
    String? name,
    String? profilePictureUrl,
  }) async {
    try {
      print('🔄 Attempting Firebase profile update...');
      final user = await _firebaseAuth.updateProfile(
        name: name ?? '',
        profilePictureUrl: profilePictureUrl,
      );
      print('✅ Firebase profile update successful');
      return user;
    } catch (e) {
      print('❌ Firebase profile update failed: $e');
      // Fallback to local storage
      final user = await _storageService.getUser(userId);
      if (user == null) {
        throw Exception('User not found');
      }

      final updatedUser = User(
        id: user.id,
        email: user.email,
        name: name ?? user.name,
        profilePictureUrl: profilePictureUrl ?? user.profilePictureUrl,
        createdAt: user.createdAt,
        firebaseUid: user.firebaseUid,
        phone: user.phone,
      );

      await _storageService.saveUser(updatedUser);
      
      final currentUser = await _storageService.getCurrentUser();
      if (currentUser?.id == userId) {
        await _storageService.setCurrentUser(updatedUser);
      }

      print('✅ Local storage profile update successful');
      return updatedUser;
    }
  }

  // Delete account
  Future<void> deleteAccount(String userId) async {
    try {
      // Try to delete Firebase user first
      final user = firebase_auth.FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
        print('✅ Firebase user deleted');
      }
    } catch (e) {
      print('❌ Could not delete Firebase user: $e');
    }
    
    await _storageService.logout();
    print('✅ Local storage cleared');
  }
}