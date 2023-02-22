import 'package:flutter/material.dart';
import 'package:lab/components/details_view.dart';

class ServiceTitle extends StatelessWidget {
  final double price;
  final String? text;
  final bool noNavigate;

  const ServiceTitle({required this.price, this.text, this.noNavigate = false});
  // const ServiceTitle({
  //   Key? key, required this.price,
  // }) : super(key: key);

  void _navigateToDetails(BuildContext context, double price, text) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailsView(price: price,text: text,)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        color: Colors.red,
        width: double.infinity,
        height: 112,
        child: InkWell(
          onTap: noNavigate ? null : () => _navigateToDetails(context, price, text),
          child: Row(
            children: [
              Expanded(flex: 3, child: Container(color: Colors.blueGrey,child: Text('holi'))),
              Expanded(flex: 1, child: Container(color: Colors.green,child: Center(child: Text('$price')))),
            ],
          ),
        ),
      ),
    );
  }
}