// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:football_app/firebase_options.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDdrWwhXRhOCj4_K5lVxdDgMOULCDIQOuc",
          authDomain: "fluttscore.firebaseapp.com",
          projectId: "fluttscore",
          storageBucket: "fluttscore.appspot.com",
          messagingSenderId: "115803564064",
          appId: "1:115803564064:web:733dc412522ad8e2ee7445"),
    );
  } else if (Platform.isAndroid) {
    await Firebase.initializeApp();
  } else if (Platform.isIOS) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(const MyApp());
}
