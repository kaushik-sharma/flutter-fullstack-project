import 'package:budget_tracker/controllers/dashboard_provider.dart';
import 'package:budget_tracker/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

import 'pages/get_started_page.dart';
import 'services/local_cache_service.dart';
import 'values/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalCacheService.init();

  runApp(Phoenix(child: const _App()));
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DashboardProvider()),
      ],
      builder: (context, child) => MaterialApp(
        title: 'Expense Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.light(primary: Constants.primaryColor),
          appBarTheme: AppBarTheme(
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: Constants.backgroundColor,
            foregroundColor: Colors.white,
          ),
          scaffoldBackgroundColor: Constants.backgroundColor,
        ),
        home: LocalCacheService.getString('authToken') != null
            ? HomePage()
            : GetStartedPage(),
      ),
    );
  }
}
