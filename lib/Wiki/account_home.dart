import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:wikianesthesia_mobile/Home/home_drawer.dart';
import 'package:wikianesthesia_mobile/Home/wiki_api.dart';
import 'package:wikianesthesia_mobile/Wiki/account_widget.dart';
import '../util.dart';

class AccountHome extends StatelessWidget {
  const AccountHome({super.key});

  @override
  Widget build(BuildContext context){
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      endDrawer: const HomeDrawer(),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Account',
          style: TextStyle(color: theme.colorScheme.onPrimary),
        ),
        backgroundColor: theme.colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: const [AccountWidget()],
      ),
      body: const SafeArea(
        left: false,
        child: AccountGrid(),
      ),
    );
  }
}

List<Map<String,dynamic>> allAccountOptions(String userName) {
  return [
    {
      'type': 'wikipage',
      'url': 'https://wikianesthesia.org/wiki/User:$userName',
      'icon': FontAwesomeIcons.userDoctor,
      'name': 'Profile',
    },
    {
      'type': 'wikipage',
      'url': 'https://wikianesthesia.org/wiki/Special:Contributions/$userName',
      'icon': FontAwesomeIcons.bookMedical,
      'name': 'Authorship',
    },
    {
      'type': 'wikipage',
      'url': 'https://wikianesthesia.org/wiki/Special:UserAchievements#',
      'icon': FontAwesomeIcons.award,
      'name': 'Achievements',
    },
    {
      'type': 'wikipage',
      'url': 'https://wikianesthesia.org/wiki/Special:UserNotes',
      'icon': FontAwesomeIcons.solidClipboard,
      'name': 'Notes',
    },
    {
      'type': 'wikipage',
      'url':
          'https://wikianesthesia.org/wiki/Special:Watchlist?limit=250&days=7&enhanced=1&urlversion=2',
      'icon': Icons.remove_red_eye,
      'name': 'Watchlist',
    },
    {
      'type': 'wikipage',
      'url':
          'https://wikianesthesia.org/w/index.php?title=Special:ArticleScores/Likes/user&value=0&timestamp=1',
      'icon': Icons.thumb_up,
      'name': 'Liked',
    },
    {
      'type': 'wikipage',
      'url': 'https://wikianesthesia.org/wiki/Special:Preferences',
      'icon': Icons.settings,
      'name': 'Preferences',
    },
    {
      'type': 'native',
      'url': '/account/logout',
      'icon': Icons.logout,
      'name': 'Log out',
    },
  ];
}

List<Map<String,dynamic>> accountLogInOption = [{
      'type': 'native',
      'url': '/account/login',
      'icon': Icons.login,
      'name': 'Log in',
    }];

class AccountDrawerTile extends StatelessWidget {
  /// Account Options for the Drawer
  final Map<String,dynamic> accountOption;
  final String userName;
  const AccountDrawerTile({super.key, required this.userName, required this.accountOption});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(accountOption['icon']),
      title:  Text(accountOption['name']),
      onTap: () {
        context.pop();
        if (accountOption['type'] == 'wikipage') {
          goAccountPage(context, accountOption['url']);
        } else if (accountOption['type'] == 'native') {
          context.push(accountOption['url']);
        }
      },
      tileColor: switch (accountOption['name']) {
        'Log in' => Colors.green[50],
        'Log out' => Colors.red[50],
        _ => null,
      }
    );
  }
}

class AccountMenuTile extends StatelessWidget {
  final Map<String,dynamic> accountOption;
  const AccountMenuTile({super.key, required this.accountOption});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(accountOption['icon']),
      trailing: const Icon(Icons.chevron_right),
      title:  Text(accountOption['name']),
      onTap: () {
        if (accountOption['type'] == 'wikipage') {
          goAccountPage(context, accountOption['url']);
        } else if (accountOption['type'] == 'native') {
          context.push(accountOption['url']);
        }
      },
    );
    
    // InkWell(
    //   onTap: () {
    //     if (accountOption['type'] == 'wikipage') {
    //       goAccountPage(context, accountOption['url']);
    //     } else if (accountOption['type'] == 'native') {
    //       context.push(accountOption['url']);
    //     }
    //   },
    //   child: Column(
    //     children: [
    //       IconButton.filledTonal(
    //         padding: const EdgeInsets.all(20),
    //         icon: Icon(accountOption['icon']),
    //         iconSize: 40,
    //         onPressed: () {
    //           if (accountOption['type'] == 'wikipage') {
    //             goAccountPage(context, accountOption['url']);
    //           } else if (accountOption['type'] == 'native') {
    //             context.push(accountOption['url']);
    //           }
    //         },),  
    //       Text(accountOption['name']),
    //     ],
    //   ),
    // );
  }
}

class AccountGrid extends ConsumerWidget {
  const AccountGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String userName = ref.watch(wikiUserNameProvider);
    List<Map<String,dynamic>> allAccountOptionsList = [];
    
    if (kDebugMode) {
      print('AccountHome: userName = $userName');
    }

    if (userName.isEmpty) {
      allAccountOptionsList = accountLogInOption;
    } else {
      allAccountOptionsList = allAccountOptions(userName);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: ListView(
          shrinkWrap: true,
          children: ListTile.divideTiles(
            context: context,
            tiles: allAccountOptionsList
            .map((option) => AccountMenuTile(accountOption: option))
            .toList()).toList(),
        ),
      ),
    );
    // GridView.extent(
    //   maxCrossAxisExtent: 150,
    //   mainAxisSpacing: 10,
    //   crossAxisSpacing: 10,
    //   padding: const EdgeInsets.all(20),
    //   children: allAccountOptionsList.map((option) => AccountIconButton(accountOption: option,)).toList(),
    // );
  }
}

ExpansionPanelRadio accountPanel(BuildContext context, String userName) {
    List<Map<String,dynamic>> allAccountOptionsList = allAccountOptions(userName);

    List<Widget> optionTiles = allAccountOptionsList
      .sublist(0,allAccountOptionsList.length-1) // Exclude the logout option
      .map((option) => AccountDrawerTile(userName: userName, accountOption: option))
      .toList();

    return ExpansionPanelRadio(
      value: 'account',
      canTapOnHeader: true,
      headerBuilder: (context, isExpanded) => const ListTile(title: Text('Account')),
      body: Column(
        children: optionTiles,
      ),
    );
  }