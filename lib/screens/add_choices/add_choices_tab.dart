import 'package:flutter/material.dart';

class AddChoicesTab extends StatefulWidget {
  const AddChoicesTab({super.key});

  @override
  State<AddChoicesTab> createState() => _AddChoicesTabState();
}

class _AddChoicesTabState extends State<AddChoicesTab> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Add Choices'),);
  }
}
