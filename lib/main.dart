import 'dart:ui';
import 'package:wikianesthesia_mobile/Calculators/Drugs/drug_calcs.dart';
import 'package:wikianesthesia_mobile/Calculators/calculator_home.dart';
import 'package:wikianesthesia_mobile/Calculators/checklists.dart';
import 'package:wikianesthesia_mobile/Calculators/fluids.dart';
import 'package:wikianesthesia_mobile/Calculators/insulin.dart';
import 'package:wikianesthesia_mobile/Calculators/patient_widget.dart';
import 'package:wikianesthesia_mobile/Calculators/pump_cases.dart';
import 'package:wikianesthesia_mobile/Directory/directory_codes.dart';
//import 'package:wikianesthesia_mobile/Directory/directory_home.dart';
import 'package:wikianesthesia_mobile/Directory/directory_phone.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';

import 'package:wikianesthesia_mobile/EmergencyManual/emergency_home.dart';
import 'package:wikianesthesia_mobile/Home/wiki_api.dart';
import 'package:wikianesthesia_mobile/Wiki/account_page.dart';
import 'package:wikianesthesia_mobile/Wiki/login_page.dart';
import 'package:wikianesthesia_mobile/Wiki/logout_page.dart';
import 'package:wikianesthesia_mobile/Wiki/practicegroup_home.dart';
import 'package:wikianesthesia_mobile/Wiki/practicegroup_page.dart';
import 'package:wikianesthesia_mobile/Wiki/wiki_page.dart';
import 'package:wikianesthesia_mobile/util.dart';
//import 'package:worker_manager/worker_manager.dart';
import './EmergencyManual/emergency_page.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'Home/home_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'Home');
final _emergencyNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'Emergency');
final _calculatorNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'Calculator');
final _accountNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'Account');
final _practicegroupNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'PracticeGroup');

class MyScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  routes: [
    StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: '/',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: HomeScreen()),
                routes: [
                  GoRoute(
                    path: 'about',
                    builder: (context, state) => const Placeholder(),
                  ),
                  GoRoute(
                    name: 'wikipage',
                    path: 'wikipage/:url',
                    builder: (context, state) =>
                        WikiPage(url: state.pathParameters['url']!),
                  ),
                ],
              )
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _emergencyNavigatorKey,
            routes: [
              GoRoute(
                path: '/emergency',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: EmergencyHome()),
                routes: [
                  GoRoute(
                    name: 'emergencypage',
                    path: 'emergencypage/:pageTitle',
                    builder: (context, state) => EmergencyPage(
                        pageTitle: state.pathParameters['pageTitle']!),
                  )
                ],
              )
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _calculatorNavigatorKey,
            routes: [
              GoRoute(
                path: '/calculator',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: CalculatorHome()),
                routes: [
                  GoRoute(
                    path: 'bodycomp',
                    builder: (context, state) => const DemographicsPage(),
                  ),
                  GoRoute(
                    path: 'equipment',
                    builder: (context, state) => const EquipmentPage(),
                  ),
                  GoRoute(
                    path: 'fluids',
                    builder: (context, state) => const FluidsPage(),
                  ),
                  GoRoute(
                    path: 'insulin',
                    builder: (context, state) => const InsulinPage(),
                  ),
                  GoRoute(
                    path: 'ca1',
                    builder: (context, state) => const CA1Guide(),
                  ),
                  GoRoute(
                    path: 'pump',
                    builder: (context, state) => const PumpCaseGuide(),
                  ),
                  GoRoute(
                    path: 'drugs',
                    builder: (context, state) => const DrugsPage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _accountNavigatorKey,
            routes: [
              GoRoute(
                  path: '/account',
                  builder: (context, state) => const AccountHome(),
                  routes: [
                    GoRoute(
                      path: 'login',
                      builder: (context, state) => const LoginPage(),
                    ),
                    GoRoute(
                      path: 'logout',
                      builder: (context, state) => const LogoutPage(),
                    ),
                  ]),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _practicegroupNavigatorKey,
            routes: [
              GoRoute(
                path: '/practicegroup',
                builder: (context, state) => const PracticeGroupHome(),
                routes: [
                  GoRoute(
                    name: 'practicegrouppage',
                    path: 'practicegrouppage/:dbKey/:shortName/:fullName',
                    builder: (context, state) => PracticeGroupPage(
                        dbkey: state.pathParameters['dbKey']!,
                        shortname: state.pathParameters['shortName']!,
                        fullname: state.pathParameters['fullName']!),
                  ),
                  GoRoute(
                    path: 'codes',
                    builder: (context, state) => const CodesPage(),
                  ),
                  GoRoute(
                    path: 'phone',
                    builder: (context, state) => const PhonePage(),
                  ),
                ],
              ),
            ],
          )
        ])
  ],
);

// Initialize the WikiAPI instance
final WikiAPI wikiAPI = WikiAPI();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await workerManager.init();
  await wikiAPI.initialize();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  /// Defines the Hopkins Anesthesia App theme data and home page.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp.router(
        scrollBehavior: MyScrollBehavior(),
        routerConfig: _router,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: primaryColor,
              dynamicSchemeVariant: DynamicSchemeVariant.fidelity),
        ),
      ),
    );
  }
}

class ScaffoldWithNestedNavigation extends ConsumerWidget {
  /// Creates a bottom navigation bar to switch between the 4 main modes of the app (Home, Emergency Manual, Calculators, and Directory)

  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(
            key: key ?? const ValueKey<String>('ScaffoldWithNestedNavigation'));

  /// GoRouter Navigation Shell
  final StatefulNavigationShell navigationShell;

  static List<Widget> destinations = const <Widget>[
    NavigationDestination(
      selectedIcon: ImageIcon(  
        AssetImage('assets/wikianesthesia_logo.png'),
        color: Colors.white,
        size: 30.0,
        ),
      icon: ImageIcon(  
        AssetImage('assets/wikianesthesia_logo.png'),
        color: Colors.black,
        size: 30.0,
        ),
      label: 'Home',
    ),
    NavigationDestination(
      selectedIcon: Icon(
        Icons.emergency,
        color: Colors.white,
      ),
      icon: Icon(Icons.emergency_outlined),
      label: 'Emergency',
    ),
    NavigationDestination(
      selectedIcon: Icon(
        Icons.construction,
        color: Colors.white,
      ),
      icon: Icon(Icons.construction_outlined),
      label: 'Tools',
    ),
    NavigationDestination(
      selectedIcon: Icon(
        Icons.person,
        color: Colors.white,
      ),
      icon: Icon(Icons.person_outlined),
      label: 'Account',
    ),
    NavigationDestination(
      selectedIcon: Icon(
        Icons.group,
        color: Colors.white,
      ),
      icon: Icon(Icons.group_outlined),
      label: 'Group',
    ),
  ];

  static List<NavigationRailDestination> railDestinations =
      const <NavigationRailDestination>[
    NavigationRailDestination(
      selectedIcon: Icon(
        Icons.home,
        color: Colors.white,
      ),
      icon: Icon(Icons.home_outlined),
      label: Text('Home'),
    ),
    NavigationRailDestination(
      selectedIcon: Icon(
        Icons.emergency,
        color: Colors.white,
      ),
      icon: Icon(Icons.emergency_outlined),
      label: Text('Emergency'),
    ),
    NavigationRailDestination(
      selectedIcon: Icon(
        Icons.construction,
        color: Colors.white,
      ),
      icon: Icon(Icons.construction_outlined),
      label: Text('Tools'),
    ),
    NavigationRailDestination(
      selectedIcon: Icon(
        Icons.person,
        color: Colors.white,
      ),
      icon: Icon(Icons.person_outlined),
      label: Text('Account'),
    ),
    NavigationRailDestination(
      selectedIcon: Icon(
        Icons.group,
        color: Colors.white,
      ),
      icon: Icon(Icons.group_outlined),
      label: Text('Group'),
    )
  ];

  void _gobranch(int index) {
    /// Defines which main page to set the app to

    // Use initialLocation to support going back to the original page by tapping
    // the navigation bar item that is already active
    navigationShell.goBranch(index,
        initialLocation: index == navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<List<String>> practiceGroups = ref.watch(wikiPracticeGroupsProvider);

    bool hasPracticeGroups = practiceGroups.isNotEmpty;

    /// Builds the bottom navigation bar
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 600) {
        return scaffoldWithNavBar(hasPracticeGroups);
      } else {
        return scaffoldWithNavRail(hasPracticeGroups);
      }
    });
  }

  Scaffold scaffoldWithNavBar(bool hasPracticeGroups) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _gobranch,
        indicatorColor: primaryColor,
        selectedIndex: navigationShell.currentIndex,
        destinations:
            hasPracticeGroups ? destinations : destinations.sublist(0, 4),
      ),
      body: navigationShell,
    );
  }

  Scaffold scaffoldWithNavRail(bool hasPracticeGroups) {
    return Scaffold(
        body: Row(
      children: [
        NavigationRail(
          destinations: hasPracticeGroups
              ? railDestinations
              : railDestinations.sublist(0, 4),
          selectedIndex: navigationShell.currentIndex,
          indicatorColor: primaryColor,
          onDestinationSelected: _gobranch,
          labelType: NavigationRailLabelType.all,
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(child: navigationShell)
      ],
    ));
  }
}
