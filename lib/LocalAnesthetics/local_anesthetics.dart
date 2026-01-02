class LocalAnesthetic {
  final String name;
  final List<double> concs; //in %
  final double maxDosewoEpi; // in mg/kg
  final double maxDosewEpi; // in mg/kg

  LocalAnesthetic({
    required this.name,
    required this.concs,
    required this.maxDosewoEpi,
    required this.maxDosewEpi,
  });

}

final List<LocalAnesthetic> allLocalAnesthetics = [
  LocalAnesthetic(
    name: 'Lidocaine',
    concs: [0.5, 1.0, 1.5, 2.0, 3.0, 4.0, 5.0],
    maxDosewoEpi: 5,
    maxDosewEpi: 7.0,
  ),
  LocalAnesthetic(
    name: 'Bupivacaine',
    concs: [0.25, 0.5, 0.75],
    maxDosewoEpi: 2.5,
    maxDosewEpi: 3.0,
  ),
  LocalAnesthetic(
    name: 'Ropivacaine',
    concs: [0.2, 0.375, 0.5, 0.75, 1.0],
    maxDosewoEpi: 3.0,
    maxDosewEpi: 3.0,
  ),
  LocalAnesthetic(
    name: 'Mepivacaine',
    concs: [0.5, 1.0, 1.5, 2.0, 3.0, 4.0],
    maxDosewoEpi: 7.0,
    maxDosewEpi: 8.0,
  ),
  LocalAnesthetic(
    name: 'Chloroprocaine',
    concs: [1.0, 2.0, 3.0],
    maxDosewoEpi: 12.0,
    maxDosewEpi: 14.0,
  ),
  LocalAnesthetic(
    name: 'Procaine',
    concs: [1.0, 2.0, 10.0],
    maxDosewoEpi: 7,
    maxDosewEpi: 10)
  // Add more local anesthetics as needed
];