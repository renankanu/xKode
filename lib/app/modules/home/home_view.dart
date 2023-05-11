import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:x_kode/app/shared/extensions/responsive_extension.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  Future<void> chooseIosFolder() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory == null) {
      const AlertDialog(
        title: Text('Error'),
        content: Text('No directory was selected'),
      );
    } else {
      final result = await Process.run(
        'sh',
        ['-c', 'cd $selectedDirectory && flutter build ios --release'],
      );
      log(result.stdout);
      log(result.stderr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        child: Container(
          height: context.percentHeight(80),
          width: context.percentWidth(80),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: ListView(
            children: [
              TextButton(
                onPressed: chooseIosFolder,
                child: const Text('Choose Folder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
