import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wikianesthesia_mobile/Wiki/practicegroup.dart';
import 'package:wikianesthesia_mobile/main.dart';
// import 'package:worker_manager/worker_manager.dart';

/// Widget that displays the user's account information and provides login/logout functionality.
class AccountWidget extends ConsumerStatefulWidget {
  const AccountWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AccountWidgetState();
}

class AccountWidgetState extends ConsumerState<AccountWidget> {
  final PracticeGroupFinder practiceGroupFinder = PracticeGroupFinder();

  @override
  void initState(){
    super.initState();

    wikiAPI.loadUsername(ref);
    wikiAPI.loadPracticeGroups(ref);
    practiceGroupFinder.init(ref);

    if (wikiAPI.userName.isNotEmpty) {
      practiceGroupFinder.start(wikiAPI.userName); // Start the headless webview to fetch practice groups
    }
  }

  @override
  Widget build(BuildContext context) {

    return IconButton(
      onPressed: () {
        Scaffold.of(context).openEndDrawer();
      },
      icon: const Icon(Icons.menu, color: Colors.white)
    );
  }

  //   if (userName == '') {
  //     return OutlinedButton(
  //       onPressed: () => context.push('/account/login'),
  //       style: ButtonStyle(
  //         foregroundColor: WidgetStateProperty.all(Colors.white),
  //         side: WidgetStateProperty.all(const BorderSide(color: Colors.white)),
  //       ),
  //       child: const Text('Log in/Register'),
  //     );
  //   } else {
  //     return PopupMenuButton(
  //       itemBuilder: (context) {
  //         return <PopupMenuEntry>[
  //           PopupMenuItem(
  //             child: Text('Logged in: $userName'),
  //           ),
  //           const PopupMenuDivider(),
  //           PopupMenuItem(
  //             child: const Text('Account'),
  //             onTap: () {
  //               context.push('/account');
  //             },
  //           ),
  //           if (practiceGroups.isNotEmpty)
  //             PopupMenuItem(
  //               child: Text('Practice Group: ${practiceGroups[0][0]}'),
  //               onTap: () {
  //                 context.push('/practice_group');
  //               },
  //             ),
  //           PopupMenuItem(
  //             child: const Text('Log out'),
  //             onTap: () {
  //               context.push('/account/logout');
  //             },
  //           ),
  //         ];
  //       },
  //       child: CircleAvatar(
  //         backgroundColor: Colors.white,
  //         child: Text(
  //           userName.isNotEmpty ? userName[0].toUpperCase() : '?',
  //           style: const TextStyle(color: Colors.black),
  //         ),
  //       ),
  //     );
  //   }
  // }
}
