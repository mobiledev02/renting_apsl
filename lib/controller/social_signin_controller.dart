// ignore_for_file: unused_element

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '/controller/chat_controller.dart';
import '/utils/custom_extension.dart';
import '../models/user_model.dart';

class SocialLoginService {
  static bool isLoading = false;

  // Fireabse auth instance...
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // User sign-in...
  static Future<User?> signIn(
    SocialLoginType type, {
    UserInfoModel? userInfo,
  }) async {
    try {
      isLoading = true;
      // Authorised user detial...
      User? _authUser;
      switch (type) {
        // Google...
        case SocialLoginType.Google:
          break;

        // Facebook...
        case SocialLoginType.Facebook:
          break;

        // Email-password...
        case SocialLoginType.EmailPassword:
          _authUser = await _signInWithEmailPassword(userInfo);
          break;

        // Anonymously...
        case SocialLoginType.Anonymously:
          break;

        // Twitter...
        case SocialLoginType.Twitter:
          break;

        // Apple Login...
        case SocialLoginType.Apple:
          break;
      }

      isLoading = false;
      return _authUser;
    } catch (e) {
      isLoading = false;
      rethrow;
    }
  }

  // Sign-out user...
  static Future<void> signOut(SocialLoginType type) async {
    switch (type) {
      // Google user...
      case SocialLoginType.Google:
        break;

      // Facebook user...
      case SocialLoginType.Facebook:
        break;

      // Email-password user...
      case SocialLoginType.EmailPassword:
        break;

      // Anonymously logged in user...
      case SocialLoginType.Anonymously:
        break;

      // Twitter user...
      case SocialLoginType.Twitter:
        break;

      // Apple user...
      case SocialLoginType.Apple:
        break;
    }

    // Sign out the current user from firebase user...
    await _auth.signOut();
  }

  // Send forgot password link...
  static Future<void> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  // // SignIn with google...
  // static Future<User> _signInWithGoogle() async {
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

  //   // If user cancel sign-in flow return...
  //   if (googleUser == null) return null;

  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication googleAuth =
  //       await googleUser.authentication;

  //   // Create a new credential
  //   final GoogleAuthCredential credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );

  //   // return firebase authenticated user...
  //   return await _autheticateUserWithFirebaseAuth(credential);
  // }

  // SignIn with email-password...
  static Future<User?> _signInWithEmailPassword(UserInfoModel? userInfo) async {
    if (userInfo == null) return null;

    UserCredential? userCredential;
    User? user;

    try {
      userCredential = await _auth.signInWithEmailAndPassword(
        email: userInfo.email,
        password: userInfo.password,
      );

      user = userCredential.user;
      if (user != null) {
        Get.find<ChatController>()
            .createUser(userInfoModel: user.toUserInfoModel);
      }

      // Authenticate user with firebase...
      return user;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e);
      }

      String title = "Error";
      String msg = "Something went wrong";
      isLoading = false;

      // No user found...
      if (e.code == 'user-not-found') {
        title = "Login Failed";
        msg = 'No user found for that email.';

        // Wrong password...
      } else if (e.code == 'wrong-password') {
        title = "Un-Authorised";
        msg = 'Wrong password provided for that user.';
      }

      // Throw auth exception...
      // throw AppException(
      //   title: title,
      //   message: msg,
      // );

      Get.showSnackbar(
        GetSnackBar(
          message: msg,
          animationDuration: const Duration(seconds: 2),
          duration: const Duration(seconds: 2),
        ),
      );

      rethrow;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      // Throw error...
      // throw AppException(
      //   title: "Error",
      //   message: "Something went wrong",
      // );
      Get.showSnackbar(const GetSnackBar(
        message: "Something went wrong",
        animationDuration: Duration(seconds: 2),
        duration: Duration(seconds: 2),
      ));
      rethrow;
    }
  }

  static Future<User?> registerUsingEmailPassword({
    required UserInfoModel userInfoModel,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: userInfoModel.email,
        password: userInfoModel.password,
      );

      user = userCredential.user;
      await user!.updateDisplayName(userInfoModel.name);
      await user.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        if (kDebugMode) {
          print('The account already exists for that email.');
        }

        Get.showSnackbar(
          const GetSnackBar(
            message: 'The account already exists for that email.',
            animationDuration: Duration(seconds: 2),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return user;
  }

  // Authorise user with firebase authentication...
  static Future<User?> _autheticateUserWithFirebaseAuth(
    AuthCredential? credential,
  ) async {
    if (credential == null) return null;

    UserCredential authResult = await _auth.signInWithCredential(credential);

    User? _user = authResult.user;

    // Check user is not anonymous...
    assert(!(_user?.isAnonymous ?? true));
    assert(await _user?.getIdToken() != null);

    // Cet Current auth user...
    User? currentUser = _auth.currentUser;

    // Check if current user and auth user is same...
    assert(_user?.uid == currentUser?.uid);

    if (kDebugMode) {
      print('User Name: ${_user?.displayName}');
      print("User Email ${_user?.email}");
    }

    return _user;
  }
}

enum SocialLoginType {
  Google,
  Facebook,
  EmailPassword,
  Anonymously,
  Twitter,
  Apple
}
