import 'package:flutter/material.dart';
import '../../utils/utils.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/no_internet.png'),
          Text(
            'Oops..! No internet connection',
            style: TextStyle(
              fontSize: 18,
              color: grey,
            ),
          ),
        ],
      ),
    );
  }
}
