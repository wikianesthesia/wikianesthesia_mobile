import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';

const primaryColor = Color.fromARGB(255, 0, 109, 229);
const lightColor = Color.fromARGB(255, 75, 152, 237);

class TileButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function onPressed;
  final Color backgroundColor;
  final Color iconColor;
  final Color labelColor;

  final int animDuration;
  final double iconSize;

  const TileButton({
    // Required Parameters
    super.key,
    required this.onPressed,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,

    //Optional Parameters
    this.label = '',
    this.animDuration = 150,
    this.iconSize = 100,
    this.labelColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.synchronized(
      duration: Duration(milliseconds: animDuration),
      child: ScaleAnimation(
        child: FadeInAnimation(
          child: Card(
              child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              backgroundColor: backgroundColor,
            ),
            onPressed: () {
              onPressed();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: iconSize, color: iconColor),
                Text(label, style: TextStyle(color: labelColor, fontSize: 18)),
              ],
            ),
          )),
        ),
      ),
    );
  }
}

/* ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            backgroundColor: backgroundColor,
          ),
          onPressed: () {
            onPressed();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: iconSize, color: iconColor),
              Text(label, style: TextStyle(color: labelColor, fontSize: 16)),
            ],
          ),
        )), */

/*ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                tileColor: backgroundColor,
                onTap: () {
                  onPressed();
                },
                leading: Icon(icon, size: iconSize, color: iconColor),
                title: Text(label,
                    style: TextStyle(color: labelColor, fontSize: 24)),
              ),*/

void launchURL(targetUrl) async {
  final Uri url = Uri.parse(targetUrl);
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $targetUrl');
  }
}

void goEmergencyPage(BuildContext context, pageTitle) {
  context.pushNamed('emergencypage', pathParameters: {'pageTitle': pageTitle});
}

void goPracticeGroupPage(BuildContext context, dbkey, shortname, fullname) {
  context.pushNamed('practicegrouppage', pathParameters: {
    'dbkey': dbkey,
    'shortname': shortname,
    'fullname': fullname
  });
}

void goWikiPage(BuildContext context, url) {
  context.pushNamed('wikipage', pathParameters: {'url': url});
}

void goCalcPage(BuildContext context, url) {
  context.pushNamed('calcpage', pathParameters: {'url': url});
}

void goAccountPage(BuildContext context, url) {
  context.pushNamed('accountpage', pathParameters: {'url': url});
}

void goACPage(BuildContext context, String drug) {
  context.pushNamed('acpage', pathParameters: {'drug': drug});
}

class BlinkingButton extends StatefulWidget {
  /// Creates a Button that continually blinks a specified color

  final Widget child;

  /// Starting color of button
  final Color startColor;

  /// The color that the button will blink to
  final Color endColor;

  /// Callback for when button is pressed
  final VoidCallback onPressed;

  const BlinkingButton(
      {required this.startColor,
      required this.endColor,
      required this.onPressed,
      required this.child,
      super.key});

  @override
  State<BlinkingButton> createState() => _BlinkingButtonState();
}

class _BlinkingButtonState extends State<BlinkingButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Animation<Color?> animation = ColorTween(
      begin: widget.startColor,
      end: widget.endColor,
    ).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    return ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: animation.value,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.grey, width: 1), // Set border color and width
            borderRadius: BorderRadius.circular(8), // Set border radius
          ),
        ),
        child: widget.child);
  }
}


class CollapsibleCard extends StatelessWidget {
  final ExpansibleController controller;
  final Widget child;
  final String heading;
  final Color color;
  final bool initiallyExpanded;

  const CollapsibleCard(
      {required this.heading,
      required this.child,
      required this.controller,
      this.color = Colors.blue,
      this.initiallyExpanded = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
          decoration: BoxDecoration(
              border: Border(left: BorderSide(color: color, width: 10))),
          child: ExpansionTile(
            controller: controller,
            initiallyExpanded: initiallyExpanded,
            title: Text(
              heading,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            dense: true,
            childrenPadding: const EdgeInsets.only(bottom: 8.0),
            children: [child],
          )),
    );
  }
}

class CollapsibleCardColored extends StatelessWidget {
  final ExpansibleController controller;
  final Widget child;
  final String heading;
  final Color color;
  final bool striped;
  final bool initiallyExpanded;

  const CollapsibleCardColored(
      {required this.heading,
      required this.child,
      required this.controller,
      this.color = Colors.blue,
      this.striped = false,
      this.initiallyExpanded = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    BoxDecoration decoration;
    if (striped) {
      decoration = BoxDecoration(
          gradient: LinearGradient(
        colors: [
          color,
          color,
          striped ? Colors.white : color,
          striped ? Colors.white : color
        ],
        stops: const [0, 0.5, 0.5, 1],
        begin: Alignment.topLeft,
        end: const Alignment(-0.9, -0.5),
        tileMode: TileMode.repeated,
      ));
    } else {
      decoration = BoxDecoration(color: color);
    }

    return Card(
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: decoration,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Container(
              color: Colors.grey[200],
              child: ExpansionTile(
                controller: controller,
                initiallyExpanded: initiallyExpanded,
                title: Text(
                  heading,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    background: Paint()
                      ..color = const Color.fromARGB(50, 255, 255, 255)
                      ..style = PaintingStyle.fill,
                  ),
                ),
                dense: false,
                //childrenPadding: const EdgeInsets.only(bottom: 8.0),
                shape: const Border(),
                children: [child],
              ),
            ),
          ),
        ));
  }
}

class CheckboxItem extends StatefulWidget {
  final String label;
  final Icon icon;
  final String sublabel;

  /// Creates a CheckboxItem with a label, icon, and optional sublabel

  const CheckboxItem(
      {super.key, required this.label, required this.icon, this.sublabel = ''});

  @override
  State<CheckboxItem> createState() => _CheckboxItemState();
}

class _CheckboxItemState extends State<CheckboxItem> {
  bool _value = false;
  @override
  void initState() {
    super.initState();
    _value = false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sublabel == '') {
      return CheckboxListTile(
        title: Text(widget.label),
        value: _value,
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (bool? newVal) {
          setState(() {
            _value = newVal ?? false;
          });
        },
        secondary: widget.icon,
      );
    } else {
      return CheckboxListTile(
        title: Text(widget.label),
        value: _value,
        subtitle: Text(widget.sublabel),
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (bool? newVal) {
          setState(() {
            _value = newVal ?? false;
          });
        },
        secondary: widget.icon,
      );
    }
  }
}


class ExpansionInfoTile extends StatelessWidget {
  final String title;
  final String content;

  const ExpansionInfoTile({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    const headerStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: true,
        expandedAlignment: Alignment.centerLeft,
        tilePadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
        childrenPadding: const EdgeInsets.only(top: 0, bottom: 10),
        title: Text(title, style: headerStyle),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35.0),
            child: MarkdownBody(
              shrinkWrap: true,
              data: content
            ),
          ),
        ],
      ),
    );
  }
}