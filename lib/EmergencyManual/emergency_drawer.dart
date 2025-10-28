import 'package:wikianesthesia_mobile/EmergencyManual/emergency_topics.dart';
import 'package:wikianesthesia_mobile/util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmergencyDrawer extends StatelessWidget {
  const EmergencyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> listButtons = [
      ListTile(
        leading: const Icon(Icons.home),
        title: const Text('Emergency Manual Home'),
        onTap: () {
          context.push('/emergency');
        },
      ),
    ];

    List<Widget> allTopics = emergencyTopics
        .map(
          (topic) => ListTile(
            onTap: () {
              goEmergencyPage(context, topic['pageTitle']);
            },
            leading: Icon(topic['icon']),
            title: Text(topic['name']),
          ),
        )
        .toList();

    listButtons.addAll(allTopics);

    return SafeArea(
      left: false,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: listButtons,
        ),
      ),
    );
  }
}
