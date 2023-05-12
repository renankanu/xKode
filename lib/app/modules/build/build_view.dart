import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:x_kode/app/modules/build/build_controller.dart';
import 'package:x_kode/app/modules/build/build_state.dart';

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
  @override
  void initState() {
    log(widget.projectName);
    super.initState();
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
                    const VersionContainer(label: 'Version'),
                    const SizedBox(height: 8),
                    const VersionContainer(label: 'Build'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<BuildController>()
                            .buildProject(widget.projectName);
                      },
                      child: const Text('Build'),
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
              _ => const SizedBox.shrink(),
            },
          );
        },
      ),
    );
  }
}
