import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wikianesthesia_mobile/Home/wiki_api.dart';
import 'package:wikianesthesia_mobile/Wiki/practicegroup_page.dart';
import '../util.dart';

class PracticeGroupHome extends ConsumerWidget {
  const PracticeGroupHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);

    List<List<String>> practiceGroups = ref.watch(wikiPracticeGroupsProvider);

    Widget body;

    if (practiceGroups.isEmpty) {
      body = const Center(
        child: Text('No practice groups found.'),
      );
    } else if (practiceGroups.length == 1) {
      // If only 1 practice group, go directly to that page
      String dbkey = practiceGroups[0][0];
      String shortname = practiceGroups[0][1];
      String fullname = practiceGroups[0][2];
      return PracticeGroupPage(
          dbkey: dbkey, shortname: shortname, fullname: fullname);
    } else {
      // Otherwise, show grid of practice groups
      body = GridView.extent(
        maxCrossAxisExtent: 300,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        primary: false,
        padding: const EdgeInsets.all(20),
        children: practiceGroups.map((group) {
          String dbkey = group[0];
          String shortname = group[1];
          String fullname = group[2];
          return TileButton(
            onPressed: () {
              goPracticeGroupPage(context, dbkey, shortname, fullname);
            },
            icon: Icons.group,
            label: shortname,
            backgroundColor: theme.colorScheme.primary,
            iconColor: theme.colorScheme.onPrimary,
            labelColor: theme.colorScheme.onPrimary,
          );
        }).toList(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Practice Groups',
          style: TextStyle(color: theme.colorScheme.onPrimary),
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: body,
    );
  }
}
