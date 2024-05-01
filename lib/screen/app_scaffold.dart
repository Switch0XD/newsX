// import 'package:darya/services/titlecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// import 'package:flutter/foundation.dart'
//     show defaultTargetPlatform, TargetPlatform;

class AppScaffold extends ConsumerWidget {
  const AppScaffold({
    super.key,
    required this.currentPath,
    required this.body,
    this.secondaryBody,
    this.mobileNavs = 3,
    // required this.navList,
  });

  final Widget body;
  final String currentPath;
  final Widget? secondaryBody;
  // final int selectedIndex;
  final int mobileNavs;
  // final List<Map<String, dynamic>> navList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final customClaim = ref.watch(customClaimsProvider);
    // final userPermissions = customClaim.value ?? {};
    List<Map<String, dynamic>> navList = [];
    // if (userPermissions.containsKey('dashboard')) {
    navList.add({
      'icon': const Icon(Icons.dashboard_outlined),
      'selectedIcon': const Icon(Icons.dashboard),
      'label': 'Dashboard',
      'path': '/',
    });
    // }

    // if (userPermissions.containsKey('sms')) {
    //   navList.add({
    //     'icon': const Icon(Icons.security_outlined),
    //     'selectedIcon': const Icon(Icons.security),
    //     'label': 'SMS',
    //     'path': '/sms',
    //   });
    // }
    // if (userPermissions.containsKey('certificates')) {
    //   navList.add({
    //     'icon': const Icon(Icons.edit_document),
    //     'selectedIcon': const Icon(Icons.edit_document),
    //     'label': 'Certificates',
    //     'path': '/certificates',
    //   });
    // }
    // if (userPermissions.containsKey('hsseq')) {
    //   navList.add({
    //     'icon': const Icon(Icons.health_and_safety_outlined),
    //     'selectedIcon': const Icon(Icons.health_and_safety),
    //     'label': 'HSSEQ',
    //     'path': '/hsseq',
    //   });
    // }
    // if (userPermissions.containsKey('reporting')) {
    //   navList.add({
    //     'icon': const Icon(Icons.calendar_month_outlined),
    //     'selectedIcon': const Icon(Icons.calendar_month),
    //     'label': 'Reporting',
    //     'path': '/reporting',
    //   });
    // }
    // if (userPermissions.containsKey('pms')) {
    //   navList.add({
    //     'icon': const Icon(Icons.schedule_outlined),
    //     'selectedIcon': const Icon(Icons.schedule),
    //     'label': 'PMS',
    //     'path': '/pms',
    //   });
    // }
    // if (userPermissions.containsKey('inventory')) {
    //   navList.add({
    //     'icon': const Icon(Icons.inventory_outlined),
    //     'selectedIcon': const Icon(Icons.inventory),
    //     'label': 'Inventory',
    //     'path': '/inventory',
    //   });
    // }

    // if (userPermissions['name'] == 'developer') {
    //   navList.add({
    //     'icon': const Icon(Icons.dashboard_outlined),
    //     'selectedIcon': const Icon(Icons.dashboard),
    //     'label': 'Procurement',
    //     'path': '/procurement',
    //   });
    // }
    // if (userPermissions['email'] == 'voyagexdemo@daryashipping.in') {
    //   navList.add({
    //     'icon': const Icon(Icons.dashboard_outlined),
    //     'selectedIcon': const Icon(Icons.dashboard),
    //     'label': 'Procurement',
    //     'path': '/procurement',
    //   });
    // }

    // if (userPermissions.containsKey('budget')) {
    //   navList.add({
    //     'icon': const Icon(Icons.account_balance_outlined),
    //     'selectedIcon': const Icon(Icons.account_balance),
    //     'label': 'Budget',
    //     'path': '/budget',
    //   });
    // }
    // if (userPermissions.containsKey('vps')) {
    //   navList.add({
    //     'icon': const Icon(Icons.directions_boat_filled_outlined),
    //     'selectedIcon': const Icon(Icons.directions_boat_filled),
    //     'label': 'VPS',
    //     'path': '/vps',
    //   });
    // }
    // if (userPermissions.containsKey('cms')) {
    //   navList.add({
    //     'icon': const Icon(Icons.account_circle_outlined),
    //     'selectedIcon': const Icon(Icons.account_circle),
    //     'label': 'CMS',
    //     'path': '/cms',
    //   });
    // }
    // if (userPermissions.containsKey('sst')) {
    //   navList.add({
    //     'icon': const Icon(Icons.apartment_outlined),
    //     'selectedIcon': const Icon(Icons.apartment),
    //     'label': 'SST',
    //     'path': '/sst',
    //   });
    // }
    // if (userPermissions.containsKey('gps')) {
    //   navList.add({
    //     'icon': const Icon(Icons.gps_fixed_outlined),
    //     'selectedIcon': const Icon(Icons.gps_fixed),
    //     'label': 'GPS',
    //     'path': '/gps',
    //   });
    // }
    // if (userPermissions.containsKey('gps')) {
    //   navList.add({
    //     'icon': const Icon(Icons.folder),
    //     'selectedIcon': const Icon(Icons.folder),
    //     'label': 'Forms',
    //     'path': '/seafarer_application',
    //   });
    // }

    navList.add({
      'icon': const Icon(Icons.logout_outlined),
      'selectedIcon': const Icon(Icons.logout),
      'label': 'Logout',
      'path': '/logout',
    });

    int index = navList.indexWhere(
      (e) => e['path'] != '/' && currentPath.startsWith(e['path']),
    );
    int selectedIndex = index == -1 ? 0 : index;
    // print('selectedIndex: $selectedIndex');

    return AdaptiveLayout(
      primaryNavigation: SlotLayout(
        config: <Breakpoint, SlotLayoutConfig>{
          Breakpoints.mediumAndUp: SlotLayout.from(
            // inAnimation: AdaptiveScaffold.leftOutIn,
            key: const Key('Primary Navigation Medium'),
            builder: (_) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AdaptiveScaffold.standardNavigationRail(
                  extended: false,
                  width: 96,
                  labelType: NavigationRailLabelType.all,
                  leading: Column(
                    children: [
                      FirebaseAuth.instance.currentUser?.uid !=
                              'NhTW9DlbSrS2SfdzOmQ7ACQ8o3x2'
                          ? Image.asset(
                              'assets/images/logo.png',
                              height: 32,
                              width: 32,
                            )
                          : Image.asset(
                              'assets/images/1.png',
                              height: 48,
                              width: 48,
                            ),
                      Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FirebaseAuth.instance.currentUser?.uid !=
                                    'NhTW9DlbSrS2SfdzOmQ7ACQ8o3x2'
                                ? const Text('DARYA')
                                : const Text('VoyageX AI'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Expanded(
                    child: Column(
                      children: [
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('v2.0.0.17',
                              style: Theme.of(context).textTheme.bodySmall),
                        ),
                      ],
                    ),
                  ),
                  destinations: [
                    ...navList.map(
                      (e) => NavigationRailDestination(
                        icon: e['icon'],
                        selectedIcon: e['selectedIcon'],
                        label: Text(
                          e['label'],
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) {
                    if (navList[index]['path'] == '/logout') {
                      FirebaseAuth.instance.signOut();
                      // ref.read(selectedCompanyProvider.notifier).state = {};
                      // ref.read(selectedVesselProvider.notifier).state = '';

                      return;
                    }

                    GoRouter.of(context).go(navList[index]['path'] ?? '/');
                  },
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  padding: const EdgeInsets.all(0),
                ),
                const VerticalDivider(
                  width: 1,
                ),
              ],
            ),
          ),
        },
      ),
      body: SlotLayout(
        config: <Breakpoint, SlotLayoutConfig>{
          Breakpoints.smallAndUp: SlotLayout.from(
            key: const Key('Body All'),
            builder: (_) => body,
          ),
        },
      ),
      bottomNavigation: SlotLayout(
        config: <Breakpoint, SlotLayoutConfig>{
          Breakpoints.small: SlotLayout.from(
            key: const Key('Bottom Navigation Small'),
            builder: (_) => AdaptiveScaffold.standardBottomNavigationBar(
              destinations: [
                ...navList.take(mobileNavs).map(
                      (e) => NavigationDestination(
                        icon: e['icon'],
                        selectedIcon: e['selectedIcon'],
                        label: e['label'],
                      ),
                    ),
                if (navList.length > mobileNavs)
                  const NavigationDestination(
                    icon: Icon(Icons.more_horiz_outlined),
                    selectedIcon: Icon(Icons.more_horiz),
                    label: 'More',
                  ),
              ],
              currentIndex:
                  selectedIndex >= mobileNavs ? mobileNavs : selectedIndex,
              onDestinationSelected: (index) {
                if (index == mobileNavs) {
                  // String selected = '';
                  showModalBottomSheet(
                    showDragHandle: true,
                    enableDrag: true,
                    isScrollControlled: true,
                    useRootNavigator: true,
                    context: context,
                    builder: (BuildContext context) {
                      return LayoutBuilder(builder: (context, constraints) {
                        final maxHeight =
                            MediaQuery.of(context).size.height * 0.9;
                        return ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight:
                                maxHeight, // Set maximum height to 90% of screen height
                          ),
                          child: ListView(
                            shrinkWrap: true,
                            children: navList.skip(mobileNavs).map((e) {
                              return ListTile(
                                selected:
                                    e['path'] == navList[selectedIndex]['path'],
                                title: Text(e['label']),
                                leading: e['icon'],
                                onTap: () {
                                  if (e['path'] == '/logout') {
                                    // pop up message to confirm logout

                                    Dialog(
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text('Logout'),
                                            const Divider(),
                                            const Text(
                                                'Are you sure you want to logout?'),
                                            const SizedBox(height: 16),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    FirebaseAuth.instance
                                                        .signOut();
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Logout'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );

                                    // FirebaseAuth.instance.signOut();
                                  }
                                  Navigator.pop(context);
                                  GoRouter.of(context).go(e['path']);
                                },
                              );
                            }).toList(),
                          ),
                        );
                      });
                    },
                  );
                } else {
                  GoRouter.of(context).go(navList[index]['path'] ?? '/');
                }
              },
            ),
          )
        },
      ),
    );
  }
}
