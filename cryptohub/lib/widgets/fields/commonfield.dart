import 'package:flutter/material.dart';

class CommonField extends StatefulWidget {
  final TextEditingController controller;
  String placeholder;
  final Function(String)? OnChanged;
  Icon? prifix_icon;
  // Assign controller properly via constructor
  CommonField(
      {super.key,
      required this.controller,
      required this.placeholder,
      this.OnChanged,
      this.prifix_icon});

  @override
  State<CommonField> createState() => _CommonFieldState();
}

class _CommonFieldState extends State<CommonField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: widget.OnChanged,
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.placeholder,
        filled: true,
        fillColor: Color.fromARGB(255, 17, 17, 17),
        prefixIcon: widget.prifix_icon,
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black)),
        hintStyle: const TextStyle(color: Color.fromARGB(255, 138, 138, 138)),
      ),
    );
  }
}
