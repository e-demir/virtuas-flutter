import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget(
      {super.key,
      required this.fontStyle,
      required this.label,
      required this.size,
      required this.weight});
  final String label;
  final double size;
  final FontWeight weight;
  final FontStyle fontStyle;
  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: size,
        color: const Color.fromARGB(255, 240, 240, 240),
        fontWeight: weight,
        fontStyle: fontStyle,
      ),
    );
  }
}

class AdminPageButton extends StatelessWidget {
  const AdminPageButton({
    super.key,
    required this.onPress,
    required this.icon,
    required this.label,
  });
  final VoidCallback onPress;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPress,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
        
      ),
      fillColor: const Color.fromARGB(74, 0, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Ensure the column takes minimum space
        children: [
          Text(
            textAlign: TextAlign.center,
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 8), // Space between text and icon
          Icon(
            icon,
            color: Colors.white,
            size: 25,
          ),
        ],
      ),
    );
  }
}

class AdminCommanContainer extends StatelessWidget {
  const AdminCommanContainer({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xfffeac5e), Color(0xffc779d0), Color(0xff4bc0c8)],
          stops: [0, 0.5, 1],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: child,
    );
  }
}

class AddTexfield extends StatelessWidget {
  const AddTexfield(
      {super.key,
      required TextEditingController textController,
      required this.label,
      this.maxLenght,
      this.maxLines})
      : _textController = textController;

  final int? maxLines;
  final int? maxLenght;
  final TextEditingController _textController;
  final String label;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      cursorColor: Colors.white,
      cursorWidth: 1.0,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
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
      maxLines: maxLines,
      maxLength: maxLenght,
      minLines: 1,
    );
  }
}

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String label;
  final List<Widget>? action;
  AdminAppBar({Key? key, required this.label, this.action})
      : preferredSize = const Size.fromHeight(60),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        label,
        style: const TextStyle(fontSize: 30, color: Colors.white),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        iconSize: 30,
        color: Colors.white,
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.pop(context),
      ),
      actions: action,
    );
  }
}
