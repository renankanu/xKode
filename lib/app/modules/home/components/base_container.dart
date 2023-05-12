import 'package:flutter/material.dart';

import '../../../shared/app_colors.dart';

class BaseContainer extends StatelessWidget {
  const BaseContainer({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          color: AppColors.tuatara,
        ),
        child: child,
      ),
    );
  }
}
