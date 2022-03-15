import 'package:fic_flutter/widgets/breadcrumb.dart';
import 'package:fic_flutter/widgets/top_bar.dart';
import 'package:flutter/material.dart';

class GeneralResources extends StatelessWidget {
  const GeneralResources({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(page: 'General Resources'),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          BreadcrumbBar.homePressed(context);
        },
        child: const Icon(Icons.home),
      ),
    );
  }
}
