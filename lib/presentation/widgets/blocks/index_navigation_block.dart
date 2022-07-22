import 'package:flutter/material.dart';

import '../../styles/colors_style.dart';

class BuildIndexBlockItem extends StatelessWidget {
  const BuildIndexBlockItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.onClicked,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onClicked;

  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[100],
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        splashColor: Theme.of(context).colorScheme.primary.withAlpha(30),
        onTap: onClicked,
        child: SizedBox(
          width: 300,
          height: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.secondary,
                size: 25,
              ),
              SizedBox(height: 10.0),
              Text(
                title,
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
      //leading: Icon(icon, color: CustomColors.textWhite,)
    );
  }
}
