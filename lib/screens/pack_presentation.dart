import 'package:flutter/material.dart';
import 'package:virgil_demo/assets/placeholders.dart';
import 'package:virgil_demo/models/pack.dart';
import 'package:virgil_demo/widgets/horizontal_scroll.dart';

class PackDetailScreen extends StatelessWidget {
  final Pack pack;

  const PackDetailScreen({Key? key, required this.pack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(pack.title),
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // pack poster image
              Center(
                child: Image.network(
                  pack.packImage,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),
              
              // pack Title
              Text(
                pack.title,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              bookScroll("Books in pack", pack.books),
              Text(
                "Created by: ${pack.creator}",
                style: TextStyle(fontSize: 18),
              ),
                            Text(
                pack.description,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
