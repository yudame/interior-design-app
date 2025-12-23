import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/connectivity/connectivity_bloc.dart';
import 'core/connectivity/connectivity_service.dart';
import 'core/di/injection.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  // Initialize dependencies
  await configureDependencies();

  // TODO: Initialize Firebase
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // TODO: Initialize Hive for local storage
  // await Hive.initFlutter();

  runApp(const InteriorDesignApp());
}

class InteriorDesignApp extends StatelessWidget {
  const InteriorDesignApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ConnectivityBloc(
            ConnectivityService(),
          )..add(const ConnectivityEvent.started()),
        ),
        // TODO: Add AuthBloc
        // BlocProvider(
        //   create: (context) => getIt<AuthBloc>()..add(const AuthEvent.checkStatus()),
        // ),
      ],
      child: MaterialApp.router(
        title: 'Interior Design',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
