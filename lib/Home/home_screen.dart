import 'package:flutter/material.dart';
import 'package:wikianesthesia_mobile/Home/home_drawer.dart';
import 'package:wikianesthesia_mobile/Home/search_wiki_bar.dart';
import 'package:wikianesthesia_mobile/Wiki/account_widget.dart';
import '../util.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: const [
          Padding(
            padding: EdgeInsets.all(4.0),
            child: AccountWidget(),
          ),
        ],
      ),
      drawer: const HomeDrawer(),
      body: SizedBox.expand(
          child: 
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryColor,
                    lightColor,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.8, 1],
                )
              ),
              height: MediaQuery.of(context).size.height * 0.8,
              child: const Column(
                children: [
                  Spacer(flex: 3),
                  ImageIcon(
                    AssetImage('assets/wikianesthesia_logo.png'),
                    color: Colors.white,
                    size: 64.0,
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                    child: WikiSearchView(),
                  ),
                  Spacer(flex: 3),
                ],
              ),
            )
        )
      );
  }
}

