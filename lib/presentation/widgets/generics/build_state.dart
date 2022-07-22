import 'package:flutter/material.dart';

import '../../styles/colors_style.dart';

//Can't translate

Widget buildLoading(BuildContext context) {
  return Center(
    child: CircularProgressIndicator(
      color: Theme.of(context).colorScheme.secondary,
    ),
  );
}

Widget buildAppBarLoading(BuildContext context) {
  return Container(
    height: 60.0,
    color: CustomColors.evenRow,
    padding: EdgeInsets.symmetric(vertical: 25),
    child: LinearProgressIndicator(),
  );
}

Widget buildPaginationLoading(BuildContext context) {
  return Center(
    child: Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    ),
  );
}

Widget buildNotFound(String type) {
  return Container(
    child: Column(
      children: [
        Center(
          child: Text(
            '$type niet kunnen vinden.',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}

Widget buildNoSearchResults(context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
          image: AssetImage('assets/magnify-icon.png'),
          height: 250,
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          "Geen resultaten gevonden",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    ),
  );
}

Widget buildNoOrdersFound() {
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        child: Card(
          color: CustomColors.oddRow,
          elevation: 0,
          shape: new RoundedRectangleBorder(
            side: BorderSide(color: CustomColors.cardBorder, width: 1),
            borderRadius: new BorderRadius.circular(7.0),
          ),
          child: Wrap(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Order(s) niet kunnen vinden.',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget buildError(String? errorMessage) {
  return Container(
    child: Column(
      children: [
        Center(
          child: Text(
            'Error! Er ging iets mis. Probeer opnieuw',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        Center(
          child: Text('Error: $errorMessage'),
        ),
      ],
    ),
  );
}

Widget buildEmpty() {
  return Text(
    '',
  );
}

Widget buildWarning(String warning) {
  return Text(
    warning,
  );
}
