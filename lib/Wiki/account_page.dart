import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wikianesthesia_mobile/Home/wiki_api.dart';
import '../util.dart';

class AccountHome extends ConsumerWidget {
  const AccountHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);

    String userName = ref.watch(wikiUserNameProvider);

    List<Widget> loggedInOptions = <Widget>[
      TileButton(
        onPressed: () {
          goWikiPage(context, 'https://wikianesthesia.org/wiki/User:$userName');
        },
        icon: Icons.person,
        label: 'Profile',
        backgroundColor: theme.colorScheme.primary,
        iconColor: theme.colorScheme.onPrimary,
        labelColor: theme.colorScheme.onPrimary,
      ),
      TileButton(
        onPressed: () {
          goWikiPage(context,
              'https://wikianesthesia.org/wiki/Special:Contributions/$userName');
        },
        icon: Icons.book,
        label: 'Authorship',
        backgroundColor: theme.colorScheme.secondary,
        iconColor: theme.colorScheme.onSecondary,
        labelColor: theme.colorScheme.onSecondary,
      ),
      TileButton(
        onPressed: () {
          goWikiPage(context,
              'https://wikianesthesia.org/wiki/Special:UserAchievements#');
        },
        icon: Icons.star,
        label: 'Achievements',
        backgroundColor: theme.colorScheme.tertiary,
        iconColor: theme.colorScheme.onTertiary,
        labelColor: theme.colorScheme.onTertiary,
      ),
      TileButton(
        onPressed: () {
          goWikiPage(
              context, 'https://wikianesthesia.org/wiki/Special:UserNotes');
        },
        icon: Icons.note,
        label: 'Personal Notes',
        backgroundColor: theme.colorScheme.primary,
        iconColor: theme.colorScheme.onPrimary,
        labelColor: theme.colorScheme.onPrimary,
      ),
      TileButton(
        onPressed: () {
          goWikiPage(context,
              'https://wikianesthesia.org/wiki/Special:Watchlist?limit=250&days=7&enhanced=1&urlversion=2');
        },
        icon: Icons.remove_red_eye,
        label: 'Watchlist',
        backgroundColor: theme.colorScheme.secondary,
        iconColor: theme.colorScheme.onSecondary,
        labelColor: theme.colorScheme.onSecondary,
      ),
      TileButton(
        onPressed: () {
          goWikiPage(context,
              'https://wikianesthesia.org/w/index.php?title=Special:ArticleScores/Likes/user&value=0&timestamp=1');
        },
        icon: Icons.thumb_up,
        label: 'Liked',
        backgroundColor: theme.colorScheme.tertiary,
        iconColor: theme.colorScheme.onTertiary,
        labelColor: theme.colorScheme.onTertiary,
      ),
      TileButton(
        onPressed: () {
          goWikiPage(
              context, 'https://wikianesthesia.org/wiki/Special:Preferences');
        },
        icon: Icons.settings,
        label: 'Preferences',
        backgroundColor: theme.colorScheme.primary,
        iconColor: theme.colorScheme.onPrimary,
        labelColor: theme.colorScheme.onPrimary,
      ),
      TileButton(
        onPressed: () {
          context.go('/account/logout');
        },
        icon: Icons.logout,
        label: 'Logout',
        backgroundColor: theme.colorScheme.error,
        iconColor: theme.colorScheme.onError,
        labelColor: theme.colorScheme.onError,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Account',
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
                  backgroundColor: theme.colorScheme.primary,
                  iconColor: theme.colorScheme.onPrimary,
                  labelColor: theme.colorScheme.onPrimary,
                ),
              ]
            : loggedInOptions,
      )),
    );
  }
}
