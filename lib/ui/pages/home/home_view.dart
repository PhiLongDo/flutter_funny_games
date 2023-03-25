import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/app_result.dart';
import '../../../data/repositories/repository.dart';
import '../../widgets/app_container.dart';
import 'home_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
          Container(
            alignment: Alignment.bottomRight,
              child: InkWell(
            onTap: () async {
              if (kDebugMode) {
                final apiResult = await DefaultRepository().getTasks();
                if (apiResult.status == ResultStatus.success) {
                  print("Success: ${apiResult.data}");
                } else {
                  print("Failed: ${apiResult.status} - ${apiResult.error}");
                }
              }
            },
            child: const Text("Test api"),
          ))
        ]),
      ),
    );
  }
}
