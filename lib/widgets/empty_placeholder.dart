import 'package:flutter/material.dart';

class EmptyPlaceholder extends StatelessWidget {
  final String placeholder;
  EmptyPlaceholder(this.placeholder);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/Feedback1.png", height: 150,),
          Text(placeholder),
        ],
      ),
    );
  }
}
