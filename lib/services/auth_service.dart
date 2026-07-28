import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants.dart';
import '../models/app_user.dart';

/// Handles account creation, login, and the current-user stream.
///
/// This is the only file that should call `FirebaseAuth` directly — swap
/// this implementation if you move to a different auth provider (e.g.
/// Supabase Auth) without touching any screen.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Emits the current signed-in user's Firebase Auth object, or null.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  /// Creates a Firebase Auth account, then creates the matching
  /// `users/{uid}` Firestore document that stores username + ForgePoint total.
  Future<AppUser> register({
    required String email,
    required String password,
    required String username,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = credential.user!.uid;

    final newUser = AppUser(
      uid: uid,
      username: username,
      email: email,
      forgePoints: 0,
      createdAt: DateTime.now(),
    );

    await _db
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .set(newUser.toMap());

    return newUser;
  }

  Future<void> login({required String email, required String password}) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout() => _auth.signOut();

  /// Fetches the Firestore profile document for a given uid.
  Future<AppUser?> fetchUserProfile(String uid) async {
    final doc =
        await _db.collection(AppConstants.usersCollection).doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromMap(uid, doc.data()!);
  }
}
