import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CategoryTexField extends StatefulWidget {
  const CategoryTexField(
      {super.key,
      required this.controller,
      required this.label,
      this.maxLenght,
      this.hintText,
      this.inputFormatters,
      this.keyboardType});

  final TextEditingController controller;
  final String label;
  final int? maxLenght;
  final String? hintText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<CategoryTexField> createState() => _CategoryTexFieldState();
}

class _CategoryTexFieldState extends State<CategoryTexField> {
  void _validateInputs() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      cursorWidth: 1.0,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      controller: widget.controller,
      maxLength: widget.maxLenght,
      minLines: 1,
      maxLines: 2,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: Color.fromARGB(255, 195, 242, 247),
          fontSize: 13,
          fontWeight: FontWeight.w300,
        ),
        labelStyle: const TextStyle(
          color: Color.fromARGB(206, 224, 247, 251),
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent.withOpacity(0.3),
            width: 1.0, // Alt çizgi kalınlığı (aktif)
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: BorderSide(
            color: Colors.transparent.withOpacity(0.3),
          ),
        ),
      ),
      onChanged: (_) => _validateInputs(),
    );
  }
}
