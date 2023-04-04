import 'package:auther/views/screens/HomePage.dart';
import 'package:auther/views/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main () async
{
   WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

    );
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        routes: {
          '/': (context) => const splash_screens(),
          'Homepage' :(context) => const Homepage(),
        },
      ),
    );
}