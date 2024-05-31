import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'pages/home_page.dart';
import 'providers/auth_provider.dart';
import 'providers/donationdrive_provider.dart';
import 'providers/user_provider.dart';
import 'providers/donation_provider.dart';
import 'pages/donor/donate_page.dart';
import 'pages/donor/donate_qr_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => UserAuthProvider())),
        ChangeNotifierProvider(create: ((context) => UserProvider())),
        ChangeNotifierProvider(create: ((context) => DonationProvider())),
        ChangeNotifierProvider(create: ((context) => DonationDriveProvider())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ElGives',
      initialRoute: '/',
      routes: {
      '/': (context) => const HomePage(),
      '/donate_qr': (context) => DonateQrPage(),
      },
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == '/donate') {
          return MaterialPageRoute(
            builder: (context) => DonatePage(donorOrgInfo: settings.arguments as List<String>),
          );
        }
        return null;
      },
      
      theme: ThemeData.dark(), 
    );
  }
}
