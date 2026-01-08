import 'package:wikianesthesia_mobile/Calculators/calculator_scaffold.dart';
import 'package:wikianesthesia_mobile/Calculators/equipment.dart';
import 'package:wikianesthesia_mobile/Calculators/patient_demo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DemoWidget extends ConsumerStatefulWidget {
  final _textController = TextEditingController();

  final String name;
  final List<String> units;
  final String defaultUnit;
  final String initialVal;

  late final List<DropdownMenuEntry> dropdownMenuEntries;

  DemoWidget({required this.name, required this.units, required this.defaultUnit, required this.initialVal, super.key}) {
    dropdownMenuEntries = units.map((unit) => DropdownMenuEntry(value: unit, label: unit)).toList();
  }

  @override
  ConsumerState<DemoWidget> createState() => _DemoWidgetState();
}

class _DemoWidgetState extends ConsumerState<DemoWidget> {
  bool initialized = false;
  String selectedUnit = '';

  @override
  void initState() {
    super.initState();  
    selectedUnit = widget.defaultUnit;
  }

  void update() {
    ref.read(patientDemoProvider.notifier).setDemo(widget._textController.text, selectedUnit, widget.name);
  }

  @override
  Widget build(BuildContext context) {
    final Patient patientState = ref.watch(patientDemoProvider);
    final Map<String,dynamic> patientDemo = patientState.toMap();
    // Check if the text controller has been initialized
    if (!initialized) {
      // Set the initial value of the text controller to the current value in the state
      widget._textController.value = TextEditingValue(text: (patientDemo[widget.name] ?? '').toString());
      initialized = true;
    }

    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 60,
              child: TextFormField(
                controller: widget._textController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                ],
                maxLines: 1,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                decoration: InputDecoration(
                  //contentPadding: const EdgeInsets.only(top: 30.0,),
                  labelText: widget.name,
                  alignLabelWithHint: true,
                  //isDense: true,
                  constraints: BoxConstraints.tight(const Size.fromHeight(50)), 
                ),
                onChanged: (value) => update(),
              ),
            ),
            const SizedBox(width: 10,),
            SizedBox(
              child: DropdownMenu(
                textAlign: TextAlign.center,
                width: 85,
                trailingIcon: Transform.translate(offset: const Offset(5,0), child: const Icon(Icons.arrow_drop_down),),
                label: const Text(''),
                inputDecorationTheme: InputDecorationTheme(
                  //contentPadding: const EdgeInsets.all(0),
                  //isDense: true,
                  constraints: BoxConstraints.tight(const Size.fromHeight(50)),
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                ),
                dropdownMenuEntries: widget.dropdownMenuEntries,
                initialSelection: selectedUnit,
                onSelected: (value) => setState(() {
                  selectedUnit = value as String;
                  update();
                }),
              ),
            )
          ],
        )
      ],
    );
  }
}

class SexWidget extends ConsumerStatefulWidget {
  final _textController = TextEditingController();

  SexWidget({super.key});

  @override
  ConsumerState<SexWidget> createState() => _SexWidgetState();
}

class _SexWidgetState extends ConsumerState<SexWidget> {
  bool initialized = false;

  @override
  void initState() {
    super.initState();
  }

  void update(WidgetRef ref) {
    ref.read(patientDemoProvider.notifier).setDemo(widget._textController.text, '', 'Sex');
  }

  @override
  Widget build(BuildContext context) {
    final Patient patientState = ref.watch(patientDemoProvider);
    final Map<String,dynamic> patientDemo = patientState.toMap();

    // Check if the text controller has been initialized
    if (!initialized) {
      // Set the initial value of the text controller to the current value in the state
      widget._textController.value = TextEditingValue(text: patientDemo['Sex'] ?? '');
      initialized = true;
    }

    return DropdownMenu(
      width: 90,
      label: const Text('Sex'),
      inputDecorationTheme: InputDecorationTheme(
          //contentPadding: const EdgeInsets.all(0),
          //isDense: true,
          constraints: BoxConstraints.tight(const Size.fromHeight(50)),
          //visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          alignLabelWithHint: true,
        ),
      controller: widget._textController,
      dropdownMenuEntries: const [
        DropdownMenuEntry(value: 'M', label: 'M'),
        DropdownMenuEntry(value: 'F', label: 'F'),
      ],
      onSelected: (value) => update(ref),
    );
  }
}



class PatientWidget extends StatelessWidget {
  const PatientWidget({super.key});

  @override
  Widget build(BuildContext context){
    return LayoutBuilder(
      builder: (context,constraints) {
        Widget choice;

        if (constraints.maxWidth < 650) {
          choice = const PatientWidgetNarrow();
        } else {
          choice = const PatientWidgetWide();
        }

        return choice;
      }
    );
  }
}

class PatientWidgetNarrow extends StatelessWidget {
  const PatientWidgetNarrow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Demographics', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: PatientBodyNarrow(),
        ),
      ],
    );
  }
}

class PatientWidgetWide extends StatelessWidget {
  const PatientWidgetWide({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Demographics', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
        SizedBox(height: 10,),
        PatientBodyWide(),
        SizedBox(height: 10,),
      ],
    );
  }
}


class PatientBodyWide extends StatelessWidget {
  const PatientBodyWide({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DemoWidget(
          name: 'Weight',
          units: const ['kg','lbs','g'],
          defaultUnit: 'kg',
          initialVal: '70',
        ),
        const Spacer(flex: 2),
        DemoWidget(
          name: 'Height',
          units: const ['cm','m','in','ft'],
          defaultUnit: 'cm',
          initialVal: '170',
        ),
        const Spacer(flex: 2),
        DemoWidget(
          name: 'Age',
          units: const ['yr','mo','d'],
          defaultUnit: 'yr',
          initialVal: '40',
        ),
        const Spacer(flex: 2),
        SexWidget(),
      ],
    );
  }
}

class PatientBodyNarrow extends StatelessWidget {
  const PatientBodyNarrow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DemoWidget(
          name: 'Weight',
          units: const ['kg','lbs','g'],
          defaultUnit: 'kg',
          initialVal: '70',
        ),
        const SizedBox(width: 10),
        DemoWidget(
          name: 'Height',
          units: const ['cm','m','in','ft'],
          defaultUnit: 'cm',
          initialVal: '170',
        ),
        const SizedBox(width: 10),
        SexWidget(),
      ],
    );
  }
}

class CalculatedWeightsWide extends ConsumerWidget {
  const CalculatedWeightsWide({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Patient patientState = ref.watch(patientDemoProvider);
    TextStyle defaultStyle = const TextStyle(color: Colors.black, fontSize: 15.0);
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          //const SizedBox(width: 20,),
          RichText(
            text: TextSpan(
              style: defaultStyle,
              children: <TextSpan>[
                const TextSpan(text: 'BMI: ', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: patientState.bmi?.toStringAsFixed(1) ?? 'N/A'),
              ],
            ),
          ),
          const SizedBox(width: 20,),
          RichText(
            text: TextSpan(
              style: defaultStyle,
              children: <TextSpan>[
                const TextSpan(text: 'IBW: ', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: patientState.ibw != null ? '${patientState.ibw?.toStringAsFixed(1)} kg' : 'N/A'),
              ],
            ),
          ),
          const SizedBox(width: 20,),
          RichText(
            text: TextSpan(
              style: defaultStyle,
              children: <TextSpan>[
                const TextSpan(text: 'LBW: ', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: patientState.lbw != null ? '${patientState.lbw?.toStringAsFixed(1)} kg' : 'N/A'),
              ],
            ),
          ),
          //const SizedBox(width: 20,),
        ],
      ),
    );
  }
}

class CalculatedWeightsNarrow extends ConsumerWidget {
  const CalculatedWeightsNarrow({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Patient patientState = ref.watch(patientDemoProvider);
    TextStyle defaultStyle = const TextStyle(color: Colors.black, fontSize: 16.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10,),
        RichText(
          text: TextSpan(
            style: defaultStyle,
            children: <TextSpan>[
              const TextSpan(text: 'BMI: ', style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: patientState.bmi?.toStringAsFixed(1) ?? 'N/A'),
            ],
          ),
        ),
        const SizedBox(height: 10,),
        RichText(
          text: TextSpan(
            style: defaultStyle,
            children: <TextSpan>[
              const TextSpan(text: 'IBW: ', style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: patientState.ibw != null ? '${patientState.ibw?.toStringAsFixed(1)} kg' : 'N/A'),
            ],
          ),
        ),
        const SizedBox(height: 10,),
        RichText(
          text: TextSpan(
            style: defaultStyle,
            children: <TextSpan>[
              const TextSpan(text: 'LBW: ', style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: patientState.lbw != null ? '${patientState.lbw?.toStringAsFixed(1)} kg' : 'N/A'),
            ],
          ),
        ),
      ],
    );
  }
}

class DemographicsPage extends StatelessWidget {
  const DemographicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CalculatorScaffold(
      title: 'Body Composition',
      child: PatientWidget(),
    );
  }
}

class EquipmentPage extends StatelessWidget {
  const EquipmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
      title: 'Equipment',
      child: ListView(
        children: const [
          PatientWidget(),
          AirwayEquipment(),
          VascularEquipment()
        ]
      ),
    );
  }
}
