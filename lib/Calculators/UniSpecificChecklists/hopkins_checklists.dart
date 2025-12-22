import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wikianesthesia_mobile/util.dart';

class HopkinsTrauma extends StatelessWidget {
  const HopkinsTrauma({super.key});

  @override
  Widget build(BuildContext context) {
    return CollapsibleCard(
        controller: ExpansibleController(),
        heading: 'Trauma Room Setup',
        initiallyExpanded: false,
        child: const Column(
          children: [
            SizedBox(
              width: 10,
            ),
            CheckboxItem(
              label: 'Basic Room Setup',
              sublabel: 'Including daily machine check',
              icon: Icon(Icons.handyman),
            ),
            CheckboxItem(
              label: 'A-Line Setup/Transducer',
              icon: Icon(FontAwesomeIcons.syringe),
            ),
            CheckboxItem(
              label: 'Airway',
              sublabel: 'DL, CMAC, Bougie, Oral Airway, ETT',
              icon: Icon(Icons.air),
            ),
            CheckboxItem(
              label: 'Ultrasound',
              icon: Icon(Icons.camera),
            ),
            CheckboxItem(
              label: 'Fluid Warmer Setup',
              sublabel: 'Use Codonics to print timed label for bag',
              icon: Icon(Icons.local_fire_department),
            ),
            CheckboxItem(
              label: '2-3x PIV Kits (14/16/18G)',
              icon: Icon(Icons.local_fire_department),
            ),
            CheckboxItem(
              label: 'Push Bag/Freeflow',
              sublabel: 'Use Codonics to print timed label for bag',
              icon: Icon(Icons.water),
            ),
            CheckboxItem(
              label: 'Baby Epi (10 mcg/mL)',
              sublabel:
                  'Take a 1 mg Vial and dilute into 100 cc bag. Carry a stick w/ you for good luck',
              icon: Icon(Icons.medication),
            ),
            CheckboxItem(
              label: 'Calcium Chloride',
              icon: Icon(Icons.medication),
            ),
            CheckboxItem(
              label: '4-5 bags of 5% Albumin',
              icon: Icon(Icons.medication),
            ),
            CheckboxItem(
              label: 'Epi/Norepi bags',
              icon: Icon(Icons.medication),
            ),
            CheckboxItem(
              label: 'Cefazolin + Flagyl',
              sublabel: 'Keep easily available but not drawn up',
              icon: Icon(Icons.medication),
            ),
            CheckboxItem(
              label: 'Emergency meds',
              icon: Icon(Icons.medication),
            ),
          ],
        ));
  }
}

class HopkinsDitzel extends StatelessWidget {
  const HopkinsDitzel({super.key});

  @override
  Widget build(BuildContext context) {
    return CollapsibleCard(
        controller: ExpansibleController(),
        heading: 'Ditzel Room Setup',
        initiallyExpanded: false,
        child: const Column(
          children: [
            SizedBox(
              width: 10,
            ),
            CheckboxItem(
              label: 'Basic Room Setup',
              sublabel: 'Including daily machine check',
              icon: Icon(Icons.handyman),
            ),
            CheckboxItem(
              label: 'A-Line Setup/Transducer',
              icon: Icon(FontAwesomeIcons.syringe),
            ),
            CheckboxItem(
              label: '2x 20 cc Syringe for Propofol',
              sublabel: 'Prelabel Syringe w/ needle packaging and vial nearby',
              icon: Icon(Icons.medication),
            ),
            CheckboxItem(
              label: '1x 10 cc Syringe for Roc',
              icon: Icon(Icons.medication),
            ),
            CheckboxItem(
              label: '1x 10 cc Syringe for Fentanyl',
              icon: Icon(Icons.medication),
            ),
            CheckboxItem(
              label: '1x 3 cc Syringe for Midazolam',
              icon: Icon(Icons.medication),
            ),
            CheckboxItem(
              label: '1x Lidocaine Syringe',
              icon: Icon(Icons.medication),
            ),
            CheckboxItem(
              label: '1x Saline Flush for Ancef',
              icon: Icon(Icons.medication),
            ),
            CheckboxItem(
              label: 'Push Bag/Freeflow',
              sublabel: "Don't spike, just have components ready",
              icon: Icon(Icons.water),
            ),
          ],
        ));
  }
}

class HopkinsNIR extends StatelessWidget {
  const HopkinsNIR({super.key});

  @override
  Widget build(BuildContext context) {
    return CollapsibleCard(
        controller: ExpansibleController(),
        heading: 'Neuro IR Setup (aka 316 aka Hell)',
        initiallyExpanded: false,
        child: const Column(
          children: [
            SizedBox(
              width: 10,
            ),
            CheckboxItem(
              label: 'Basic Room Setup',
              sublabel: 'Including daily machine check',
              icon: Icon(Icons.handyman),
            ),
            CheckboxItem(
              label: 'A-Line Setup/Transducer',
              sublabel: 'Expect to tap into their arterial sheath however',
              icon: Icon(FontAwesomeIcons.syringe),
            ),
            CheckboxItem(
              label: 'CMAC',
              icon: Icon(Icons.air),
            ),
            CheckboxItem(
              label: 'Remote Drug Box',
              sublabel: 'Grab from pharmacy',
              icon: Icon(Icons.medication),
            ),
            CheckboxItem(
              label: '2x 20 cc Syringe for Propofol',
              sublabel: 'Prelabel Syringe w/ needle packaging and vial nearby',
              icon: Icon(Icons.medication),
            ),
            CheckboxItem(
              label: '1x 10 cc Syringe for Roc',
              sublabel: 'Prelabel Syringe w/ needle packaging and vial nearby',
              icon: Icon(Icons.medication),
            ),
            CheckboxItem(
              label: '1x 3 cc Syringe for Fentanyl',
              sublabel: 'Prelabel Syringe w/ needle packaging',
              icon: Icon(Icons.medication),
            ),
            CheckboxItem(
              label: '1x Lidocaine Syringe',
              icon: Icon(Icons.medication),
            ),
            CheckboxItem(
              label: '1x 10 cc Syringe for Heparin',
              sublabel: 'Prelabel Syringe w/ needle packaging',
              icon: Icon(Icons.medication),
            ),
            CheckboxItem(
              label: 'Nitroglycerin Sticks',
              sublabel: 'Grab from pharmacy prior to case start',
              icon: Icon(Icons.medication),
            ),
            CheckboxItem(
              label: 'Push Bag/Freeflow (use NS)',
              sublabel: "Attach 3x Extensions",
              icon: Icon(Icons.water_drop),
            ),
            CheckboxItem(
              label: 'TIVA Tubing',
              sublabel: "Attach 3x Pressure Tubing Extensions",
              icon: Icon(Icons.water_drop),
            ),
            CheckboxItem(
              label: 'Carrier Bag (NS)',
              sublabel: "Program at 200-300 cc/hr",
              icon: Icon(Icons.water_drop),
            ),
            CheckboxItem(
              label: 'Nicardipine Drip',
              sublabel: "Program at 5 mg/hr",
              icon: Icon(Icons.medication),
            ),
            CheckboxItem(
              label: 'Norepinephrine Drip',
              sublabel: "Program at 0.03 mcg/kg/min",
              icon: Icon(Icons.medication),
            ),
          ],
        ));
  }
}
