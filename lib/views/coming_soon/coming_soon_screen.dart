import 'package:flutter/material.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 50,
      fontFamily: 'Satisfy',
      color: Theme.of(context).colorScheme.primary,
    );
    return Scaffold(
      appBar: AppBar(
        
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/coming_soon.png'),
          Text('Proximamente', style: textStyle,),
        ],
      ),

    );
  }
}