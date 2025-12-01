const Map<String,List<Map<String,String>>> pacemakerMagnetResponse = {
    'Biotronik': [
      { 'mode': 'Auto (Default Mode)',
        'description': 'After magnet placement, device will pace asynchronously at 90 BPM for 10 cycles, and then switch back to synchronous pacing at the programmed rate. The device comes by default in "Auto" mode and is typically reprogrammed to "Async" at the time of implantation. However, a single-center study showed found that 6/38 devices were left in "Auto" mode (Streckenbach & Dalia, 2021)'
      },
      { 'mode': 'Async',
        'description': 'After magnet placement, device will pace asynchronously at 90 BPM until magnet is removed. At recommended generator replacement time, will pace asyncronously at 89% of the programmed lower rate.'
      },
      { 'mode': 'Sync',
        'description': 'Magnet response is disabled. Sometimes, device will store an EMG with magnet application in this mode, although this is rarely utilized.'
      },
    ],
    'Medtronic': [
      { 'mode': 'Asynchronous Pacing (Only Option)',
        'description': 'After magnet placement, device will pace asynchronously at 85 BPM until magnet is removed. At recommended generator replacement time, will pace at 65 BPM.'
      },
    ],
    'Abbott / St. Jude': [
      { 'mode': 'Asynchronous Pacing (Default Option)',
        'description': 'After magnet placement, device will pace asynchronously at 100 BPM, gradually declining to 85 BPM at recommended time of generator replacement'
      },
      { 'mode': 'OFF',
        'description': 'No magnet response.'
      },
      { 'mode': 'Episode trigger',
        'description': 'Device will store an EMG and then revert to either "Async" or "OFF" mode if magnet is reapplied or left in place, depending on programming. Rarely used in modern era.'
      }
    ],
    'Boston Scientific': [
      { 'mode': 'Asynchronous Pacing (Default Option)',
        'description': 'After magnet placement, device will pace asynchronously at 100 BPM until magnet is removed. At recommended generator replacement time, will pace at 85 BPM.'
      },
      { 'mode': 'OFF',
        'description': 'No magnet response. Uncommonly used.'
      },
      { 'mode': 'Store EMG',
        'description': 'Device will store an EMG when magnet placed for at least 3 seconds. After these 3 seconds, if the magnet is then removed for 3 seconds and then placed again, then will pace asynchronously as above. Rarely used in modern era.'
      },
      {
        'mode': 'MRI Protection Mode',
        'description': 'No magnet response.'
      },
      {
        'mode': 'Electrocautery Protection Mode',
        'description': 'Will asynchronously pace at the device\'s lower rate limit. No magnet response. Can be used as an alternative to magnet placement.'
      }
    ],
    'Microport / Sorin': [
      { 'mode': 'Asynchronous Pacing (Only Option)',
        'description': 'After magnet placement, device will pace asynchronously at 96 BPM, gradually declining to 80 BPM at recommended time of generator replacement.'
      },
    ],
};

const Map<String,List<Map<String,String>>> icdMagnetResponse = {
  'Biotronik': [
    { 'mode': 'Suspend Tachytherapies (Only Option)',
      'description': 'Suspends tachytherapies for 8 hours. After 8 hours, magnet must be removed and replaced. Alternatively, consider device reprogramming for surgeries longer than 8 hours. Pacing will not be impacted.'
    },
  ],
  'Medtronic': [
    { 'mode': 'Suspend Tachytherapies (Only Option)',
      'description': 'Suspends tachytherapies until magnet is removed. Pacing will not be impacted.'
    },
  ],
  'Abbott / St. Jude': [
    { 'mode': 'Suspend Tachytherapies (Default Option)',
      'description': 'Suspends tachytherapies until magnet is removed. Pacing will not be impacted.'
    },
    { 'mode': 'OFF',
      'description': 'No magnet response. This is very rarely used.'
    },
    { 'mode': 'Episode Trigger',
      'description': 'Device will store an EMG when magnet placed. If magnet is reapplied or left in place, tachytherapies will be suspended. Rarely used in modern era.'
    },
  ],
  'Boston Scientific': [
    { 'mode': 'Suspend Tachytherapies (Default Option)',
      'description': 'Suspends tachytherapies until magnet is removed. Pacing will not be impacted.'
    },
    { 'mode': 'OFF',
      'description': 'No magnet response. Uncommonly used.'
    },
    { 'mode': 'Store EMG',
      'description': 'Device will store an EMG when magnet placed for at least 3 seconds. After these 3 seconds, if the magnet is then removed for 3 seconds and then placed again, tachytherapies will be suspended. Rarely used in modern era.'
    },
    {
      'mode': 'MRI Protection Mode',
      'description': 'No magnet response.'
    },
    {
      'mode': 'Electrocautery Protection Mode',
      'description': 'Will suspend tachytherapies until reprogrammed again. No magnet response. Can be used as an alternative to magnet placement.'
    }
  ],
  'Microport / Sorin': [
    { 'mode':  'Suspend Tachytherapies (Only Option)',
      'description': 'Suspends tachytherapies until magnet is removed. Pacing will not be impacted.'
    },
    {
      'mode': 'Legacy Devices (Pardym, Ovatio, Alto, Defender)',
      'description': 'Tachytherapies will be suspended. If has pacing, will pace SYNCHRONOULY at 96 BPM, gradually declining to 80 BPM at recommended time of generator replacement.',
    }
  ],
};

const Map<String,List<Map<String,String>>> leadlessPMMagnetResponse = {
  'Medtronic Micra': [
    { 'mode': 'No Magnet Response',
      'description': 'There is no magnet response. You must reprogram the device to asynchronous pacing mode if needed.'
    },
  ],
  'Medtronic Micra AV': [
    { 'mode': 'No Magnet Response',
      'description': 'There is no magnet response. You must reprogram the device to asynchronous pacing mode if needed.'
    },
  ],
  'St. Jude Nanostim': [
    { 'mode': 'Asynchronous Pacing (Only Option)',
      'description': 'After magnet placement, device will pace asynchronously at 90 BPM, gradually decreasing to 65 BPM at recommended generator replacement time.'
    },
    {'mode': 'Notes',
     'description': 'Nanostim devices are no longer being implanted as of 2016 due to lack of FDA approval. However, some implanted devices remain in use.'
    }
  ],
  'Abbott Aveir VR/DR': [
    { 'mode': 'Asynchronous Pacing (Default Option)',
      'description': 'After magnet placement, device will pace asynchronously at 100 BPM, gradually decreasing to 85 BPM at recommended generatore replacement time.'
    },
    { 'mode': 'OFF',
      'description': 'No magnet response. Uncommonly used.'
    },
    {'mode': 'Notes',
     'description': 'Aveir VR is implanted in the right ventricle. Aveir DR has 2 separate devices in the right atrium and ventricle. Confirm correct magnet placement by noting a change in pacing rate on EKG.'
    }
  ],
};

const Map<String,List<Map<String,String>>> sicdMagnetResponse = {
  'Boston Scientific': [
    { 'mode': 'Suspend Tachytherapies',
      'description': 'Suspends tachytherapies until magnet is removed.'
    },
    {
      'mode': 'MRI Protection Mode',
      'description': 'No magnet response.'
    }
  ],
};