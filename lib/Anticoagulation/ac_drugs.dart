List<Map<String,String>> acDrugs = [
  {
    "Generic": "Apixaban (High)",
    "Brand": "Eliquis",
    "Tags": "DOAC",
    "HoldPrior": "72 hours (or when residual apixaban plasma level < 30 ng/mL or residual aXa activity plasma level <=0.1 IU/mL)",
    "ResumeAfter": "24 hours",
    "HoldPriorCathRemoval": "Contraindicated while catheter in place; 72 hours if unanticipated administration",
    "ResumeAfterCathRemoval": "24 hours"
  },
  {
    "Generic": "Apixaban (Low)",
    "Brand": "Eliquis",
    "Tags": "DOAC, Anti-Xa",
    "HoldPrior": "36 hours (or when residual apixaban plasma level < 30 ng/mL or residual aXa activity plasma level <=0.1 IU/mL)",
    "ResumeAfter": "6 hours",
    "HoldPriorCathRemoval": "Contraindicated while catheter in place; 36 hours if unanticipated administration",
    "ResumeAfterCathRemoval": "6 hours"
  },
  {
    "Generic": "Edoxaban",
    "Brand": "Savaysa",
    "Tags": "Lixiana, DOAC, Anti-Xa",
    "HoldPrior": "72 hours(or when residual edoxaban plasma level < 30 ng/mL or residual aXa activity",
    "ResumeAfter": "24 hours",
    "HoldPriorCathRemoval": "Contraindicated while catheter in place; 72 hours if unanticipated administration",
    "ResumeAfterCathRemoval": "24 hours"
  },
  {
    "Generic": "Rivaroxaban (High)",
    "Brand": "Xarelto",
    "Tags": "DOAC, Anti-Xa",
    "HoldPrior": "72 hours (or when residual Xarelto plasma level < 30 ng/mL or residual aXa activity plasma level <=0.1 IU/mL)",
    "ResumeAfter": "24 hours",
    "HoldPriorCathRemoval": "Contraindicated while catheter in place; 72 hours if unanticipated administration",
    "ResumeAfterCathRemoval": "24 hours"
  },
  {
    "Generic": "Rivaroxaban (Low)",
    "Brand": "Xarelto",
    "Tags": "DOAC, Anti-Xa",
    "HoldPrior": "24 hours (or when residual Xarelto plasma level < 30 ng/mL or residual aXa activity plasma level <=0.1 IU/mL)",
    "ResumeAfter": "6 hours",
    "HoldPriorCathRemoval": "Contraindicated while catheter in place; 24 hours if unanticipated administration",
    "ResumeAfterCathRemoval": "6 hours"
  },
  {
    "Generic": "Dabigatran (High)",
    "Brand": "Pradaxa",
    "Tags": "Direct Thrombin Inhibitor, DOAC",
    "HoldPrior": "72 hours (CrCl >= 50), 120 hours (CrCl 30-49), or until plasma level is <30 ng/mL (CrCl < 30)",
    "ResumeAfter": "24 hours",
    "HoldPriorCathRemoval": "Contraindicated while catheter in place; 72 hours (CrCl >= 50), 120 hours (CrCl 30-49) if unanticipated administration",
    "ResumeAfterCathRemoval": "24 hours"
  },
  {
    "Generic": "Dabigatran (Low)",
    "Brand": "Pradaxa",
    "Tags": "Direct Thrombin Inhibitor, DOAC",
    "HoldPrior": "48 hours (CrCl > 30), or when dabigatran plasma level is <30 ng/mL",
    "ResumeAfter": "6 hours",
    "HoldPriorCathRemoval": "Contraindicated while catheter in place; 48 hours if unanticipated administration of dabigatran",
    "ResumeAfterCathRemoval": "6 hours"
  },
  {
    "Generic": "Heparin, IV Drip",
    "Brand": "UFH",
    "Tags": "gtt, intravenous",
    "HoldPrior": "4-6 hours (assess coag studies prior to procedure)",
    "ResumeAfter": "1 hour",
    "HoldPriorCathRemoval": "Contraindicated while catheter in place; if unanticipated heparizination, monitor neuro status",
    "ResumeAfterCathRemoval": "1 hour"
  },
  {
    "Generic": "Heparin, Sub-Q (Low)",
    "Brand": "5000U BID-TID",
    "Tags": "subcutaneous, SQH, UFH",
    "HoldPrior": "4-6 hours after last SQH admin",
    "ResumeAfter": "Immediately",
    "HoldPriorCathRemoval": "4-6 hours after last SQH admin",
    "ResumeAfterCathRemoval": "Immediately"
  },
  {
    "Generic": "Heparin, Sub-Q (Med)",
    "Brand": "7500-10000U BID",
    "Tags": "subcutaneous, SQH, UFH",
    "HoldPrior": "12 hours after last SQH admin",
    "ResumeAfter": "1 hour",
    "HoldPriorCathRemoval": "Contraindicated while catheter in place",
    "ResumeAfterCathRemoval": "1 hour"
  },
  {
    "Generic": "Heparin, Sub-Q (High)",
    "Brand": "(>10000U BID)",
    "Tags": "subcutaneous, SQH, UFH",
    "HoldPrior": "24 hours after last SQH admin",
    "ResumeAfter": "1 hour",
    "HoldPriorCathRemoval": "Contraindicated while catheter in place",
    "ResumeAfterCathRemoval": "1 hour"
  },
  {
    "Generic": "LMWH (High)",
    "Brand": "Enoxaparin, Lovenox",
    "Tags": "lower molecular weight heparin",
    "HoldPrior": "24 hours after last admin",
    "ResumeAfter": "24 hours",
    "HoldPriorCathRemoval": "Contraindicated while catheter in place",
    "ResumeAfterCathRemoval": "4 hours"
  },
  {
    "Generic": "LMWH (Low)",
    "Brand": "Enoxaparin, Lovenox",
    "Tags": "lower molecular weight heparin,ppx",
    "HoldPrior": "12 hours after last admin",
    "ResumeAfter": "12 hours",
    "HoldPriorCathRemoval": "12 hours after last admin",
    "ResumeAfterCathRemoval": "4 hours"
  },
  {
    "Generic": "NSAIDs",
    "Brand": "",
    "Tags": "Ibuprofen,Advil,meloxicam,Aspirin, asa",
    "HoldPrior": "No need to hold",
    "ResumeAfter": "Immediately",
    "HoldPriorCathRemoval": "No need to hold",
    "ResumeAfterCathRemoval": "No need to hold"
  },
  {
    "Generic": "Clopidogrel",
    "Brand": "Plavix",
    "Tags": "thienopyridine, antiplatelet",
    "HoldPrior": "5-7 days",
    "ResumeAfter": "6 hours (if giving loading dose). Otherwise, can resume maintenance immediately",
    "HoldPriorCathRemoval": "If resuming maintenance therapy after catheter placement, remove the catheter within 1-2 days. Do NOT administer loading dose.",
    "ResumeAfterCathRemoval": "6 hours (if giving loading dose). Otherwise, can resume maintenance immediately"
  },
  {
    "Generic": "Prasugrel",
    "Brand": "Effient",
    "Tags": "thienopyridine, antiplatelet",
    "HoldPrior": "7-10 days",
    "ResumeAfter": "6 hours (if giving loading dose). Otherwise, can resume maintenance immediately",
    "HoldPriorCathRemoval": "Contraindicated while catheter in place",
    "ResumeAfterCathRemoval": "6 hours (if giving loading dose). Otherwise, can resume maintenance immediately"
  },
  {
    "Generic": "Ticagrelor",
    "Brand": "Brilinta",
    "Tags": "P2Y12 platelet inhibitor antiplatelet",
    "HoldPrior": "5 days",
    "ResumeAfter": "6 hours (if giving loading dose). Otherwise, can resume maintenance immediately",
    "HoldPriorCathRemoval": "Contraindicated while catheter in place",
    "ResumeAfterCathRemoval": "6 hours (if giving loading dose). Otherwise, can resume maintenance immediately"
  },
  {
    "Generic": "Abciximab",
    "Brand": "ReoPro",
    "Tags": "Platelet inhibitor, antiplatelet, GP IIb/IIIa",
    "HoldPrior": "24-48 hours",
    "ResumeAfter": "4 Weeks (if have to be given emergently, consider neuro monitoring)",
    "HoldPriorCathRemoval": "Contraindicated while catheter in place",
    "ResumeAfterCathRemoval": "4 Weeks (if have to be given emergently, consider nuro monitoring)"
  },
  {
    "Generic": "Eptifibatide",
    "Brand": "Integrilin",
    "Tags": "Platelet inhibitor, antiplatelet, GP IIb/IIIa",
    "HoldPrior": "4-8 hours",
    "ResumeAfter": "4 Weeks (if have to be given emergently, consider neuro monitoring)",
    "HoldPriorCathRemoval": "Contraindicated while catheter in place",
    "ResumeAfterCathRemoval": "4 Weeks (if have to be given emergently, consider nuro monitoring)"
  },
  {
    "Generic": "Tirofiban",
    "Brand": "Aggrastat",
    "Tags": "Platelet inhibitor, antiplatelet, GP IIb/IIIa",
    "HoldPrior": "4-8 hours",
    "ResumeAfter": "4 Weeks (if have to be given emergently, consider neuro monitoring)",
    "HoldPriorCathRemoval": "Contraindicated while catheter in place",
    "ResumeAfterCathRemoval": "4 Weeks (if have to be given emergently, consider nuro monitoring)"
  },
  {
    "Generic": "Cilostazol",
    "Brand": "Pletal",
    "Tags": "PDE-3 inhibitor, phosphodiesterase III",
    "HoldPrior": "2 days",
    "ResumeAfter": "6 hours (if giving loading dose). Otherwise, can resume maintenance immediately",
    "HoldPriorCathRemoval": "Contraindicated while catheter in place",
    "ResumeAfterCathRemoval": "8 hours"
  },
  {
    "Generic": "Cangrelor",
    "Brand": "Kengreal",
    "Tags": "P2Y12 platelet inhibitor antiplatelet",
    "HoldPrior": "3 hours",
    "ResumeAfter": "8 hours",
    "HoldPriorCathRemoval": "Contraindicated while catheter in place",
    "ResumeAfterCathRemoval": "8 hours"
  },
  {
    "Generic": "Fondaparinux (Low)",
    "Brand": "Arixtra",
    "Tags": "Anti-Xa",
    "HoldPrior": "36-42 hours (depending on age), 58 hours for CrCl 30-50, do not do procedure for CrCl < 30",
    "ResumeAfter": "6 hours",
    "HoldPriorCathRemoval": "Contraindicated while catheter in place",
    "ResumeAfterCathRemoval": "6 hours"
  },
  {
    "Generic": "Fondaparinux (High)",
    "Brand": "Arixtra",
    "Tags": "Anti-Xa",
    "HoldPrior": "70-105 hours (depending on age)",
    "ResumeAfter": "6 hours",
    "HoldPriorCathRemoval": "Contraindicated while catheter in place",
    "ResumeAfterCathRemoval": "6 hours"
  },
  {
    "Generic": "Thrombolytic",
    "Brand": "tPA, TNK, etc.",
    "Tags": "clot buster",
    "HoldPrior": "48 hours (consider checking coags before procedure)",
    "ResumeAfter": "tPA relatively contraindicated within 10 days of procedure",
    "HoldPriorCathRemoval": "Contraindicated while catheter in place",
    "ResumeAfterCathRemoval": "tPA relatively contraindicated within 10 days of procedure"
  },
  {
    "Generic": "Herbal Therapy",
    "Brand": "Garlic, Ginkgo, Ginseng, etc",
    "Tags": "voodoo",
    "HoldPrior": "No need to hold",
    "ResumeAfter": "No need to hold",
    "HoldPriorCathRemoval": "No need to hold",
    "ResumeAfterCathRemoval": "No need to hold"
  },
  {
    "Generic": "Warfarin",
    "Brand": "Coumadin",
    "Tags": "INR",
    "HoldPrior": "5 days (recheck INR prior to procedure)",
    "ResumeAfter": "Can restart Warfarin immediately. Continue neuro assessment for 48 hours after restarting Warfarin",
    "HoldPriorCathRemoval": "Contraindicated while catheter in place; remove when INR < 1.5",
    "ResumeAfterCathRemoval": "Can restart Warfarin immediately. Continue neuro assessment for 48 hours after restarting Warfarin"
  },
];

List<Map<String,String>> acDrugOptions = [
  {
    "Generic": "Abciximab",
    "Brand": "ReoPro",
    "Tags": "Platelet inhibitor, antiplatelet, GP IIb/IIIa",
    "Options": "1",
    "Define": ""
  },
  {
    "Generic": "Apixaban",
    "Brand": "Eliquis",
    "Tags": "DOAC",
    "Options": "2",
    "Define": "**Low Dose**: <= 2.5 mg BID if below criteria not met\n\n**High Dose**: >= 5 mg BID. If patient has 2 of the following, then all doses are high dose:\n* Age >= 80\n* Weight <= 60 kg\n* SCr >= 1.5 mg/dL",
  },
  {
    "Generic": "Cangrelor",
    "Brand": "Kengreal",
    "Tags": "P2Y12 platelet inhibitor antiplatelet",
    "Options": "1",
    "Define": ""
  },
  {
    "Generic": "Cilostazol",
    "Brand": "Pletal",
    "Tags": "PDE-3 inhibitor, phosphodiesterase III",
    "Options": "1",
    "Define": ""
  },
  {
    "Generic": "Clopidogrel",
    "Brand": "Plavix",
    "Tags": "thienopyridine, antiplatelet",
    "Options": "1",
    "Define": ""
  },
  {
    "Generic": "Dabigatran",
    "Brand": "Pradaxa",
    "Tags": "Direct Thrombin Inhibitor, DOAC",
    "Options": "2",
    "Define": "**Low Dose**: 220 mg daily (CrCl > 30)\n\n**High Dose**:\n* 150 mg BID (CrCl > 30)\n* 75 mg BID (CrCl < 30)"
  },
  {
    "Generic": "Edoxaban",
    "Brand": "Savaysa",
    "Tags": "Lixiana, DOAC, Anti-Xa",
    "Options": "1",
    "Define": ""
  },
  {
    "Generic": "Eptifibatide",
    "Brand": "Integrilin",
    "Tags": "Platelet inhibitor, antiplatelet, GP IIb/IIIa",
    "Options": "1",
    "Define": ""
  },
  {
    "Generic": "Fondaparinux",
    "Brand": "Arixtra",
    "Tags": "Anti-Xa",
    "Options": "2",
    "Define": "**Low Dose**: 2.5 mg daily\n\n**High Dose**: 5-10 mg daily"
  },
  {
    "Generic": "Herbal Therapy",
    "Brand": "Garlic, Ginkgo, Ginseng, etc.",
    "Tags": "voodoo",
    "Options": "1",
    "Define": ""
  },
  {
    "Generic": "Heparin, IV Drip",
    "Brand": "UFH",
    "Tags": "gtt, intravenous",
    "Options": "1",
    "Define": ""
  },
  {
    "Generic": "LMWH",
    "Brand": "Enoxaparin, Lovenox",
    "Tags": "lower molecular weight heparin,ppx",
    "Options": "2",
    "Define": "**Low Dose**:\n* Enoxaparin 40 mg daily \n* Enoxaparin 30 mg BID\n* Dalteparin 5000 IU daily\n\n**High Dose**:\n* Enoxaparin 1.5 mg/kg daily\n* Enoxaparin 1 mg/kg BID\n* Dalteparin 200 IU daily\n* Dalteparin 120 IU/kg BID"
  },
  {
    "Generic": "NSAIDs",
    "Brand": "Ibuprofen, Meloxicam, Aspirin, Celecoxib, etc.",
    "Tags": "Ibuprofen,Advil,meloxicam,Aspirin, asa, celebrex",
    "Options": "1",
    "Define": ""
  },
  {
    "Generic": "Prasugrel",
    "Brand": "Effient",
    "Tags": "thienopyridine, antiplatelet",
    "Options": "1",
    "Define": ""
  },
  {
    "Generic": "Rivaroxaban",
    "Brand": "Xarelto",
    "Tags": "DOAC, Anti-Xa",
    "Options": "2",
    "Define": "**Low Dose**: 10 mg daily\n\n**High Dose**: 15 mg daily"
  },
  {
    "Generic": "Heparin, Sub-Q",
    "Brand": "UFH",
    "Tags": "subcutaneous, SQH, UFH",
    "Options": "3",
    "Define": "**Low Dose**: 5000U BID-TID\n\n**Med Dose**: 7,500-10,000U BID\n\n**High Dose**: > 10,000 U BID"
  },
  {
    "Generic": "Thrombolytic",
    "Brand": "tPA, TNK, etc.",
    "Tags": "clot buster",
    "Options": "1",
    "Define": ""
  },
  {
    "Generic": "Ticagrelor",
    "Brand": "Brilinta",
    "Tags": "P2Y12 platelet inhibitor antiplatelet",
    "Options": "1",
    "Define": ""
  },
  {
    "Generic": "Tirofiban",
    "Brand": "Aggrastat",
    "Tags": "Platelet inhibitor, antiplatelet, GP IIb/IIIa",
    "Options": "1",
    "Define": ""
  },
  {
    "Generic": "Warfarin",
    "Brand": "Coumadin",
    "Tags": "INR",
    "Options": "1",
    "Define": ""
  }
];