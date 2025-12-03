const Map<String, FlowSheetItem> pacemakerManagement = {
  'start': FlowSheetItem(
    question: 'Emergent Surgery?',
    options: ['Yes', 'No'],
    next: {
      'Yes': 'proceed',
      'No': 'aboveUmbilicus'
    },
    footnotes: [],
  ),
  'proceed': FlowSheetItem(
    question: 'Proceed to surgery. Place magnet only if unacceptable bradycardia observed.',
    options: [],
    next: {},
    footnotes: [1,2,3]
  ),
  'aboveUmbilicus': FlowSheetItem(
    question: 'Does surgery use electrocautery above umbilicus?',
    options: ['Yes', 'No'],
    next: {
      'Yes': 'prevInterrogated',
      'No': 'proceed'
    },
    footnotes: [],
  ),
  'prevInterrogated': FlowSheetItem(
    question: 'Has the pacemaker been interrogated within 1 year or has remote monitoring?',
    options: ['Yes', 'No'],
    next: {
      'Yes': 'paced',
      'No': 'interrogate'
    },
    footnotes: [],
  ),
  'interrogate': FlowSheetItem(
    question: 'Interrogate device. Is patient pacemaker-dependent?',
    options: ['Yes', 'No'],
    next: {
      'Yes': 'device',
      'No': 'proceed'
    },
    footnotes: []
  ),
  'paced': FlowSheetItem(
    question: 'Is patient pacemaker-dependent?',
    options: ['Yes', 'No'],
    next: {
      'Yes': 'device',
      'No': 'proceed'
    },
    footnotes: []
  ),
  'device': FlowSheetItem(
    question: 'What manufacturer?',
    options: ['Biotronik','Other'],
    next: {'Biotronik': 'biotronik',
           'Other': 'consider'},
    footnotes: []
  ),
  'biotronik': FlowSheetItem(
    question: 'Place magnet. Does device asynchronously pace at 90 BPM continuously for longer than 30 seconds?',
    options: ['Yes','No'],
    next: {'Yes': 'consider',
           'No': 'deviceReprogram'},
    footnotes: [13]
  ),
  'consider': FlowSheetItem(
    question: 'Consider device reprogramming to asynchronous pacing vs magnet application',
    options: [],
    next: {},
    footnotes: [1,2,3,14]
  ),
  'deviceReprogram': FlowSheetItem(
    question: 'Reprogram device to "ASYNC" mode prior to surgery to ensure appropriate magnet response. Consider magnet placement either prior to procedure or if severe bradycardia observed.',
    options: [],
    next: {},
    footnotes: [1,2,3,13,14]
  ),
};

const Map<String, FlowSheetItem> icdManagement = {
  'start': FlowSheetItem(
    question: 'Emergent Surgery?',
    options: ['Yes', 'No'],
    next: {
      'Yes': 'magnet',
      'No': 'aboveUmbilicus'
    },
    footnotes: [],
  ),
  'magnet': FlowSheetItem(
    question: 'Place magnet on device and proceed to surgery. Apply defibrillator pads until magnet removed.',
    options: [],
    next: {},
    footnotes: [4,15]
  ),
  'proceed': FlowSheetItem(
    question: 'Proceed to surgery. If device is intraabdominal, consult manufacturer.',
    options: [],
    next: {},
    footnotes: []
  ),
  'aboveUmbilicus': FlowSheetItem(
    question: 'Does surgery use electrocautery above umbilicus?',
    options: ['Yes', 'No'],
    next: {
      'Yes': 'prevInterrogated',
      'No': 'proceed'
    },
    footnotes: [],
  ),
  'prevInterrogated': FlowSheetItem(
    question: 'Has the ICD been interrogated within 6 months or has remote monitoring?',
    options: ['Yes', 'No'],
    next: {
      'Yes': 'reprogram',
      'No': 'interrogate'
    },
    footnotes: [],
  ),
  'interrogate': FlowSheetItem(
    question: 'Interrogate device. Then place magnet or reprogram device prior to surgery. Apply external defibrillator pads until magnet removed and/or device reprogrammed.',
    options: [],
    next: {},
    footnotes: [4,15]
  ),
  'reprogram': FlowSheetItem(
    question: 'Place magnet or reprogram device prior to surgery. Apply external defibrillator pads until magnet removed and/or device reprogrammed.',
    options: [],
    next: {},
    footnotes: [4,15]
  ),
};

const Map<String,FlowSheetItem> icdPMManagement = {
  'start': FlowSheetItem(
    question: 'Emergent Surgery?',
    options: ['Yes', 'No'],
    next: {
      'Yes': 'emergent',
      'No': 'aboveUmbilicus'
    },
    footnotes: [],
  ),
  'emergent': FlowSheetItem(
    question: 'Place magnet on device and proceed to surgery with electrocautery precautions. Apply defibrillator pads until magnet removed. Note magnet application will not change pacing mode (i.e. will potentially remain synchronous).',
    options: [],
    next: {},
    footnotes: [4,5,10,15]
  ),
  'magnet': FlowSheetItem(
    question: 'Place magnet on device or reprogram to disable tachytherapies and proceed to surgery. Apply defibrillator pads until magnet removed and/or device reprogrammed to original settings.',
    options: [],
    next: {},
    footnotes: [4,10,15]
  ),
  'aboveUmbilicus': FlowSheetItem(
    question: 'Does surgery use electrocautery above umbilicus?',
    options: ['Yes', 'No'],
    next: {
      'Yes': 'prevInterrogated',
      'No': 'proceed'
    },
    footnotes: [],
  ),
  'proceed': FlowSheetItem(
    question: 'Proceed to surgery.',
    options: [],
    next: {},
    footnotes: [15]
  ),
  'prevInterrogated': FlowSheetItem(
    question: 'Has the device been interrogated within 6 months or has remote monitoring?',
    options: ['Yes', 'No'],
    next: {
      'Yes': 'paced',
      'No': 'interrogate'
    },
    footnotes: [],
  ),
  'interrogate': FlowSheetItem(
    question: 'Interrogate device. Is patient pacemaker-dependent (Intrinsic HR < 45)?',
    options: ['Yes', 'No'],
    next: {
      'Yes': 'reprogram',
      'No': 'magnet'
    },
    footnotes: []
  ),
  'paced':FlowSheetItem(
    question: 'Is patient pacemaker-dependent (Intrinsic HR < 45)?',
    options: ['Yes', 'No'],
    next: {
      'Yes': 'reprogram',
      'No': 'magnet'
    },
    footnotes: []
  ),
  'reprogram': FlowSheetItem(
    question: 'Reprogram device to disable tachytherapies AND enable asynchronous pacing prior to surgery (electrocautery mode if available). Magnet application alone is not sufficient. Pads should be applied until device is reprogrammed to original settings.',
    options: [],
    next: {},
    footnotes: [8,9,12,15]
  ),
};

const Map<String,FlowSheetItem> leadlessPMManagement = {
  'start': FlowSheetItem(
    question: 'Emergent Surgery?',
    options: ['Yes', 'No'],
    next: {
      'Yes': 'proceedPrecautions',
      'No': 'aboveUmbilicus'
    },
    footnotes: [],
  ),
  'proceedPrecautions': FlowSheetItem(
    question: 'Proceed to surgery. Use electrocautery precautions.',
    options: [],
    next: {},
    footnotes: [5]
  ),
  'proceed': FlowSheetItem(
    question: 'Proceed to surgery.',
    options: [],
    next: {},
    footnotes: []
  ),
  'aboveUmbilicus': FlowSheetItem(
    question: 'Does surgery use electrocautery above umbilicus?',
    options: ['Yes', 'No'],
    next: {
      'Yes': 'prevInterrogated',
      'No': 'proceed'
    },
    footnotes: [],
  ),
  'prevInterrogated': FlowSheetItem(
    question: 'Has the pacemaker been interrogated within 6 months or has remote monitoring?',
    options: ['Yes', 'No'],
    next: {
      'Yes': 'paced',
      'No': 'interrogate'
    },
    footnotes: [],
  ),
  'paced': FlowSheetItem(
    question: 'Pacemaker spikes observed?',
    options: ['Yes', 'No'],
    next: {
      'Yes': 'device',
      'No': 'proceed'
    },
    footnotes: []
  ),
  'interrogate': FlowSheetItem(
    question: 'Interrogate device. Pacemaker spikes observed?',
    options: ['Yes', 'No'],
    next: {
      'Yes': 'device',
      'No': 'proceed'
    },
    footnotes: []
  ),
  'device': FlowSheetItem(
    question: 'What device?',
    options: ['Micra','Aveir'],
    next: {
      'Micra': 'medtronic',
      'Aveir': 'aveir'
    },
    footnotes: []
  ),
  'micra': FlowSheetItem(
    question: 'No magnet response. Reprogram to asynchronous pacing if indicated.',
    options: [],
    next: {},
    footnotes: [2,3,12,14]
  ),
  'aveir': FlowSheetItem(
    question: 'Consider magnet placement prior to procedure.',
    options: [],
    next: {},
    footnotes: [2,3,11,14]
  ),
};

const Map<String,FlowSheetItem> unknownDeviceManagement = {
  'start': FlowSheetItem(
    question: 'Device Identified?',
    options: ['Yes', 'No'],
    next: {
      'Yes': 'follow',
      'No': 'pacemakerSpikes'
    },
    footnotes: [6],
  ),
  'follow': FlowSheetItem(
    question: 'Follow device-specific flowchart.',
    options: [],
    next: {},
    footnotes: []
  ),
  'pacemakerSpikes': FlowSheetItem(
    question: 'Are pacemaker spikes observed on EKG?',
    options: ['Yes', 'No'],
    next: {
      'Yes': 'paceFound',
      'No': 'noPace'
    },
    footnotes: []
  ),
  'paceFound': FlowSheetItem(
    question: 'Place magnet and observe for changes in pacing.',
    options: ['Yes', 'No'],
    next: {
      'Yes': 'pm',
      'No': 'icd-pm'
    },
    footnotes: []
  ),
  'noPace': FlowSheetItem(
    question: 'Place magnet and observe for new pacing spikes.',
    options: ['Yes', 'No'],
    next: {
      'Yes': 'pm',
      'No': 'icd'
    },
    footnotes: []
  ),
  'pm': FlowSheetItem(
    question: 'Likely pacemaker. Manage per pacemaker flowchart.',
    options: ['Pacemaker Flowchart'],
    next: {'Pacemaker Flowchart': '/ep/flowsheet/pm'},
    footnotes: [1,2,3,14]
  ),
  'icd': FlowSheetItem(
    question: 'Likely ICD vs ICD with Pacemaker. Follow ICD flowchart with electrocautery precautions.',
    options: ['ICD Flowchart'],
    next: {'ICD Flowchart': '/ep/flowsheet/icd'},
    footnotes: [1,4,5]
  ),
  'icd-pm': FlowSheetItem(
    question: 'Confirmed ICD with Pacemaker. Follow ICD-PM flowchart with electrocautery precautions.',
    options: ['ICD-PM Flowchart'],
    next: {'ICD-PM Flowchart': '/ep/flowsheet/icd-pm'},
    footnotes: [1,4,5,9,10]
  ),
};

const Map<String, FlowSheetItem> postOpManagement = {
  'start': FlowSheetItem(
    question: 'Was the surgery emergent, involved ionizing radiation, RF ablation, cardioversion, major trauma, or likely to cause lead displacement?',
    options: ['Yes', 'No'],
    next: {
      'Yes': 'reprogram',
      'No': 'prevProgrammed'
    },
    footnotes: [7],
  ),
  'prevProgrammed': FlowSheetItem(
    question: 'Was the device reprogrammed prior to surgery?',
    options: ['Yes', 'No'],
    next: {
      'Yes': 'reprogram',
      'No': 'remote'
    },
    footnotes: [],
  ),
  'reprogram': FlowSheetItem(
    question: 'Interrogate device and restore original settings prior to discharge from monitored setting.',
    options: [],
    next: {},
    footnotes: [12]
  ),
  'remote': FlowSheetItem(
    question: 'Is remote monitoring available?',
    options: ['Yes', 'No'],
    next: {
      'Yes': 'end',
      'No': 'interrogate'
    },
    footnotes: [],
  ),
  'end': FlowSheetItem(
    question: 'No further action needed.',
    options: [],
    next: {},
    footnotes: []
  ),
  'interrogate': FlowSheetItem(
    question: 'Interrogate device within 30 days of procedure. Does not need to delay discharge if no concerns.',
    options: [],
    next: {},
    footnotes: []
  ),
};

Map<int, String> flowchartFootnotes = {
  1: '''
### Pacemaker Exceptions
* Although rare, Biotronik, St. Jude, and Boston Scientific pacemakers can be programmed to ignore magnet placement
* If leadless pacemaker, might not respond to a magnet. Consider reprogramming prior to surgery
* Medtronic's Adapta and Sensa require 1 hour between reprogramming and magnet application to ensure proper magnet response. If asynchronous pacing is desired within 1 hour of reprogramming, reprogram device directly instead of using magnet
''',
  2: '''
### Considering Underlying Rhythm
* **Pacemaker-Dependent Patients**: Magnet application will lead to increased heart rate (80-100 BPM depending on manufacturer). In case of pathologic or physiologic atrial tachycardia (e.g. AFib w/ RVR, Fever, Sympathetic Response), competing heart rhythms might occur. In this scenario, *magnet removal is indicated*
* **Non-Pacemaker-Dependent Patients w/ HR less than magnet response rate**: Magnet application will increase heart rate to magnet response rate (80-100 BPM depending on manufacturer)
* **Non-Pacemaker-Dependent Patients w/ HR greater than magnet response rate**: Magnet application will result in competing and disorganized heart rhythms. *Magnet removal is indicated*
''',
  3: '''
### Monitor Intrinsic HR
* Continuous ECG monitoring is recommended to assess for competing rhythms after magnet placement
* If intrinsic HR exceeds magnet response rate, *magnet removal is indicated* to avoid competing or disorganized rhythms
''',
  4: '''
### ICD Exceptions
* Boston Scientific and Abbott/St. Jude devices have rarely used programming options that disable magnet response. If time permits, interrogate device prior to surgery to confirm appropriate magnet response
* Some Biotronik ICD's revert tachytherapy suspension after 8 hours of magnet placement. To continue tachytherapy suspension, remove magnet for 10 seconds and reapply again
''',
  5: '''
### Electrocautery Precautions
* For devices with no magnet response, utilizing short (<5 seconds) bursts of electrocautery can minimize interference
''',
  6: '''
### Methods to Identify Device
* Device Wallet Card
* Ask device manufacturers
  * Biotronik: 1-800-547-0394
  * Medtronic: 1-800-633-8766 (1-800-MEDTRON)
  * Boston Scientific: 1-800-227-3422 (1-800-CARDIAC)
  * Abbott/St. Jude: 1-800-722-3423 (1-800-PACEICD)
  * Microport/Sorin: 1-312-635-6602
* Review implanting hospital's records
* Review implanting cardiologist's records
* Chest X-ray
  * Presence of shocking coils suggests ICD vs ICD-PM
  * Absence of shocking coils suggests pacemaker
* Many ICD's give an audible tone when a magnet is placed over the device
  * Medtronic: Single tone
  * Abbott/St. Jude: Single tone (if device after 2019)
  * Boston Scientific: Single tone with ICD's, beeping for 60 seconds with SICD's
  * Biotronik: No tone
  * Microport/Sorin: No tone
''',
  8: '''
### Use of external defibrillator
* After reprogramming or magnet placement on an ICD, external defibrillator pads should be placed
* Pads should remain postoperatively until device is reprogrammed to original settings and/or magnet is removed
''',
  9: '''
### Intrinsic Rhythm for ICD-PM Patients
* Periprocedural hemodynamic instability is unlikely in patients with intrinsic HR > 45 BPM
* If intrinsic HR < 45 BPM, reprogram device to asynchronous pacing mode prior to surgery
* Magnet placement alone is insufficient for asynchronous pacing
''',
  10: '''
### Magnet Response for Legacy ICD-PM
* Legacy Microport/Sorin ICD-PM's (Paradym, Ovatio, Alto, Defender) will suspend tachytherapies and pace SYNChronously at 96 BPM, gradually declining to 80 BPM at recommended time of generator replacement
* This synchronous pacing would still be susceptible to electrocautery over-sensing and inhibition
''',
  11: '''
### Aveir Magnet Confirmation
* Correct magnet placement can be confirmed on EKG by noting change in pacer spikes changing from synchronous to asynchronous at 85-100 BPM.
''',
  12: '''
### Postoperative Device Evaluation
* If ICD or pacemaker was reprogrammed prior to surgery, ensure device is re-evaluated and reprogrammed to original settings prior to discharge from a monitored setting.
''',
  13: '''
### Biotronik Specific Notes
* Biotronik pacemakers default to "Auto" magnet mode, which provides asynchronous pacing at 90 BPM for 10 cycles before reverting to synchronous pacing
* Although this mode is typically switched to "Async" at implantation, a single-center study found that 6/38 devices were left in "Auto" mode (Streckenbach & Dalia, 2021)
''',
  14: '''
### AHA vs ASA Recommendations
* AHA 2024 Scientific Statement recommends proactive magnet placement vs reprogramming to an asynchronous mode (DOO, VOO, AOO) for pacemaker-dependent rhythms to avoid severe bradycardia
* ASA 2024 CIED Practice Advisory recommends only using a magnet or reprogramming if severe bradycardia is observed intraoperatively to avoid potentially competing rhythms in setting of surgical stimulation
* Consider patient-specific factors (e.g. intrinsic rhythm, surgery type, duration, etc.) when deciding between proactive asynchronous reprogramming vs magnet placement in response to severe bradycardia
''',
  15:'''
### Defibrillation and Cardioversion
* If defibrillation or cardioversion is indicated, remove magnet and discontinue electrocautery to see whether device will activate by itself
* If device does not activate by itself, external defibrillator pads should be used. Ensure pads are NOT directly overlying device
'''
};

class FlowSheetItem {
  final String question;
  final List<String> options;
  final Map<String, String> next;
  final List<int> footnotes;

  const FlowSheetItem({
    required this.question,
    this.options = const [],
    this.next = const {},
    this.footnotes = const [],
  });
}