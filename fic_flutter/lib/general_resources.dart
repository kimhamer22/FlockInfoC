import 'package:fic_flutter/top_bar.dart';
import 'package:flutter/material.dart';

class GeneralResources extends StatelessWidget {
  const GeneralResources({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TopBar(page: 'General Resources'),
    );
  }
}
