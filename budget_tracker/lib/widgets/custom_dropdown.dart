import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> values;
  final List<String> labels;
  final String hint;
  final String? Function(T? value) validator;
  final void Function(T value) onChanged;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.values,
    required this.labels,
    required this.hint,
    required this.validator,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final items = <DropdownMenuItem<T>>[];

    for (int i = 0; i < values.length; i++) {
      items.add(DropdownMenuItem<T>(value: values[i], child: Text(labels[i])));
    }

    return DropdownButtonFormField2<T>(
      value: value,
      items: items,
      validator: validator,
      onChanged: (value) {
        if (value == null) return;
        onChanged(value);
      },
      isExpanded: true,
      hint: Text(hint, style: TextStyle(fontSize: 15, color: Colors.white)),
      style: TextStyle(fontSize: 16, color: Colors.white),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white, width: 1.25),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white, width: 1.25),
        ),
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      iconStyleData: IconStyleData(
        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
        iconSize: 35,
      ),
    );
  }
}
