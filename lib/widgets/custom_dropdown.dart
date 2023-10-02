import 'package:flutter/material.dart';
import 'package:flutter_socket/utils/colors.dart';

class CustomDropDown extends StatefulWidget {
  final List<String> items;
  final String initialValue;
  final void Function(String) onChanged;

  const CustomDropDown({
    super.key,
    required this.items,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.blue,
          blurRadius: 5,
          spreadRadius: 2,
        )
      ], color: bgCololor),
      child: Padding(
        padding: const EdgeInsets.only(left: 13.0, right: 5.0),
        child: DropdownButton<String>(
          isExpanded: true,
          value: dropdownValue,
          icon: const Icon(Icons.arrow_downward),
          underline: const SizedBox.shrink(),
          style: const TextStyle(color: Colors.white),
          dropdownColor: bgCololor,
          onChanged: (String? value) {
            setState(() {
              dropdownValue = value!;
              widget.onChanged(dropdownValue);
            });
          },
          items: widget.items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
