import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key}); 

  // static final Widget image = Container(
  //   decoration: const BoxDecoration(
  //     image: DecorationImage(
  //       image: AssetImage('assets/icons/launcher_icon.png'),
  //       fit: BoxFit.contain,
  //     ),
  //   ),
  // );

  @override
  Widget build(BuildContext context) {
    Future<void> pre = precacheImage(const AssetImage('assets/icons/launcher_icon.png'), context);
    return SizedBox.expand(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors:[ Color.fromARGB(255, 233, 32, 212),Color.fromARGB(255, 22, 46, 182),], begin: Alignment.centerLeft, end: Alignment.centerRight),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80.0),
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder(
                  future: pre,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done){
                      return Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/icons/launcher_icon.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}