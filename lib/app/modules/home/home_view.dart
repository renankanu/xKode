import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:x_kode/app/shared/app_colors.dart';
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
            color: AppColors.mineShaft,
            border: Border.fromBorderSide(
              BorderSide(
                color: AppColors.emperor,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.all(context.percentWidth(5)),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/xKode.png',
                        height: 200,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'xKode',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          await chooseIosFolder();
                        },
                        child: const Text('Choose Project Folder'),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: AppColors.tuatara,
                  ),
                  child: const Column(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
