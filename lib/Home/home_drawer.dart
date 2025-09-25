import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wikianesthesia_mobile/Home/wiki_api.dart';
import 'package:wikianesthesia_mobile/util.dart';

class HomeDrawer extends ConsumerWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Submit Feedback'),
              onTap: () {
                launchURL('https://forms.gle/bNxaLbs9zHLQjwxV8');
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Tutorial'),
              onTap: () {
                launchURL('https://youtu.be/uHsmJjvpKV8');
              },
            ),
            if (ref.watch(wikiUserNameProvider) == '')
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Log In'),
                onTap: () {
                  Navigator.of(context)
                      .pop(); // Close the drawer before navigating
                  context.push('/account/login');
                },
              ),
            if (ref.watch(wikiUserNameProvider) != '')
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Log Out'),
                onTap: () {
                  Navigator.of(context)
                      .pop(); // Close the drawer before navigating
                  context.push('/account/logout');
                },
              ),
          ],
        ),
      ),
    );
  }
}
