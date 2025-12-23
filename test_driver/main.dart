import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_driver/driver_extension.dart';

import 'package:interior_design_app/core/connectivity/connectivity_bloc.dart';
import 'package:interior_design_app/core/connectivity/connectivity_service.dart';
import 'package:interior_design_app/core/di/injection.dart';
import 'package:interior_design_app/core/routes/app_router.dart';
import 'package:interior_design_app/core/theme/app_theme.dart';

Future<void> main() async {
  // Enable flutter driver extension first
  enableFlutterDriverExtension();

  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  await configureDependencies();

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
