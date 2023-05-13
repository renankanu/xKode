import 'package:flutter/material.dart';

class VersionContainer extends StatelessWidget {
  const VersionContainer({
    Key? key,
    required this.label,
    required this.controller,
  }) : super(key: key);

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('$label: '),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              width: 60,
              height: 30,
              child: TextFormField(
                controller: controller,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
