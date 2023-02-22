import 'package:flutter/material.dart';
// import 'package:lab/components/service_tile.dart';
import './service_tile.dart';

class DetailsView extends StatelessWidget {
  final double price;
  final String? text;

  const DetailsView({Key? key, required this.price, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            ServiceTitle(price: price, text: text,noNavigate: true,),
            Expanded(child: Container(color: Colors.blueGrey, width: double.infinity,child: Text('body'),))
          ],
        ),
      ),
    );
  }
}