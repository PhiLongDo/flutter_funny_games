import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        child: GridView.builder(
          itemCount: state.list.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1,
            crossAxisCount: 2,
            mainAxisSpacing: 3,
            crossAxisSpacing: 3,
          ),
          itemBuilder: (_, index) {
            return InkWell(
              onTap: () =>
                  Navigator.pushNamed(context, state.list[index].nameRoute!),
              child: Image.asset(state.list[index].image),
            );
          },
        ),
      ),
    );
  }
}
