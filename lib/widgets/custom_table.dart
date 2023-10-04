import 'package:flutter/material.dart';

class CustomTable extends StatefulWidget {
  final List<dynamic> dataList;
  final void Function(void) onChanged;

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
    dataRows = widget.dataList.map((data) {
      bool selected = false;
      return DataRow(
        selected: selected,
        onSelectChanged: (value) {
          setState(() {
            selected = value ?? false;
            updateSelectedRows();
          });
        },
        cells: [
          DataCell(Text(data['name'])),
          DataCell(Text(data['host'])),
        ],
      );
    }).toList();
  }

  void updateSelectedRows() {
    final selectedRows = dataRows
        .where((row) => row.selected)
        .map((row) => widget.dataList[dataRows.indexOf(row)])
        .toList();
    widget.onChanged(selectedRows);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          showCheckboxColumn: true,
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Host')),
          ],
          rows: dataRows,
        ),
      ),
    );
  }
}
