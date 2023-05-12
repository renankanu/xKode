import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_kode/app/modules/home/components/base_container.dart';
import 'package:x_kode/app/modules/home/home_controller.dart';
import 'package:x_kode/app/modules/home/home_state.dart';
import 'package:x_kode/app/shared/app_colors.dart';
import 'package:x_kode/app/shared/extensions/responsive_extension.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    context.read<HomeController>().getProjects();
  }

  Future<void> chooseIosFolder() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory == null) {
      const AlertDialog(
        title: Text('Error'),
        content: Text('No directory was selected'),
      );
    } else {
      try {
        final result = await Process.run(
          'sh',
          ['-c', 'cd $selectedDirectory && flutter build ios --release'],
        );
        // _projects.add(
        //   ProjectModel(
        //     name: selectedDirectory.split('/').last,
        //     path: selectedDirectory,
        //   ),
        // );
        log(result.stdout.toString());
        log(result.stderr.toString());
      } on Exception {
        const AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred while building the project'),
        );
      }
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
              BlocConsumer<HomeController, HomeState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is HomeStateStart) {
                    return const Expanded(
                      flex: 2,
                      child: Center(
                        child: Text('No projects found 🗑'),
                      ),
                    );
                  }
                  if (state is HomeStateLoading) {
                    return const Expanded(
                      flex: 2,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (state is HomeStateSuccess) {
                    if (state.projects.isEmpty) {
                      return const BaseContainer(
                          child: Center(
                        child: Text('No projects found 🗑'),
                      ));
                    }
                    return BaseContainer(
                      child: ListView.builder(
                        itemCount: state.projects.length,
                        itemBuilder: (context, index) {
                          return const ListTile(
                            title: Text('Project Name'),
                          );
                        },
                      ),
                    );
                  }
                  if (state is HomeStateError) {
                    return BaseContainer(
                        child: Center(
                      child: Text(
                        'An error occurred - ${state.message}',
                        style: const TextStyle(color: AppColors.chestnut),
                      ),
                    ));
                  }
                  return const BaseContainer(
                      child: Center(
                    child: Text('🤕'),
                  ));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
