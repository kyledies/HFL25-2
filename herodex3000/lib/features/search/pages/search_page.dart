import 'package:flutter/material.dart';
import 'package:simple_neon/simple_neon.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Search', style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: const Center(
        child: Text('This is the Search page.'),
      ),
    );
  }
}