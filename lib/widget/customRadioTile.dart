import 'package:flutter/material.dart';

/// A custom radio tile widget that displays a radio button along with a title.
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
    required this.selected, required TextStyle style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      // Container wrapping the ListTile to customize its appearance
        Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    child : ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
      title: Text(title, style: TextStyle(color: Colors.black),),
      trailing: Radio<int>(
        fillColor: error? MaterialStateProperty.all(Colors.grey): MaterialStateProperty.all(Colors.black),
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
