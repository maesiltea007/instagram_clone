import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InstagramMain extends StatefulWidget {
  const InstagramMain({super.key, required this.title});
  final String title;

  @override
  State<InstagramMain> createState() => _InstagramMainState();
}

class _InstagramMainState extends State<InstagramMain> {
  Widget _buildBottomTab(VoidCallback onTap, IconData icon) => Expanded(
    child: InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: Icon(icon),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          leading: IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () {},
          ),
          elevation: 1,
          backgroundColor: Theme.of(context).canvasColor,
          title: Text(
            widget.title,
            style: const TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {},
            ),
          ]),
      body: const Center(),
      bottomNavigationBar: BottomAppBar(
          child: Row(children: <Widget>[
            _buildBottomTab(() {}, Icons.home),
            _buildBottomTab(() {}, Icons.search),
            _buildBottomTab(() {}, Icons.add_box),
            _buildBottomTab(() {}, Icons.favorite),
            _buildBottomTab(() {}, Icons.account_circle),
          ])),
    );
  }
}