import 'package:flutter/material.dart';

class CustomRadioTile extends StatelessWidget {
  final String title;
  final int value;
  final int groupValue;
  final ValueChanged<int?> onChanged;
  final bool error;
  final int selected;

  const CustomRadioTile({
    Key? key,
    required this .error,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    child : ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
      title: Text(title),
      trailing: Radio<int>(
        value: value,
        groupValue: groupValue,
        onChanged: (int? value) {
          onChanged(value);
        },
        activeColor: error ? Colors.grey : Colors.blue,
      ),
      onTap: () {
        onChanged(value);
      },
    ),
    ),
    SizedBox(height: 8),
        
        ],
    );
  }
}
