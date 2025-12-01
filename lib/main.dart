import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:wikianesthesia_mobile/Anticoagulation/ac_home.dart';
import 'package:wikianesthesia_mobile/Anticoagulation/ac_page.dart';
import 'package:wikianesthesia_mobile/Calculators/Drugs/drug_calcs.dart';
import 'package:wikianesthesia_mobile/Calculators/calc_page.dart';
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
import 'package:wikianesthesia_mobile/Pacemaker/ep_home.dart';
import 'package:wikianesthesia_mobile/Pacemaker/ep_magnet_device.dart';
import 'package:wikianesthesia_mobile/Pacemaker/ep_magnet_menu.dart';
import 'package:wikianesthesia_mobile/Pacemaker/ep_magnet_page.dart';
import 'package:wikianesthesia_mobile/Wiki/account_home.dart';
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
                    name: 'wikipage',
                    path: 'wikipage/:url',
                    builder: (context, state) =>
                        WikiPage(url: state.pathParameters['url']!),
                  ),
                  GoRoute(
                    path: '/ep',
                    pageBuilder: (context, state) =>
                        const NoTransitionPage(child: EPHome()),
                    routes: [
                      GoRoute(
                        name: 'magnet',
                        path: 'magnet',
                        builder:(context, state) => const EPMagnetMenu(),
                        routes: [
                          GoRoute(
                            name: 'epmagnetdevice',
                            path: ':device',
                            builder: (context, state) => EPMagnetDevice(
                                device: state.pathParameters['device']!),
                            routes: [
                              GoRoute(
                                name: 'epmagnetpage',
                                path: ':manufacturer',
                                builder: (context, state) => EPMagnetPage(
                                    device: state.pathParameters['device']!,
                                    manufacturer:
                                        state.pathParameters['manufacturer']!),
                              ),
                            ]
                          ),
                        ]
                      ),
                    ]
                  ),
                  GoRoute(
                    path: '/calculator',
                    pageBuilder: (context, state) =>
                        const NoTransitionPage(child: CalculatorHome()),
                    routes: [
                      GoRoute(
                        name: 'calcpage',
                        path: 'calcpage/:url',
                        builder: (context, state) =>
                            CalcPage(calcName: state.pathParameters['url']!),
                      ),
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
                  GoRoute(
                    path: '/anticoagulation',
                    pageBuilder: (context, state) =>
                        const NoTransitionPage(child: ACHome()),
                    routes: [
                      GoRoute(
                        name: 'acpage',
                        path: 'acpage/:drug',
                        builder: (context, state) =>
                            ACPage(drugName: state.pathParameters['drug']!),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: '/account',
                    pageBuilder: (context, state) => const NoTransitionPage(child:AccountHome()),
                    routes: [
                      GoRoute(
                        name: 'accountpage',
                        path: 'accountpage/:url',
                        builder: (context, state) =>
                            WikiPage(url: state.pathParameters['url']!),
                      ),
                      GoRoute(
                        path: 'login',
                        builder: (context, state) => const LoginPage(),
                      ),
                      GoRoute(
                        path: 'logout',
                        builder: (context, state) => const LogoutPage(),
                      ),
                    ]
                  ),
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
              ),
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
        Icons.calculate,
        color: Colors.white,
      ),
      icon: Icon(Icons.calculate_outlined),
      label: 'Calculators',
    ),
    NavigationDestination(
      selectedIcon: Icon(
        Icons.format_color_reset,
        color: Colors.white,
      ),
      icon: Icon(Icons.format_color_reset_outlined),
      label: 'Coags',
    ),
    NavigationDestination(
      selectedIcon: Icon(
        Icons.emergency,
        color: Colors.white,
      ),
      icon: Icon(Icons.emergency_outlined),
      label: 'Emergencies',
    ),
    NavigationDestination(
      selectedIcon: Icon(
        Icons.person,
        color: Colors.white,
      ),
      icon: Icon(Icons.person_outline),
      label: 'Account',
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
        Icons.calculate,
        color: Colors.white,
      ),
      icon: Icon(Icons.calculate_outlined),
      label: Text('Calculators'),
    ),
    NavigationRailDestination(
      selectedIcon: Icon(
        Icons.format_color_reset,
        color: Colors.white,
      ),
      icon: Icon(Icons.format_color_reset_outlined),
      label: Text('Coags'),
    ),
    NavigationRailDestination(
      selectedIcon: Icon(
        Icons.emergency,
        color: Colors.white,
      ),
      icon: Icon(Icons.emergency_outlined),
      label: Text('Emergencies'),
    ),
    NavigationRailDestination(
      selectedIcon: Icon(
        Icons.person,
        color: Colors.white,
      ),
      icon: Icon(Icons.person_outline),
      label: Text('Account'),
    )
  ];

  void _gobranch(int index, BuildContext context) {
    /// Defines which main page to set the app to
    /// 
    // Use initialLocation to support going back to the original page by tapping
    // the navigation bar item that is already active


    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1: 
        context.go('/calculator');
        break;
      case 2:
        context.go('/anticoagulation');
        break;
      case 3:
        context.go('/emergency');
        break;
      case 4:
        context.go('/account');
      default:
        context.go('/');
    }
  }

  int parseLoc(String location) {
    /// Parses the current location string to determine which main page the app is on
    /// return int
    if (kDebugMode) {
      print('Current location: $location');
    }
    if (location.startsWith('/emergency')) {
      return 3;
    } else if (location.startsWith('/calc')) {
      return 1;
    } else if (location.startsWith('/account')) {
      return 4;
    } else if (location.startsWith('/anticoagulation')) {
      return 2;
    } else if (location.startsWith('/ep')) {
      return 1;
    }
    else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Builds the bottom navigation bar
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 600) {
        return scaffoldWithNavBar(context);
      } else {
        return scaffoldWithNavRail(context);
      }
    });
  }

  Scaffold scaffoldWithNavBar(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int idx) {_gobranch(idx, context);},
        indicatorColor: primaryColor,
        selectedIndex: parseLoc(GoRouterState.of(context).uri.toString()),
        destinations:
            destinations,
      ),
      body: Builder(
        builder: (context) => navigationShell,
      ),
    );
  }

  Scaffold scaffoldWithNavRail(BuildContext context) {
    return Scaffold(
        body: Builder(builder: (context) => Row(
      children: [
        NavigationRail(
          destinations: railDestinations,
          selectedIndex: parseLoc(GoRouterState.of(context).uri.toString()),
          indicatorColor: primaryColor,
          onDestinationSelected: (int idx) {_gobranch(idx, context);},
          labelType: NavigationRailLabelType.all,
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(child: navigationShell)
      ],
    )));
  }
}
