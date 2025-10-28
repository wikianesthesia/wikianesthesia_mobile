import 'package:flutter/material.dart';
import 'package:wikianesthesia_mobile/Home/home_drawer.dart';
import 'package:wikianesthesia_mobile/Wiki/account_widget.dart';

class CalculatorScaffold extends StatelessWidget {
  const CalculatorScaffold(
      {super.key, required this.child, required this.title});
  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(color: theme.colorScheme.onPrimary),
        ),
        backgroundColor: theme.colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(icon: const Icon(Icons.arrow_back),onPressed: () {
          Navigator.pop(context);
        },),
        actions: const [AccountWidget()],
      ),
      endDrawer: const HomeDrawer(),
      drawerEnableOpenDragGesture: true, 
      body: SafeArea(left: false, child: child),
    );
  }
}
