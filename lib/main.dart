import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'pages/home_page.dart';
import 'providers/donor_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/organization_provider.dart';
import 'providers/user_provider.dart';
import 'pages/donate_page.dart';

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
        ChangeNotifierProvider(create: ((context) => OrganizationProvider())),
        ChangeNotifierProvider(create: ((context) => DonorProvider())),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SimpleTodo',
      initialRoute: '/',
      routes: {
      '/': (context) => const HomePage(),
      },
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == '/donate') {
          return MaterialPageRoute(
            builder: (context) => DonatePage(organizationName: settings.arguments as String),
          );
        }
        return null;
      },
      
      theme: ThemeData.dark(), // Set the theme to dark theme
    );
  }
}
