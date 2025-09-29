import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wikianesthesia_mobile/Home/wiki_api.dart';
import '../util.dart';

class PracticeGroupPage extends ConsumerWidget {
  final String dbkey;
  final String shortname;
  final String fullname;

  const PracticeGroupPage(
      {super.key,
      required this.dbkey,
      required this.shortname,
      required this.fullname});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);

    String userName = ref.watch(wikiUserNameProvider);

    List<Widget> loggedInOptions = <Widget>[
      TileButton(
        onPressed: () {
          goWikiPage(
              context, 'https://wikianesthesia.org/wiki/PracticeGroup:$dbkey#');
        },
        icon: Icons.home,
        label: 'Dashboard',
        backgroundColor: theme.colorScheme.primary,
        iconColor: theme.colorScheme.onPrimary,
        labelColor: theme.colorScheme.onPrimary,
      ),
      TileButton(
        onPressed: () {
          goWikiPage(context,
              'https://wikianesthesia.org/wiki/PracticeGroup:$dbkey#articles');
        },
        icon: Icons.book,
        label: 'Articles',
        backgroundColor: theme.colorScheme.secondary,
        iconColor: theme.colorScheme.onSecondary,
        labelColor: theme.colorScheme.onSecondary,
      ),
      TileButton(
        onPressed: () {
          goWikiPage(context,
              'https://wikianesthesia.org/wiki/PracticeGroup:$dbkey#members');
        },
        icon: Icons.group_add,
        label: 'Members',
        backgroundColor: theme.colorScheme.tertiary,
        iconColor: theme.colorScheme.onTertiary,
        labelColor: theme.colorScheme.onTertiary,
      ),
    ];

    List<Widget> hopkinsOptions = [
      TileButton(
        onPressed: () {
          context.push('/practicegroup/codes');
        },
        icon: Icons.key,
        label: 'Door Codes',
        backgroundColor: theme.colorScheme.primary,
        iconColor: theme.colorScheme.onError,
        labelColor: theme.colorScheme.onError,
      ),
      TileButton(
        onPressed: () {
          context.push('/practicegroup/phone');
        },
        icon: Icons.phone,
        label: 'Phone List',
        backgroundColor: theme.colorScheme.secondary,
        iconColor: theme.colorScheme.onSecondary,
        labelColor: theme.colorScheme.onSecondary,
      ),
    ];

    if (shortname == 'Hopkins' && userName != '') {
      loggedInOptions.addAll(hopkinsOptions);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          shortname,
          style: TextStyle(color: theme.colorScheme.onPrimary),
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: SafeArea(
          child: GridView.extent(
        maxCrossAxisExtent: 300,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        primary: false,
        padding: const EdgeInsets.all(20),
        children: userName == ''
            ? <Widget>[
                TileButton(
                  onPressed: () {
                    context.go('/account/login');
                  },
                  icon: Icons.login,
                  label: 'Login',
                  backgroundColor: theme.colorScheme.secondary,
                  iconColor: theme.colorScheme.onSecondary,
                  labelColor: theme.colorScheme.onSecondary,
                ),
              ]
            : loggedInOptions,
      )),
    );
  }
}
