
class RangeSelector {
  static List productRange = [
    RangeFilterModel(label: 'All Items', value: 1),
    RangeFilterModel(label: 'Single', value: 2),
    RangeFilterModel(label: 'Range', value: 3),
    RangeFilterModel(label: 'Item Class', value: 4),
    RangeFilterModel(label: 'Item Category', value: 5),
    RangeFilterModel(label: 'Item Brand', value: 6),
    RangeFilterModel(label: 'Manufacturer', value: 7),
    RangeFilterModel(label: 'Origin', value: 8),
    RangeFilterModel(label: 'Style', value: 9),
  ];

  static List salesPersonRange = [
    RangeFilterModel(label: 'All Salespersons', value: 1),
    RangeFilterModel(label: 'Single', value: 2),
    RangeFilterModel(label: 'Range', value: 3),
    RangeFilterModel(label: 'Division', value: 4),
    RangeFilterModel(label: 'Group', value: 5),
    RangeFilterModel(label: 'Area', value: 6),
    RangeFilterModel(label: 'Country', value: 7),
  ];
}

class RangeFilterModel {
  RangeFilterModel({
    required this.label,
    required this.value,
  });
  String label;
  int value;
}
