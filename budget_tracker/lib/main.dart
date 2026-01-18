import 'package:budget_tracker/controllers/dashboard_provider.dart';
import 'package:budget_tracker/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

import 'pages/get_started_page.dart';
import 'services/local_cache_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalCacheService.init();

  runApp(const _App());
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return Phoenix(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => DashboardProvider()),
        ],
        builder: (context, child) => MaterialApp(
          title: 'Expense Tracker',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.light(primary: Color(0xffabe27c)),
            appBarTheme: AppBarTheme(
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor: Color(0xff141b24),
              foregroundColor: Colors.white,
            ),
            scaffoldBackgroundColor: Color(0xff141b24),
          ),
          home: LocalCacheService.getString('authToken') != null
              ? HomePage()
              : GetStartedPage(),
        ),
      ),
    );
  }
}
