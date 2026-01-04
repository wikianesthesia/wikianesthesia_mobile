import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:wikianesthesia_mobile/Calculators/calculator_scaffold.dart';
import 'package:wikianesthesia_mobile/Calculators/patient_demo.dart';
import 'package:wikianesthesia_mobile/Calculators/patient_widget.dart';
import 'package:wikianesthesia_mobile/LocalAnesthetics/local_anesthetics.dart';

class LocalCalc extends ConsumerStatefulWidget {
  const LocalCalc({super.key});

  @override
  ConsumerState<LocalCalc> createState() => _LocalCalcState();
}

class _LocalCalcState extends ConsumerState<LocalCalc> {
  String patientWeightChoice = '';
  Patient patient = Patient();

  List<AdministeredDrug> administered = [];
  List<DesiredDrug> desired = [];
  List<double> desiredMaxDoses = [];
  List<double> desiredRemainingDoses = [];
  List<double> adminMaxDoses = [];

  List<Widget> administeredRows = [];
  List<Widget> desiredRows = [];

  Map<int,int> adminIdxMap = {};
  Map<int,int> desiredIdxMap = {};

  @override
  void initState() {
    super.initState();
    patient = ref.read(patientDemoProvider);
    addDesiredDrug();
  }

  void addAdministeredDrug() {
    int idx = administered.length;
    // Adds a new administered drug entry
    setState(() {
      administered.add(AdministeredDrug(drug: allLocalAnesthetics[0], concentration: allLocalAnesthetics[0].concs[0], epi: false, volume: 0.0));
      administeredRows.add(AdminDrugNarrow(
        onAdminDrugChanged: changeAdminDrug,
        selectedDrug: allLocalAnesthetics[0].name,
        onAdminConcChanged: changeAdminConc,
        selectedEpi: false, index: idx,
        onAdminEpiChanged: changeAdminEpi,
        selectedConc: allLocalAnesthetics[0].concs[0],
        onAdminVolChanged: changeAdminVol,
        onDelete: deleteAdmin,
        maxDose: 0.0,
      ));
      adminIdxMap[idx] = administeredRows.length - 1;
      adminMaxDoses.add(0.0);
      calc();
    });
  }

  void changeAdminDrug(String drugName, int index) {
    String trimmedName = drugName.replaceAll(' w/ Epi', '');
    bool epi = drugName.contains('w/ Epi');

    // Changes the drug at the given index
    int rowIdx = adminIdxMap[index]!;
    setState(() {
      LocalAnesthetic selectedDrug = allLocalAnesthetics.firstWhere((la) => la.name == trimmedName, orElse: () => allLocalAnesthetics[0]);
      administered[index] = AdministeredDrug(drug: selectedDrug, concentration: selectedDrug.concs[0], epi: epi, volume: administered[index].volume);
      administeredRows[rowIdx] = AdminDrugNarrow(
        onAdminDrugChanged: changeAdminDrug,
        selectedDrug: administered[index].drug.name,
        onAdminConcChanged: changeAdminConc,
        selectedEpi: administered[index].epi,
        index: index, onAdminEpiChanged: changeAdminEpi,
        selectedConc: administered[index].concentration,
        onAdminVolChanged: changeAdminVol,
        onDelete: deleteAdmin,
        maxDose: 0.0,
      );
      calc();
    });
  }

  void changeAdminConc(double conc, int index) {
    // Changes the concentration at the given index
    setState(() {
      administered[index] = AdministeredDrug(drug: administered[index].drug, concentration: conc, epi: administered[index].epi, volume: administered[index].volume);
      calc();
    });
  }

  void changeAdminEpi(bool epi, int index) {
    int rowIdx = adminIdxMap[index]!;
    // Changes the epi status at the given index
    setState(() {
      administered[index] = AdministeredDrug(drug: administered[index].drug, concentration: administered[index].concentration, epi: epi, volume: administered[index].volume);

      // Update the rendered row since checkboxes don't automatically flip
      administeredRows[rowIdx] = AdminDrugNarrow(
        maxDose: 0.0,
        onAdminDrugChanged: changeAdminDrug,
        selectedDrug: administered[index].drug.name,
        onAdminConcChanged: changeAdminConc,
        selectedEpi: administered[index].epi,
        index: index, onAdminEpiChanged: changeAdminEpi,
        selectedConc: administered[index].concentration,
        onAdminVolChanged: changeAdminVol,
        onDelete: deleteAdmin,
      );
      calc();
    });
  }

  void changeAdminVol(double vol, int index) {
    // Changes the volume at the given index
    setState(() {
      administered[index] = AdministeredDrug(drug: administered[index].drug, concentration: administered[index].concentration, epi: administered[index].epi, volume: vol);
      calc();
    });
  }

  void deleteAdmin(int index) {
    // Deletes the administered drug at the given index
    int rowIdx = adminIdxMap[index]!;
    setState(() {
      // Mark administered drug as inactive
      administered[index] = AdministeredDrug(drug: administered[index].drug, concentration: administered[index].concentration, epi: administered[index].epi, volume: administered[index].volume, active: false);

      // Remove the row from the table
      administeredRows.removeAt(rowIdx);
      adminIdxMap.remove(index);

      // Update indices in the map
      for (var entry in adminIdxMap.entries) {
        if (entry.key > index && entry.value > rowIdx) { 
          adminIdxMap[entry.key] = entry.value - 1;
        }
      }
    });

    calc();
  }

  void addDesiredDrug() {
    // Adds a new desired drug entry
    int idx = desired.length;
    setState(() {
      desired.add(DesiredDrug(drug: allLocalAnesthetics[0], concentration: allLocalAnesthetics[0].concs[0], epi: false));
      desiredMaxDoses.add(0.0);
      desiredRemainingDoses.add(0.0);

      desiredRows.add(
        DesiredDrugNarrow(
          index: idx,
          changeDrug: changeDesiredDrug,
          changeConc: changeDesiredConc,
          changeEpi: changeDesiredEpi,
          selectedDrug: desired[idx].drug.name,
          selectedConc: desired[idx].concentration,
          selectedEpi: desired[idx].epi,
          maxDose: desiredMaxDoses[idx],
          remainingDose: desiredRemainingDoses[idx],
          onDelete: deleteDesired,
        )
      );

      desiredIdxMap[idx] = desiredRows.length - 1;

      calc();
    });
  }

  void changeDesiredDrug(String drugName, int index) {
    String trimmedName = drugName.replaceAll(' w/ Epi', '');
    bool epi = drugName.contains('w/ Epi');

    // Changes the drug at the given index
    int rowIdx = desiredIdxMap[index]!;
    
    setState(() {
      LocalAnesthetic selectedDrug = allLocalAnesthetics.firstWhere((la) => la.name == trimmedName, orElse: () => allLocalAnesthetics[0]);
      desired[index] = DesiredDrug(drug: selectedDrug, concentration: selectedDrug.concs[0], epi: epi);
      desiredRows[rowIdx] = DesiredDrugNarrow(
        index: index,
        changeDrug: changeDesiredDrug,
        changeConc: changeDesiredConc,
        changeEpi: changeDesiredEpi,
        selectedDrug: desired[index].drug.name,
        selectedConc: desired[index].concentration,
        selectedEpi: desired[index].epi,
        maxDose: desiredMaxDoses[index],
        remainingDose: desiredRemainingDoses[index],
        onDelete: deleteDesired,);
    });
    calc();
  }

  void changeDesiredConc(double conc, int index) {
    // Changes the concentration at the given index
    setState(() {
      desired[index] = DesiredDrug(drug: desired[index].drug, concentration: conc, epi: desired[index].epi);
      calc();
    });
  }

  void changeDesiredEpi(bool epi, int index) {
    // Changes the epi status at the given index
    setState(() {
      desired[index] = DesiredDrug(drug: desired[index].drug, concentration: desired[index].concentration, epi: epi);
      calc();
    });
  }

  void deleteDesired(int index) {
    // Deletes the administered drug at the given index
    int rowIdx = desiredIdxMap[index]!;
    setState(() {
      // Mark desired drug as inactive
      desired[index] = DesiredDrug(drug: desired[index].drug, concentration: desired[index].concentration, epi: desired[index].epi, active: false);

      // Remove the row from the table
      desiredRows.removeAt(rowIdx);
      desiredIdxMap.remove(index);

      // Update indices in the map
      for (var entry in desiredIdxMap.entries) {
        if (entry.key > index && entry.value > rowIdx) { 
          desiredIdxMap[entry.key] = entry.value - 1;
        }
      }
    });

    calc();
  }

  void calc() {
    // Calculates the desired drugs based on administered and patient info
    double dosingWeight;

    if (patient.lbw != null) {
      dosingWeight = patient.lbw!;
      patientWeightChoice = 'LBW';
    } else if (patient.weight != null) {
      dosingWeight = patient.weight!;
      patientWeightChoice = 'Total';
    } else {
      dosingWeight = -1; // Default weight
      patientWeightChoice = 'N/A';
    }

    if (dosingWeight <= 0) {
      // Cannot calculate without weight
      setState(() {
        desiredMaxDoses = List.filled(desired.length, -1, growable: true,);
        desiredRemainingDoses = List.filled(desired.length, -1, growable: true,);
        adminMaxDoses = List.filled(administered.length, -1, growable: true,);
      });
      renderUI();
      return;
    }

    setState(() {
      // Calculate total normalized dose for all local anesthetics given
      double totalAdmin = 0;
      for (int i = 0; i < administered.length; i++) {
        var admin = administered[i];
        if (admin.active) {
          double maxDosemg = (admin.epi ? admin.drug.maxDosewEpi : admin.drug.maxDosewoEpi) * dosingWeight;
          double maxDose = maxDosemg / (admin.concentration * 10); // in mL
          adminMaxDoses[administered.indexOf(admin)] = maxDose;
          totalAdmin += admin.volume / maxDose;
        }
      }

      // Calculate remaining dose for each desired drug
      for (int i = 0; i < desired.length; i++) {
        double maxDosemg = (desired[i].epi ? desired[i].drug.maxDosewEpi : desired[i].drug.maxDosewoEpi) * dosingWeight;
        double maxDose = maxDosemg / (desired[i].concentration * 10); // in mL
        desiredMaxDoses[i] = maxDose;

        double remainingDose = maxDose * (1 - totalAdmin);
        if (remainingDose < 0) remainingDose = -2; // Indicate overdose
        desiredRemainingDoses[i] = remainingDose;
      }
    });

    renderUI();
  }

  void renderUI() {
    // Renders Desired Drug Rows based on calculated doses
    setState(() {
      for (int i = 0; i < administered.length; i++) {
        if (adminIdxMap[i] == null) continue;
        int rowIdx = adminIdxMap[i]!;
        administeredRows[rowIdx] = AdminDrugNarrow(
          index: i,
          onAdminDrugChanged: changeAdminDrug,
          selectedDrug: administered[i].drug.name,
          onAdminConcChanged: changeAdminConc,
          selectedEpi: administered[i].epi,
          onAdminEpiChanged: changeAdminEpi,
          selectedConc: administered[i].concentration,
          onAdminVolChanged: changeAdminVol,
          onDelete: deleteAdmin,
          maxDose: adminMaxDoses[i],
        );
      }
      for (int i = 0; i < desired.length; i++) {
        if (desiredIdxMap[i] == null) continue;
        int rowIdx = desiredIdxMap[i]!;
        desiredRows[rowIdx] = DesiredDrugNarrow(
          index: i,
          changeDrug: changeDesiredDrug,
          changeConc: changeDesiredConc,
          changeEpi: changeDesiredEpi,
          selectedDrug: desired[i].drug.name,
          selectedConc: desired[i].concentration,
          selectedEpi: desired[i].epi,
          maxDose: desiredMaxDoses[i],
          remainingDose: desiredRemainingDoses[i],
          onDelete: deleteDesired,);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<Patient>(patientDemoProvider, (previous, next) {
      setState(() {
        patient = next;
        calc();
      });
    });

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const PatientWidget(),
              const SizedBox(height: 10),
                            const Divider(height: 20),
              const Text('Plan to Administer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              if (desiredMaxDoses.any((dose) => dose < 0))
                const ListTile(
                  leading: Icon(Icons.error, color: Colors.red),
                  visualDensity: VisualDensity.compact,
                  
                  title: Text('Please enter patient weight.', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14)),
                ),
              if (patientWeightChoice == 'Total')
                const ListTile(
                  visualDensity: VisualDensity.compact,
                  leading: SizedBox(height: double.infinity, child: Icon(Icons.warning, color: Colors.orange,)),
                  title: Text('Using total weight instead of LBW.', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),),
                ),
              if (desiredRows.isNotEmpty)
                ...desiredRows,
              const Divider(height: 30),
              const Text('Previously Administered', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              if (administeredRows.isNotEmpty)
                ...administeredRows,
              const SizedBox(height: 5),
              ElevatedButton.icon(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Set border radius
                  ),
                ),
                onPressed: addAdministeredDrug,
                icon: const Icon(Icons.add,color: Colors.green),
                label: const Text('Add Drug'),
              ),

              // ElevatedButton.icon(
              //   style: OutlinedButton.styleFrom(
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8), // Set border radius
              //     ),
              //   ),
              //   onPressed: addDesiredDrug,
              //   icon: const Icon(Icons.add,color: Colors.green),
              //   label: const Text('Add Drug')
              // )
            ],)
        ),
      ),
    );
  }
}

class LASelector extends StatelessWidget {
  final int index;
  final void Function(String,int) onChanged;
  final String selected;
  final double fontSize;
  
  const LASelector({super.key, required this.index, required this.onChanged, required this.selected, this.fontSize=14});


  @override
  Widget build(BuildContext context) {
    final List<String> allLocalwEpi = [];
    for (var la in allLocalAnesthetics) {
      allLocalwEpi.add(la.name);
      allLocalwEpi.add('${la.name} w/ Epi');
    }

    return DropdownMenu(
      label: const Text('Local', style: TextStyle(fontSize: 14),),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        constraints: BoxConstraints.tight(const Size.fromHeight(50)), 
      ),
      textStyle: TextStyle(fontSize: fontSize, overflow: TextOverflow.ellipsis),
      dropdownMenuEntries: allLocalwEpi.map((la) => DropdownMenuEntry(value: la, label: la, labelWidget: Text(la,overflow: TextOverflow.ellipsis,))).toList(),
      onSelected: (String? value) {
        onChanged(value ?? allLocalAnesthetics[0].name, index);
      },
      initialSelection: selected,
    
    );
  }
}

class DoseSelector extends StatelessWidget {
  final LocalAnesthetic drug;
  final int index;
  final double selectedConc;
  final void Function(double,int) onChanged;
  const DoseSelector({super.key, required this.drug, required this.index, required this.onChanged, required this.selectedConc});

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      width: 105,
      enableSearch: false,
      enableFilter: false,
      label: const Text('Conc %', style: TextStyle(fontSize: 14)),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        constraints: BoxConstraints.tight(const Size.fromHeight(50)), 
      ),
      textStyle: const TextStyle(fontSize: 14),
      dropdownMenuEntries: drug.concs.map((conc) => DropdownMenuEntry(value: conc, label: '$conc')).toList(),
      initialSelection: selectedConc,
      onSelected: (double? value) {
        onChanged(value ?? drug.concs[0], index);
      },
    );
  }
}

class EpiSelector extends StatelessWidget {
  final int index;
  final void Function(bool,int) onChanged;
  final bool selected;
  const EpiSelector({super.key, required this.index, required this.onChanged, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: selected,
          visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
          //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onChanged: (bool? value) {
            onChanged(value ?? false, index);
          },
        ),
        const Text('w/ Epi'),
      ],
    );
  }
}

class AdministeredVolumeField extends StatelessWidget {
  final int index;
  final void Function(double,int) onChanged;
  const AdministeredVolumeField({super.key, required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        isDense: true,
        constraints: BoxConstraints.tight(const Size.fromHeight(50)), 
        label: const Text('mL'),
      ),
      onChanged: (value) {
        onChanged(double.tryParse(value) ?? 0.0, index);
      },
    );
  }
}

class DeleteButton extends StatelessWidget {
  final int index;
  final void Function(int) onPressed;
  const DeleteButton({super.key, required this.index, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed(index);
      },
      child: Ink(
        color: Colors.red.shade200,
        child: const Padding(
          padding: EdgeInsets.all(2.0),
          child: Icon(Icons.delete),
        ),
      ),
    );
  }
}

class AdminDrugNarrow extends StatelessWidget {
  final int index;

  final void Function(String, int) onAdminDrugChanged;
  final String selectedDrug;

  final void Function(double, int) onAdminConcChanged;
  final double selectedConc;

  final void Function(bool, int) onAdminEpiChanged;
  final bool selectedEpi;

  final void Function(double, int) onAdminVolChanged;

  final void Function(int) onDelete;

  final double maxDose;

  const AdminDrugNarrow({super.key,
                         required this.onAdminDrugChanged,
                         required this.selectedDrug,
                         required this.onAdminConcChanged,
                         required this.selectedEpi,
                         required this.index,
                         required this.onAdminEpiChanged,
                         required this.selectedConc,
                         required this.onAdminVolChanged,
                         required this.onDelete,
                         required this.maxDose});

  @override
  Widget build(BuildContext context) {
    LocalAnesthetic drug = allLocalAnesthetics.firstWhere((la) => la.name == selectedDrug, orElse: () => allLocalAnesthetics[0]);
    double mgkgDose = (selectedEpi ? drug.maxDosewEpi : drug.maxDosewoEpi);
    
    return Card(
      clipBehavior: Clip.hardEdge,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                            Expanded(child: LASelector(index: index, onChanged: onAdminDrugChanged, selected: selectedEpi ? '$selectedDrug w/ Epi' : selectedDrug, fontSize: 12.5)),
                            const SizedBox(width: 5),
                            DoseSelector(index: index, drug: allLocalAnesthetics.firstWhere((la) => la.name == selectedDrug, orElse: () => allLocalAnesthetics[0]), onChanged: onAdminConcChanged, selectedConc: selectedConc),
                            const SizedBox(width: 5),
                            SizedBox(height: 50, width: 40,child: AdministeredVolumeField(index: index, onChanged: onAdminVolChanged,)),
                          ],
                    ),
                    const SizedBox(height: 10),
                    AdminDrugDoses(maxDose: maxDose, mgkgDose: mgkgDose)
                  ],
                ),
              ),
            ),
            DeleteButton(index: index, onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}

const rowSpacer = TableRow(children: [SizedBox(height: 5), SizedBox(height: 5), SizedBox(height: 5)]);

class DesiredDrugDoses extends StatelessWidget {
  final double maxDose;
  final double remainingDose;
  final double mgkgDose;
  
  const DesiredDrugDoses({super.key, required this.maxDose, required this.remainingDose, required this.mgkgDose});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Row(
      children: [
        const Spacer(flex: 1),
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 16, color: theme.textTheme.bodyMedium?.color),
            children: [
              const TextSpan(text: 'Remaining: ', style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: switch (remainingDose) {
                  -2 => 'OVER',
                  -1 => 'N/A',
                  _ => '${remainingDose.toStringAsFixed(1)} mL'
                },
                style: switch(remainingDose) {
                  -2 => const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  -1 => const TextStyle(fontStyle: FontStyle.italic),
                  _ => const TextStyle(),
                },
              )
            ],
          ),
        ),
        const Spacer(flex: 1),
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 16, color: theme.textTheme.bodyMedium?.color),
            children: [
              const TextSpan(text: 'Max: ', style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: switch (maxDose) {
                  -1 => 'N/A',
                  _ => '${maxDose.toStringAsFixed(1)} mL (${mgkgDose.toStringAsFixed(1)} mg/kg)'
                },
                style: switch(maxDose) {
                  -1 => const TextStyle(fontStyle: FontStyle.italic),
                  _ => const TextStyle(),
                },
              )
            ],
          ),
        ),
        const Spacer(flex: 1),
      ],
  );
  }
}

class AdminDrugDoses extends StatelessWidget {
  final double maxDose;
  final double mgkgDose;
  
  const AdminDrugDoses({super.key, required this.maxDose, required this.mgkgDose});

  @override
  Widget build(BuildContext context) {
    
    return Center(
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodyMedium?.color),
          children: [
            const TextSpan(text: 'Max Dose: ', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: switch (maxDose) {
                -1 => 'N/A',
                _ => '${maxDose.toStringAsFixed(1)} mL (${mgkgDose.toStringAsFixed(1)} mg/kg)'
              },
              style: switch(maxDose) {
                -1 => const TextStyle(fontStyle: FontStyle.italic),
                _ => const TextStyle(),
              },
            )
          ],
        ),
      ),
    );
  }
}

class DesiredDrugNarrow extends StatelessWidget {
  final int index;
  final Function(String, int) changeDrug;
  final Function(double, int) changeConc;
  final Function(bool, int) changeEpi;

  final String selectedDrug;
  final double selectedConc;
  final bool selectedEpi;

  final double maxDose;
  final double remainingDose;

  final void Function(int) onDelete;

  const DesiredDrugNarrow({super.key,
                           required this.index,
                           required this.changeDrug,
                           required this.changeConc,
                           required this.changeEpi,
                           required this.selectedDrug,
                           required this.selectedConc,
                           required this.selectedEpi,
                           required this.maxDose,
                           required this.remainingDose,
                           required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final LocalAnesthetic drug = allLocalAnesthetics.firstWhere((la) => la.name == selectedDrug, orElse: () => allLocalAnesthetics[0]);    
    double mgkgDose = (selectedEpi ? drug.maxDosewEpi : drug.maxDosewoEpi);

    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            LASelector(index: index, onChanged: changeDrug, selected: selectedEpi ? '$selectedDrug w/ Epi' : selectedDrug),
            const Spacer(),
            DoseSelector(index: index, drug: allLocalAnesthetics.firstWhere((la) => la.name == selectedDrug, orElse: () => allLocalAnesthetics[0]), onChanged: changeConc, selectedConc: selectedConc,),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 10),
        DesiredDrugDoses(maxDose: maxDose, remainingDose: remainingDose, mgkgDose: mgkgDose),
      ],
    );
    
    // Card(
    //   clipBehavior: Clip.hardEdge,
    //   child: IntrinsicHeight(
    //     child: Row(
    //       crossAxisAlignment: CrossAxisAlignment.stretch,
    //       children: [
    //         Expanded(
    //           child: Padding(
    //             padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
    //             child: Table(
    //               defaultVerticalAlignment: TableCellVerticalAlignment.middle,
    //               columnWidths: const {
    //                 0: FlexColumnWidth(2),
    //                 1: FixedColumnWidth(10),
    //                 2: FlexColumnWidth(2),
    //               },
    //               children: [
    //                 TableRow(
    //                   children: [
    //                     LASelector(index: index, onChanged: changeDrug, selected: selectedDrug),
    //                     const SizedBox(width: 10),
    //                     EpiSelector(index: index, onChanged: changeEpi, selected: selectedEpi),
    //                   ],
    //                 ),
    //                 rowSpacer,
    //                 TableRow(
    //                   children: [
    //                     DoseSelector(index: index, drug: allLocalAnesthetics.firstWhere((la) => la.name == selectedDrug, orElse: () => allLocalAnesthetics[0]), onChanged: changeConc, selectedConc: selectedConc,),
    //                     const SizedBox(width: 10),
    //                     Padding(
    //                       padding: const EdgeInsets.only(left: 5.0),
    //                       child: MarkdownBody(
    //                         shrinkWrap: true,
    //                         data: '*Max Dose*: ${maxDose > 0 ? '${maxDose.toStringAsFixed(1)} mL' : 'N/A'}  \n*Remaining*: ${remainingDose > 0 ? '${remainingDose.toStringAsFixed(1)} mL' : 'N/A'}'
    //                       ),
    //                     ),
    //                   ],
    //                 )
    //               ]
    //             ),
    //           ),
    //         ),
    //         DeleteButton(index: index, onPressed: onDelete),
    //       ],
    //     ),
    //   ),
    // );
  }
}

class AdministeredDrug {
  final LocalAnesthetic drug;
  final double concentration;
  final bool epi;
  final double volume;
  final bool active;
  const AdministeredDrug({required this.drug, required this.concentration, required this.epi, required this.volume, this.active=true});
}

class DesiredDrug {
  final LocalAnesthetic drug;
  final double concentration;
  final bool epi;
  final bool active;

  const DesiredDrug({required this.drug, required this.concentration, required this.epi, this.active=true});
}

class LocalPage extends StatelessWidget {
  const LocalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CalculatorScaffold(title: 'Local Anesthetic Dosing', child: LocalCalc());
  }
}