import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/app_result.dart';
import '../../../data/repositories/repository.dart';
import '../../../services/alarm_manager.dart';
import '../../../services/background_fetch.dart';
import '../../widgets/app_container.dart';
import 'home_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => HomeProvider(),
      builder: (context, child) => _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
    final provider = context.read<HomeProvider>();
    final state = provider.state;

    return AppContainer(
      showBackButton: false,
      child: Center(
        child: Stack(children: [
          GridView.builder(
            itemCount: state.list.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1,
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemBuilder: (_, index) {
              return InkWell(
                onTap: () => provider.navigateToFeature(context, index),
                child: Image.asset(state.list[index].image),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () async {
                    if (Platform.isIOS) {
                      await configureBackgroundFetch();
                      startBackgroundFetch();
                    }
                    if (Platform.isAndroid) {
                      startAlarmTask();
                    }
                  },
                  child: const Text("Start services"),
                ),
                TextButton(
                  onPressed: () {
                    if (Platform.isIOS) {
                      stopBackgroundFetch();
                    }
                    if (Platform.isAndroid) {
                      cancelAlarmTask();
                    }
                  },
                  child: const Text("Stop services"),
                ),
                TextButton(
                  onPressed: () async {
                    print("---------backgroundValue----------");
                    var backgroundValue = "";

                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    if (Platform.isIOS) {
                      backgroundValue = prefs.getString(backgroundKey) ?? "";
                    }
                    if (Platform.isAndroid) {
                      backgroundValue = prefs.getString(alarmKey) ?? "";
                    }
                    print(backgroundValue);
                    print("----------------------------");
                  },
                  child: const Text("View "),
                ),
                TextButton(
                  onPressed: () async {
                    if (kDebugMode) {
                      final apiResult = await DefaultRepository().getTasks();
                      if (apiResult.status == ResultStatus.success) {
                        print("Success: ${apiResult.data}");
                      } else {
                        print(
                            "Failed: ${apiResult.status} - ${apiResult.error}");
                      }
                    }
                  },
                  child: const Text("Test api"),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
