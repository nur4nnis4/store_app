import 'package:flutter/material.dart';
import 'package:store_app/constants/assets_path.dart';

class NetworkError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(35.0, 0.0, 35.0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            constraints: BoxConstraints(maxHeight: 150, maxWidth: 150),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              image: DecorationImage(
                image: AssetImage(ImagePath.noInternet),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 30.0),
          Text(
            'WHOOPS!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(height: 20.0),
          Text(
            'Looks like you there is something wrong with your internet connection. Please connect to internet and start again',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.overline,
          ),
        ],
      ),
    );
  }
}
