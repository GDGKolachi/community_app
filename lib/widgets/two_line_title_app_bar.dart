import 'dart:io';

import 'package:flutter/material.dart';

AppBar buildTwoLineTitleAppBar(
  BuildContext context,
  String title,
  String subtitle,
) {
  return AppBar(
    title: Column(
      crossAxisAlignment:
          Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(title),
        SizedBox(height: 4),
        Text(
          subtitle, //formatDate(widget.event.date, DateFormats.shortUiDateFormat),
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    ),
  );
}
