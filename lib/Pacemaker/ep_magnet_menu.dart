import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:wikianesthesia_mobile/Calculators/calculator_scaffold.dart';
import 'package:wikianesthesia_mobile/Pacemaker/ep_responses.dart';

class EPMagnetMenu extends StatelessWidget {
  const EPMagnetMenu({super.key});

  ExpansionPanelRadio pacemakerPanel(BuildContext context) {
    List<String> manufacturers = pacemakerMagnetResponse.keys.toList();

    return ExpansionPanelRadio(
      canTapOnHeader: true,
      value: 'pacemaker',
      headerBuilder: (context, isExpanded) {
        return const ListTile(
          leading: Icon(FontAwesomeIcons.heartPulse),
          title: Text('Pacemakers'),
        );
      },
      body: Column(
        children: manufacturers.map((man) {
          return EPMagnetListTile(device: 'pm', manufacturer: man,);
        }).toList(),
      ),
    );
  }

  ExpansionPanelRadio leadlessPMPanel(BuildContext context) {
    List<String> manufacturers = leadlessPMMagnetResponse.keys.toList();

    return ExpansionPanelRadio(
      canTapOnHeader: true,
      value: 'leadless-pm',
      headerBuilder: (context, isExpanded) {
        return const ListTile(
          leading: Icon(FontAwesomeIcons.heartPulse),
          title: Text('Leadless Pacemakers'),
        );
      },
      body: Column(
        children: manufacturers.map((man) {
          return EPMagnetListTile(device: 'leadless-pm', manufacturer: man,);
        }).toList(),
      ),
    );
  }

  ExpansionPanelRadio icdPanel(BuildContext context) {
    List<String> manufacturers = icdMagnetResponse.keys.toList();

    return ExpansionPanelRadio(
      canTapOnHeader: true,
      value: 'icd',
      headerBuilder: (context, isExpanded) {
        return const ListTile(
          leading: Icon(FontAwesomeIcons.heartPulse),
          title: Text('Implantable Cardioverter-Defibrillators (ICDs)'),
        );
      },
      body: Column(
        children: manufacturers.map((man) {
          return EPMagnetListTile(device: 'icd', manufacturer: man,);
        }).toList(),
      ),
    );
  }

  ExpansionPanelRadio sicdPanel(BuildContext context) {
    List<String> manufacturers = sicdMagnetResponse.keys.toList();

    return ExpansionPanelRadio(
      canTapOnHeader: true,
      value: 'sicd',
      headerBuilder: (context, isExpanded) {
        return const ListTile(
          leading: Icon(FontAwesomeIcons.heartPulse),
          title: Text('Subcutaneous ICDs (SICDs)'),
        );
      },
      body: Column(
        children: manufacturers.map((man) {
          return EPMagnetListTile(device: 'sicd', manufacturer: man,);
        }).toList(),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
      title: 'Device Magnet Responses',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
        child: Card(
          clipBehavior: Clip.hardEdge,
          child: SingleChildScrollView(
            child: ExpansionPanelList.radio(
              //elevation: 5,
              expandedHeaderPadding: const EdgeInsets.all(0),
              materialGapSize: 5,
              children: [
                pacemakerPanel(context),
                leadlessPMPanel(context),
                icdPanel(context),
                sicdPanel(context),
              ]
            ),
          ),
        ),
      ),
    );
  }
}

const List<Map<String, dynamic>> allMagnetOptions = [
  {
    'name': 'Pacemaker',
    'shortName': 'PM',
    'url': '/ep/magnet/pm',
  },
  {
    'name': 'Leadless Pacemaker',
    'shortName': 'Leadless PM',
    'url': '/ep/magnet/leadless-pm',
  },
  {
    'name': 'ICD',
    'shortName': 'ICD',
    'url': '/ep/magnet/icd',
  },
  {
    'name': 'Subcutaneous ICD (SICD)',
    'shortName': 'SICD',
    'url': '/ep/magnet/sicd',
  }
];

class EPMagnetListTile extends StatelessWidget {
  final String device;
  final String manufacturer;
  const EPMagnetListTile({super.key, required this.device, required this.manufacturer});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(FontAwesomeIcons.heartCircleBolt),
      title: Text(manufacturer),
      onTap: () {
        context.push('/ep/magnet/$device/${manufacturer.replaceAll('/', '-')}');
      },
    );
  }
}