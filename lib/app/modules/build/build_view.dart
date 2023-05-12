import 'dart:developer';

import 'package:flutter/material.dart';

class BuildView extends StatefulWidget {
  const BuildView({
    Key? key,
    required this.projectName,
  }) : super(key: key);

  final String projectName;

  @override
  State<BuildView> createState() => _BuildViewState();
}

class _BuildViewState extends State<BuildView> {
  @override
  void initState() {
    log(widget.projectName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Container(),
    );
  }
}
