import 'package:flutter/material.dart';

class CustomTable extends StatefulWidget {
  final List<dynamic> dataList;
  final void Function(String) onChanged;

  const CustomTable(
      {super.key, required this.dataList, required this.onChanged});

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  List<DataRow> dataRows = [];

  @override
  void initState() {
    super.initState();
    dataRows = widget.dataList.asMap().entries.map((entry) {
      final index = entry.key;
      bool selected = false;

      return DataRow(
        selected: selected,
        onSelectChanged: (value) {
          setState(() {
            selected = value ?? false;
            updateSelectedRows(index);
          });
        },
        cells: [
          DataCell(Text(entry.value['name'])),
          DataCell(Text(entry.value['game_type'])),
          DataCell(Text(entry.value['host'])),
        ],
      );
    }).toList();
  }

  void updateSelectedRows(selectedIndex) {
    for (int i = 0; i < dataRows.length; i++) {
      if (i == selectedIndex) {
        dataRows[i] = DataRow(
          selected: true,
          onSelectChanged: (value) {
            setState(() {
              updateSelectedRows(-1);
            });
          },
          cells: dataRows[i].cells,
        );
      } else {
        dataRows[i] = DataRow(
          selected: false,
          onSelectChanged: (value) {
            setState(() {
              updateSelectedRows(i);
            });
          },
          cells: dataRows[i].cells,
        );
      }
    }

    final selectedData = dataRows
        .where((row) => row.selected)
        .map((row) => widget.dataList[dataRows.indexOf(row)])
        .toList();
    widget.onChanged(selectedData.toString());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        showCheckboxColumn: false,
        columns: const [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Type')),
          DataColumn(label: Text('Host')),
        ],
        rows: dataRows,
      ),
    );
  }
}