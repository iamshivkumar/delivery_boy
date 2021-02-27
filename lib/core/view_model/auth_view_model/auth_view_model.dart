import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthViewModel extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User user = FirebaseAuth.instance.currentUser;
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController smsController = TextEditingController();
  String _verificationId;
  bool loading = false;
  bool phoneLoading = false;
  bool otpSent = false;

  void startPhoneAuth({VoidCallback onVerify}) async {
    phoneLoading = true;
    otpSent = false;
    notifyListeners();
    try {
      var admins = await FirebaseFirestore.instance
          .collection("deliveryBoys")
          .where("mobile", isEqualTo: phoneNumberController.text)
          .get();
      if (admins.docs.isEmpty) {
        Fluttertoast.showToast(msg: "Phone number not registered as delivery boy.");
        phoneLoading = false;
        notifyListeners();
        return;
      }
      await _auth.verifyPhoneNumber(
        phoneNumber: "+91" + phoneNumberController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          loading = true;
          otpSent = false;
          notifyListeners();
          user = (await _auth.signInWithCredential(credential)).user;
          Fluttertoast.showToast(msg: "Login Successful");
          onVerify();
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            Fluttertoast.showToast(
                msg: "The provided phone number is not valid.");
          }
        },
        codeSent: (String verificationId, int resendToken) async {
          Fluttertoast.showToast(msg: "OTP sent");
          otpSent = true;
          phoneLoading = false;
          _verificationId = verificationId;
          notifyListeners();
        },
        timeout: const Duration(seconds: 30),
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          loading = false;
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<User> verifyOtp() async {
    loading = true;
    notifyListeners();
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: smsController.text,
      );
      user = (await _auth.signInWithCredential(credential)).user;
      Fluttertoast.showToast(msg: "Login Successful");
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to sign in: " + e.code.toString());
    }
    loading = false;
    notifyListeners();
    return user;
  }

  Future<void> logout() async {
    await _auth.signOut();
    user = null;
    Fluttertoast.showToast(msg: "Logout Successful");
  }
}
