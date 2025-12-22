import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wikianesthesia_mobile/Calculators/UniSpecificChecklists/hopkins_checklists.dart';
import 'package:wikianesthesia_mobile/Calculators/calculator_scaffold.dart';
import 'package:wikianesthesia_mobile/Home/wiki_api.dart';
import 'package:wikianesthesia_mobile/util.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// TODO: make style consistent with rest of app with ExpansionPanelRadio

class PreOp extends ConsumerWidget {
  const PreOp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<List<String>> practiceGroups = ref.watch(wikiPracticeGroupsProvider);
    List<String> dbKeys = practiceGroups
        .map((subList) => subList[0])
        .toList(); // Extract the database keys from the practice groups

    return CollapsibleCard(
        controller: ExpansibleController(),
        heading: 'Pre-Op',
        initiallyExpanded: false,
        child: Column(
          children: [
            const SizedBox(
              width: 10,
            ),
            const CheckboxItem(
              label: 'Review H&P, Pre-Op Clinic Note',
              icon: Icon(Icons.person),
            ),
            const CheckboxItem(
              label: 'Review Labs',
              icon: Icon(Icons.bloodtype),
            ),
            const CheckboxItem(
              label: 'Review Cardiology Data (EKG, TTE, Cath)',
              icon: Icon(Icons.favorite),
            ),
            const CheckboxItem(
              label: 'Review Anethestic/Airway History',
              icon: Icon(Icons.history),
            ),
            const CheckboxItem(
              label: 'Call/Text Attending',
              icon: Icon(Icons.phone),
            ),
            const CheckboxItem(
              label: 'Preop Orders',
              icon: Icon(Icons.medication),
            ),
            CheckboxItem(
              label: 'Notify Anesthesia Tech of equipment needed',
              sublabel:
                  dbKeys.contains('Hopkins') ? 'accm-or-request@jhmi.edu' : '',
              icon: const Icon(Icons.email),
            ),
            const CheckboxItem(
              label: 'Write Pre-Op Note',
              icon: Icon(Icons.note),
            ),
            const CheckboxItem(
              label: 'T/S and T/C if necessary',
              icon: Icon(Icons.bloodtype),
            ),
          ],
        ));
  }
}

class StandardSetup extends StatelessWidget {
  const StandardSetup({super.key});

  @override
  Widget build(BuildContext context) {
    return CollapsibleCard(
        controller: ExpansibleController(),
        heading: 'Basic Room Setup',
        initiallyExpanded: false,
        child: const Column(
          children: [
            SizedBox(
              width: 10,
            ),
            Text('Machine',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            CheckboxItem(
              label: 'Machine Check',
              icon: Icon(Icons.air),
            ),
            CheckboxItem(
              label: 'Ambubag Present',
              icon: Icon(Icons.air),
            ),
            Text('Suction',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            CheckboxItem(
              label: 'Suction Present and working',
              icon: Icon(Icons.air),
            ),
            Text('Monitors',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            CheckboxItem(
              label: 'Blood Pressure Cable',
              icon: Icon(Icons.monitor_heart),
            ),
            CheckboxItem(
              label: 'Pulse Ox',
              icon: Icon(Icons.monitor_heart),
            ),
            CheckboxItem(
              label: 'EKG Leads laid out',
              icon: Icon(Icons.monitor_heart),
            ),
            CheckboxItem(
              label: 'EtCO2 Connected',
              icon: Icon(Icons.monitor_heart),
            ),
            CheckboxItem(
              label: 'Temperature Probe',
              icon: Icon(Icons.thermostat),
            ),
            Text('Airway',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            CheckboxItem(
              label: 'Laryngoscope with working light',
              sublabel: 'CMAC/McGrath if needed',
              icon: Icon(Icons.lightbulb),
            ),
            CheckboxItem(
              label: 'ETT +/- Stylet',
              sublabel: 'Check if cuff inflates',
              icon: Icon(Icons.air),
            ),
            CheckboxItem(
              label: 'Oral Airway',
              icon: Icon(Icons.air),
            ),
            CheckboxItem(
              label: 'Bougie',
              icon: Icon(Icons.air),
            ),
            CheckboxItem(
              label: 'Eye Tape',
              icon: Icon(Icons.remove_red_eye),
            ),
            Text('IV',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            CheckboxItem(
              label: 'IV Kit(s)',
              sublabel:
                  'Cannula, Tegaderm, Tape, Gauze, Alcohol Swab, Torniquet, Flush+Extension',
              icon: Icon(FontAwesomeIcons.syringe),
            ),
            CheckboxItem(
              label: 'Fluid Warmer (if needed)',
              icon: Icon(Icons.local_fire_department),
            ),
            CheckboxItem(
              label: 'Freeflow/Push Bag',
              sublabel: 'Can grab from PreOp',
              icon: Icon(Icons.water),
            ),
            Text('Drugs',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            CheckboxItem(
              label: 'Induction Meds',
              sublabel: 'Propofol, Lidocaine, Fentanyl, Rocuronium',
              icon: Icon(Icons.medication),
            ),
            CheckboxItem(
              label: 'Controlled Substances',
              sublabel: 'e.g. Fentanyl, Hydromorphone, Ketamine, Versed',
              icon: Icon(Icons.medication),
            ),
            CheckboxItem(
              label: 'Drips',
              sublabel: 'e.g. Carrier, Propofol, Ketamine, Norepinephrine',
              icon: Icon(Icons.medication),
            ),
            CheckboxItem(
              label: 'Emergency Drugs',
              sublabel:
                  'e.g. Epi, Atropine, Succ, Glyco, Phenylephrine, Ephedrine',
              icon: Icon(Icons.medication),
            ),
            CheckboxItem(
              label: 'Post-Induction Meds',
              sublabel: 'Dexamethasone, Cefazolin',
              icon: Icon(Icons.medication),
            ),
            Text('Special/Software',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            CheckboxItem(
              label: 'EPIC w/ Patient + Macro Loaded',
              icon: Icon(Icons.computer),
            ),
            CheckboxItem(
              label: 'Bair Hugger',
              icon: Icon(Icons.hot_tub),
            ),
            CheckboxItem(
              label: 'A-Line (if necessary)',
              icon: Icon(FontAwesomeIcons.syringe),
            ),
            CheckboxItem(
              label: 'OGT/NGT (if necessary)',
              icon: Icon(Icons.fastfood),
            ),
          ],
        ));
  }
}

class ALine extends StatelessWidget {
  const ALine({super.key});

  @override
  Widget build(BuildContext context) {
    return CollapsibleCard(
        controller: ExpansibleController(),
        heading: 'Arterial Line Kit',
        initiallyExpanded: false,
        child: const Column(
          children: [
            SizedBox(
              width: 10,
            ),
            CheckboxItem(
              label: 'A-Line Transducer',
              sublabel: 'Call tech for one (or email night before)',
              icon: Icon(Icons.speed),
            ),
            CheckboxItem(
              label: 'Arrow Catheter',
              icon: Icon(FontAwesomeIcons.syringe),
            ),
            CheckboxItem(
              label: 'Chlorhexidine Swab',
              icon: Icon(FontAwesomeIcons.syringe),
            ),
            CheckboxItem(
              label: 'Flush + Short Pressure Tubing Extension',
              icon: Icon(Icons.water_drop),
            ),
            CheckboxItem(
              label: 'Sterile Gloves',
              icon: Icon(FontAwesomeIcons.mitten),
            ),
            CheckboxItem(
              label: 'Wrist Bump',
              sublabel: 'Roll up one blue towel',
              icon: Icon(Icons.handshake),
            ),
            CheckboxItem(
              label: 'Clear Tape + Tegaderm',
              icon: Icon(FontAwesomeIcons.tape),
            ),
            CheckboxItem(
              label: 'Ultrasound + Probe Cover',
              sublabel:
                  'Can call tech/email night before or grab from equipment room',
              icon: Icon(Icons.camera),
            ),
          ],
        ));
  }
}

class StandardStart extends StatelessWidget {
  const StandardStart({super.key});

  @override
  Widget build(BuildContext context) {
    return CollapsibleCard(
        controller: ExpansibleController(),
        heading: 'Case Start',
        initiallyExpanded: false,
        child: const Column(
          children: [
            SizedBox(
              width: 10,
            ),
            CheckboxItem(
              label: 'STOP-ID, Start Data Collection',
              icon: Icon(Icons.monitor_heart),
            ),
            CheckboxItem(
              label: 'Apply Monitors',
              sublabel: 'BP, Pulse Ox, EKG',
              icon: Icon(Icons.monitor_heart),
            ),
            CheckboxItem(
              label: 'Attach and Check IV',
              sublabel: 'Check patency, flush, and secure',
              icon: Icon(Icons.water_drop),
            ),
            CheckboxItem(
              label: 'Preoxygenate',
              sublabel: 'APL Open, FiO2 100%',
              icon: Icon(Icons.air),
            ),
            CheckboxItem(
              label: 'Induce/Intubate',
              icon: Icon(Icons.medication),
            ),
            CheckboxItem(
              label: 'Switch to vent/Turn on anesthetic',
              icon: Icon(Icons.air),
            ),
            CheckboxItem(
              label: 'Tape Tubes and Eyes',
              icon: Icon(FontAwesomeIcons.tape),
            ),
            CheckboxItem(
              label: 'Temp Probe, BIS, NGT, OGT, etc.',
              icon: Icon(Icons.thermostat),
            ),
            CheckboxItem(
              label: 'Check/Slow down IV drips if needed',
              icon: Icon(Icons.water_drop),
            ),
            CheckboxItem(
              label: 'Additional Lines',
              icon: Icon(FontAwesomeIcons.syringe),
            ),
            CheckboxItem(
              label: 'Bair hugger',
              icon: Icon(Icons.hot_tub),
            ),
            CheckboxItem(
              label: 'Patient Positioning',
              icon: Icon(Icons.person),
            ),
            CheckboxItem(
              label: 'Decadron + Abx prior to incision',
              icon: Icon(Icons.medication),
            ),
          ],
        ));
  }
}

class Closing extends StatelessWidget {
  const Closing({super.key});

  @override
  Widget build(BuildContext context) {
    return CollapsibleCard(
        controller: ExpansibleController(),
        heading: 'Closing/Waking Up',
        initiallyExpanded: false,
        child: const Column(
          children: [
            SizedBox(
              width: 10,
            ),
            CheckboxItem(
              label: 'Text Attending',
              icon: Icon(Icons.phone),
            ),
            CheckboxItem(
              label: 'Give Zofran',
              icon: Icon(Icons.medication),
            ),
            CheckboxItem(
              label: 'Wean Anesthetic',
              icon: Icon(Icons.medication),
            ),
            CheckboxItem(
              label: 'Consider adjuncts',
              sublabel:
                  'e.g. Toradol (discuss w/ surgeon), APAP (check if given in pre-op), Precedex',
              icon: Icon(Icons.water_drop),
            ),
            CheckboxItem(
              label: 'Get Patient Breathing',
              sublabel:
                  'Pressure Support, Consider 100% FiO2 if not using Nitrous',
              icon: Icon(Icons.air),
            ),
            CheckboxItem(
              label: 'Titrate Narcotics to RR',
              icon: Icon(Icons.medication),
            ),
            CheckboxItem(
              label: 'Reverse Paralysis',
              sublabel: 'Check TOF, give sugammadex if safe to do so',
              icon: Icon(Icons.medication),
            ),
            CheckboxItem(
              label: 'Vent to Spontaneous',
              icon: Icon(Icons.air),
            ),
            CheckboxItem(
              label: 'Call Attending to extubate',
              icon: Icon(Icons.phone),
            ),
            CheckboxItem(
              label: 'Extubate!',
              sublabel: 'Check if misting mask, then switch to green mask',
              icon: Icon(Icons.air),
            ),
          ],
        ));
  }
}

class CA1Guide extends ConsumerWidget {
  const CA1Guide({super.key});

  static const Map<String, List<Widget>> practiceGroupSpecificChecklists = {
    'Hopkins': [
      HopkinsTrauma(),
      Divider(height: 0),
      HopkinsDitzel(),
      Divider(height: 0),
      HopkinsNIR(),
    ]
  };

  static const List<Widget> defaultChecklists = [
    PreOp(),
    Divider(height: 0),
    StandardSetup(),
    Divider(height: 0),
    ALine(),
    Divider(height: 0),
    StandardStart(),
    Divider(height: 0),
    Closing(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> checklists = defaultChecklists;

    List<List<String>> practiceGroups = ref.watch(wikiPracticeGroupsProvider);
    List<String> dbKeys = practiceGroups
        .map((subList) => subList[0])
        .toList(); // Extract the database keys from the practice groups
    // Check if there are any practice group specific checklists to add
    for (var dbKey in dbKeys) {
      checklists.add(const Divider(height: 0));
      checklists.addAll(practiceGroupSpecificChecklists[dbKey] ?? []);
    }

    return CalculatorScaffold(
      title: 'Checklists',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
        child: Card(
          child: ListView(
            shrinkWrap: true,
            children: checklists,
          ),
        ),
      ),
    );
  }
}
