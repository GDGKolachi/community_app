import 'package:flutter/material.dart';

AppBar buildTwoLineTitleAppBar(
  BuildContext context,
  String title,
  String subtitle,
) {
  return AppBar(
    title: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(title),
        Text(
          subtitle, //formatDate(widget.event.date, DateFormats.shortUiDateFormat),
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    ),
  );
}