import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visits_prod/brains/cards_brain.dart';
import 'package:visits_prod/brains/main_brain.dart';
import 'package:visits_prod/brains/templates_brain.dart';
import 'package:visits_prod/brains/user_data.dart';
import 'package:visits_prod/ui_blocs/static_pages/load_page.dart';
import 'package:visits_prod/ui_utils/lib_color_schemes.g.dart';
import 'package:visits_prod/ui_utils/theme_data.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAhjnDk5kiVt85V2GLQXxnN2dBJopwlHXw',
        appId: '1:585517566318:android:07dc3d8c570d18cc1e197f',
        messagingSenderId: '585517566318',
        projectId: 'my-cards-e6faa',
      ),
    );
  } else {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAhjnDk5kiVt85V2GLQXxnN2dBJopwlHXw',
        appId: '1:585517566318:android:07dc3d8c570d18cc1e197f',
        messagingSenderId: '585517566318',
        projectId: 'my-cards-e6faa',
        authDomain: 'react-native-firebase-testing.firebaseapp.com',
        databaseURL: 'https://react-native-firebase-testing.firebaseio.com',
        storageBucket: 'react-native-firebase-testing.appspot.com',
        measurementId: 'G-F79DJ0VFGS',
      ),
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeDataBrain()),
        ChangeNotifierProvider(create: (_) => MainBrain()),
        ChangeNotifierProvider(create: (_) => CardsBrain()),
        ChangeNotifierProvider(
          create: (_) => UserData(),
          lazy: false,
        ),
        ChangeNotifierProvider(create: (_) => TemplatesBrain()),
      ],
      child: Consumer<ThemeDataBrain>(
        builder: (context, ThemeDataBrain themeNotifier, child) {
          return MaterialApp(
            title: 'My Cards',
            theme: themeNotifier.isDark
                ? ThemeData(colorScheme: darkColorScheme)
                : ThemeData(colorScheme: lightColorScheme),
            // home: const MainPage(),
            home: const LoadPage(),
          );
        },
      ),
    );
  }
}
