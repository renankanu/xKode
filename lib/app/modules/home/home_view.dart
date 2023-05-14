import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:x_kode/app/modules/home/home_controller.dart';
import 'package:x_kode/app/modules/home/home_state.dart';
import 'package:x_kode/app/routes/app_routes.dart';
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
      return;
    }

    if (mounted) {
      context.read<HomeController>().saveProject(
            ProjectModel(
              name: selectedDirectory.split('/').last,
              path: selectedDirectory,
            ),
          );
    }
  }

  String getFinalString(String string) {
    String _ = string.substring(0, string.lastIndexOf("/") + 1);
    return '~$string';
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
                          child: Text('Configuring platform...'),
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
                          padding: EdgeInsets.all(context.percentWidth(1)),
                          separatorBuilder: (context, index) => const Divider(
                            color: AppColors.chestnut,
                            height: 1,
                          ),
                          itemCount: state.projects.length,
                          itemBuilder: (context, index) {
                            final project = state.projects[index];
                            return GestureDetector(
                              onDoubleTap: () {
                                context
                                    .push('${AppRoutes.build}/${project.name}');
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            project.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            getFinalString(project.path),
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {
                                        context
                                            .read<HomeController>()
                                            .removeProject(project);
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        size: 12,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    case HomeStateEmpty():
                      return const BaseContainer(
                        child: Center(
                          child: Text('No projects found 📄'),
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
