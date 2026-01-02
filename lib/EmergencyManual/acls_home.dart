import 'package:flutter/material.dart';
import 'package:wikianesthesia_mobile/Home/home_drawer.dart';
import 'package:wikianesthesia_mobile/Wiki/account_widget.dart';

import '../util.dart';
import './emergency_topics.dart';

class ACLSHome extends StatelessWidget {
  const ACLSHome({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List allTopics = [...aclsTopics];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('ACLS', style: TextStyle(color: theme.colorScheme.onError)),
        backgroundColor: theme.colorScheme.error,
        iconTheme: IconThemeData(color: theme.colorScheme.onError),
        actions: const [AccountWidget()],
      ),
      endDrawer: const HomeDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
        child: Card(
          clipBehavior: Clip.hardEdge,
          child: ListView(
            shrinkWrap: true,
            children: ListTile.divideTiles(
              context: context,
              tiles: allTopics.map((topic) {
                    return ListTile(
                      enableFeedback: true,
                      leading: Icon(topic['icon']),
                      title: Text(topic['name']),
                      onTap:() {
                        goEmergencyPage(context, topic['pageTitle']);
                      },);
                }),
              ).toList()
          ),
        ),
      )
    );
  }
}

