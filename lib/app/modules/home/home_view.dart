import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_kode/app/modules/home/home_controller.dart';
import 'package:x_kode/app/modules/home/home_state.dart';
import 'package:x_kode/app/shared/app_colors.dart';
import 'package:x_kode/app/shared/extensions/responsive_extension.dart';

import '../../model/project_model.dart';
import 'components/base_container.dart';

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
      if (mounted) {
        context.read<HomeController>().saveProject(
              ProjectModel(
                name: selectedDirectory.split('/').last,
                path: selectedDirectory,
              ),
            );
      }
      try {
        final result = await Process.run(
          'sh',
          ['-c', 'cd $selectedDirectory && flutter build ios --release'],
        );
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
                  switch (state) {
                    case HomeStateStart():
                      return const BaseContainer(
                        child: Center(
                          child: Text('No projects found 🗑'),
                        ),
                      );
                    case HomeStateLoading():
                      return const BaseContainer(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    case HomeStateSuccess():
                      return BaseContainer(
                        child: ListView.separated(
                          separatorBuilder: (context, index) => const Divider(
                            color: AppColors.tuatara,
                            height: 1,
                          ),
                          itemCount: state.projects.length,
                          itemBuilder: (context, index) {
                            final project = state.projects[index];
                            return ListTile(
                              title: Text(project.name),
                            );
                          },
                        ),
                      );
                    case HomeStateEmpty():
                      return const BaseContainer(
                        child: Center(
                          child: Text('No projects found 🗑'),
                        ),
                      );
                    default:
                      return const SizedBox.shrink();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
