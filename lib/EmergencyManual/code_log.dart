import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:wikianesthesia_mobile/EmergencyManual/acls_timers.dart';

class CodeLog extends ConsumerWidget {
  const CodeLog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get Log String from Timer Provider
    final timersState = ref.watch(aclsTimersProvider);

    String logString = timersState['log'];

    if (logString.isEmpty) {
      logString = 'No events logged.';
    }

    // Get available height and width of the build area of this widget. Make a choice depending on the size.                              
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return AlertDialog(
      title: const Text('Code Log'),
      content: SizedBox(
        height: height * 0.9,
        width: width * 0.9,
        child: Scrollbar(
          child: Markdown(
            data: logString,
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Reset',),
          onPressed: () {
            ref.read(aclsTimersProvider.notifier).resetMain();
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ]
    );
  }
}