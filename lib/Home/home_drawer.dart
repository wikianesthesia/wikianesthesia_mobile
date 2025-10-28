import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:wikianesthesia_mobile/Home/wiki_api.dart';
import 'package:wikianesthesia_mobile/util.dart';

class HomeDrawer extends ConsumerWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeData theme = Theme.of(context);
    String userName = ref.watch(wikiUserNameProvider);
    String fullName = ref.watch(wikiFullNameProvider);

    bool isLoggedIn = userName != '';
    bool hasPracticeGroups = ref.watch(wikiPracticeGroupsProvider).isNotEmpty;

    List<ExpansionPanelRadio> practiceGroupTiles = [];
    bool isHopkins = false;

    if (hasPracticeGroups) {
      List<List<String>> practiceGroups = ref.watch(wikiPracticeGroupsProvider);
      List<String> dbKeys = practiceGroups
          .map((subList) => subList[0])
          .toList();
      List<String> shortNames = practiceGroups
          .map((subList) => subList[1])
          .toList();

      if (shortNames.contains('Hopkins')) {
        isHopkins = true;
      }

      practiceGroupTiles = shortNames.asMap().entries.map(
        (e) => ExpansionPanelRadio(
          value: e.value,
          canTapOnHeader: true,
          headerBuilder: (context, isExpanded) => ListTile(title: Text(e.value)),
          body: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Dashboard'),
                onTap: () {
                  goWikiPage(context, 'https://wikianesthesia.org/wiki/PracticeGroup:${dbKeys[e.key]}');
                },
              ),
              ListTile(
                leading: const Icon(Icons.folder),
                title: const Text('Articles'),
                onTap: () {
                  goWikiPage(context, 'https://wikianesthesia.org/wiki/PracticeGroup:${dbKeys[e.key]}#articles');
                },
              ),
              ListTile(
                leading: const Icon(Icons.group),
                title: const Text('Members'),
                onTap: () {
                  goWikiPage(context, 'https://wikianesthesia.org/wiki/PracticeGroup:${dbKeys[e.key]}#members');
                },
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.solidHospital),
                title: const Text('Practice Groups List'),
                onTap: () {
                  goWikiPage(context, 'https://wikianesthesia.org/wiki/Special:PracticeGroups');
                },
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.book),
                title: const Text('Practice Groups Guide'),
                onTap: () {
                  goWikiPage(context, 'https://wikianesthesia.org/wiki/WikiAnesthesia:Practice_groups_guide');
                },
              ),
              if(e.value == 'Hopkins') ListTile(
                leading: const Icon(Icons.key),
                title: const Text('Door Codes'),
                onTap: () {
                  context.push('/practicegroup/codes');
                },
              ),
              if(e.value == 'Hopkins') ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Phone Numbers'),
                onTap: () {
                  context.push('/practicegroup/phone');
                },
              ),
            ],
          ),
        )
      ).toList();
    }

    return SafeArea(
      left: false,
      child: Drawer(
        child: ListView(
          children: [
            SizedBox(
              height: 80,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: primaryColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 2.0, right: 8.0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      isLoggedIn ? fullName : 'Welcome',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ExpansionPanelList.radio(
              elevation: 0,
              expandedHeaderPadding: const EdgeInsets.all(0),
              materialGapSize: 3,
              children: practiceGroupTiles + [
                articlesPanel(context),
                calcPanel(context, isHopkins),
                helpPanel(context, userName),
                if (isLoggedIn) accountPanel(context, userName),
              ]
            ),
            LogInButton(theme: theme, isLoggedIn: isLoggedIn),
          ],
        ),
      ),
    );
  }

  ExpansionPanelRadio helpPanel(BuildContext context, String userName) {
    return ExpansionPanelRadio(
      headerBuilder: (context, isExpanded) => const ListTile(title: Text('Help')),
      value: 'help',
      canTapOnHeader: true,
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About WikiAnesthesia'),
            onTap: () {
              goWikiPage(context, 'https://wikianesthesia.org/wiki/WikiAnesthesia:About');
            },
          ),
          ListTile(
            leading: const Icon(Icons.question_mark),
            title: const Text('FAQ'),
            onTap: () {
              goWikiPage(context, 'https://wikianesthesia.org/wiki/WikiAnesthesia:FAQ');
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.solidHandshake),
            title: const Text('Get Involved'),
            onTap: () {
              goWikiPage(context, 'https://wikianesthesia.org/wiki/WikiAnesthesia:Get_involved');
            },
          ),
          ListTile(
            leading: const Icon(Icons.comment),
            title: const Text('Submit Feedback'),
            onTap: () {
              launchURL('https://wikianesthesia.org/wiki/WikiAnesthesia:Get_involved');
            },
          ),
          if (userName != '') ListTile(
            leading: const Icon(FontAwesomeIcons.penToSquare),
            title: const Text('Visual Editor Guide'),
            onTap: () {
              goWikiPage(context, 'https://www.mediawiki.org/wiki/Help:VisualEditor/User_guide');
            },
          ),
          if (userName != '') ListTile(
            leading: const Icon(FontAwesomeIcons.code),
            title: const Text('WikiText Guide'),
            onTap: () {
              goWikiPage(context, 'https://en.wikipedia.org/wiki/Help:Wikitext');
            },
          ),
        ],
      )
    );
  }

  ExpansionPanelRadio calcPanel(BuildContext context, bool isHopkins) {
    return ExpansionPanelRadio(
      headerBuilder: (context, isExpanded) => const ListTile(title: Text('Calculators')),
      value: 'calculators',
      canTapOnHeader: true,
      body: Column(
        children: [
          ListTile(
            leading: const Icon(FontAwesomeIcons.childReaching),
            title: const Text('Body Composition'),
            onTap: () {
              goWikiPage(context, 'https://wikianesthesia.org/wiki/Body_composition_calculations');
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.heartPulse),
            title: const Text('Cardiovascular'),
            onTap: () {
              goWikiPage(context, 'https://wikianesthesia.org/wiki/Cardiovascular_calculations');
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.syringe),
            title: const Text('Drug Dosages'),
            onTap: () {
              goWikiPage(context, 'https://wikianesthesia.org/wiki/Drug_dosage_calculations');
            },
          ),
          ListTile(
            leading: const Icon(Icons.construction),
            title: const Text('Equipment Size'),
            onTap: () {
              goWikiPage(context, 'https://wikianesthesia.org/wiki/Equipment_size_calculations');
            },
          ),
          ListTile(
            leading: const Icon(Icons.water_drop),
            title: const Text('Fluid Management'),
            onTap: () {
              goWikiPage(context, 'https://wikianesthesia.org/wiki/Fluid_management_calculations');
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.brain),
            title: const Text('Neuro'),
            onTap: () {
              goWikiPage(context, 'https://wikianesthesia.org/wiki/Neuro_calculations');
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.lungs),
            title: const Text('Respiratory'),
            onTap: () {
              goWikiPage(context, 'https://wikianesthesia.org/wiki/Respiratory_calculations');
            },
          ),
          ListTile(
            leading: const Icon(Icons.checklist),
            title: const Text('Checklists'),
            onTap: () {
              context.push('/calculator/ca1');;
            },
          ),
          if (isHopkins) ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Pump Case'),
            onTap: () {
              context.push('/calculator/pump');
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.book),
            title: const Text('Calculator Guide'),
            onTap: () {
              goWikiPage(context, 'https://wikianesthesia.org/wiki/WikiAnesthesia:Calculators_guide');
            },
          ),
        ],
      )
    );
  }

  ExpansionPanelRadio articlesPanel(BuildContext context) {
    return ExpansionPanelRadio(
      value: 'articles',
      canTapOnHeader: true,
      headerBuilder: (context, isExpanded) => const ListTile(title: Text('Articles')),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(FontAwesomeIcons.bookOpen),
            title: const Text('Table of Contents'),
            onTap: () {
              goWikiPage(context, 'https://wikianesthesia.org/wiki/Table_of_contents');
            },
          ),
          ListTile(
            leading: const Icon(Icons.check_circle),
            title: const Text('Top Articles'),
            onTap: () {
              goWikiPage(context, 'https://wikianesthesia.org/wiki/Special:ArticleScores/EditorRating');
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.medal),
            title: const Text('Top Authors'),
            onTap: () {
              goWikiPage(context, 'https://wikianesthesia.org/wiki/Special:ContributionScores');
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.book),
            title: const Text('Author Guide'),
            onTap: () {
              goWikiPage(context, 'https://wikianesthesia.org/wiki/WikiAnesthesia:Author_guide');
            },
          ),
        ],
      ),
    );
  }

  ExpansionPanelRadio accountPanel(BuildContext context, String userName) {
    return ExpansionPanelRadio(
      value: 'account',
      canTapOnHeader: true,
      headerBuilder: (context, isExpanded) => const ListTile(title: Text('Account')),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(FontAwesomeIcons.userDoctor),
            title: const Text('Profile'),
            onTap: () {
              goWikiPage(context, 'https://wikianesthesia.org/wiki/User:$userName');
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.bookMedical),
            title: const Text('Authorship'),
            onTap: () {
              goWikiPage(context, 'https://wikianesthesia.org/wiki/Special:Contributions/$userName');
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.award),
            title: const Text('Achievements'),
            onTap: () {
              goWikiPage(context, 'https://wikianesthesia.org/wiki/Special:UserAchievements');
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.solidClipboard),
            title: const Text('Personal Notes'),
            onTap: () {
              goWikiPage(context, 'https://wikianesthesia.org/wiki/Special:UserNotes');
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.eye),
            title: const Text('Watchlist'),
            onTap: () {
              goWikiPage(context, 'https://wikianesthesia.org/wiki/Special:Watchlist');
            },
          ),
          ListTile(
            leading: const Icon(Icons.thumb_up),
            title: const Text('Liked Articles'),
            onTap: () {
              goWikiPage(context, 'https://wikianesthesia.org/w/index.php?title=Special:ArticleScores/Likes/user&value=0&timestamp=1');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Preferences'),
            onTap: () {
              goWikiPage(context, 'https://wikianesthesia.org/wiki/Special:Preferences');
            },
          ),
        ],
      ),
    );
  }
}

class LogInButton extends StatelessWidget {
  const LogInButton({
    super.key,
    required this.theme,
    required this.isLoggedIn,
  });

  final ThemeData theme;
  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
          ),
          bottom: BorderSide(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: ListTile(
        tileColor: theme.colorScheme.surface,
        leading: isLoggedIn ? const Icon(Icons.logout) : const Icon(Icons.login),
        title: isLoggedIn ? const Text('Log out') : const Text('Log in / Register'),
        onTap: () {
          if (isLoggedIn) {
            context.push('/account/logout');
          } else {
          context.push('/account/login');
          }
        },
      ),
    );
  }
}