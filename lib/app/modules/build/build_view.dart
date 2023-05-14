import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:x_kode/app/modules/build/build_controller.dart';
import 'package:x_kode/app/modules/build/build_state.dart';
import 'package:x_kode/app/shared/app_colors.dart';

import 'components/version_container.dart';

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
  final versionController = TextEditingController();
  final buildController = TextEditingController();

  @override
  void initState() {
    _getBuildVersion();
    super.initState();
  }

  void _getBuildVersion() async {
    final (version, build) =
        await context.read<BuildController>().getVersion(widget.projectName);
    if (version != null) {
      versionController.text = version;
    }
    if (build != null) {
      buildController.text = build;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<BuildController, BuildState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Center(
            child: switch (state) {
              BuildStateStart() => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.projectName,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    VersionContainer(
                      label: 'Version',
                      controller: versionController,
                    ),
                    const SizedBox(height: 8),
                    VersionContainer(
                      label: 'Build',
                      controller: buildController,
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.emperor,
                          ),
                          onPressed: () {
                            context.pop();
                          },
                          child: const Text('Voltar'),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            context.read<BuildController>().buildProject(
                                  projectName: widget.projectName,
                                  version: versionController.text,
                                  build: buildController.text,
                                );
                          },
                          child: const Text('Build'),
                        ),
                      ],
                    ),
                  ],
                ),
              BuildStateLoadingBuild() => Center(
                  child: SizedBox(
                    height: 400,
                    width: 400,
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/images/build.json',
                            repeat: true,
                            animate: true,
                          ),
                          const Text('Building .ipa ...'),
                        ],
                      ),
                    ),
                  ),
                ),
              BuildStateLoadingSend() => Center(
                  child: SizedBox(
                    height: 400,
                    width: 400,
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/images/send.json',
                            repeat: true,
                            animate: true,
                          ),
                          const Text('Sending .ipa ...'),
                        ],
                      ),
                    ),
                  ),
                ),
              BuildStateSuccess() => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Success'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          context.read<BuildController>().backPressed();
                          Navigator.pop(context);
                        },
                        child: const Text('Back'),
                      ),
                    ],
                  ),
                ),
              BuildStateError() => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          context.read<BuildController>().backPressed();
                          Navigator.pop(context);
                        },
                        child: const Text('Back'),
                      ),
                    ],
                  ),
                ),
              _ => const SizedBox.shrink(),
            },
          );
        },
      ),
    );
  }
}
