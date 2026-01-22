import 'package:flutter/material.dart';

class SquadPage extends StatelessWidget {
  const SquadPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            centerTitle: true,
            title: Text('Squad', style: Theme.of(context).textTheme.headlineMedium)
          ),
      body: Center(
        child: Text('This is the Squad page.'),
      ),
    );
  }
}