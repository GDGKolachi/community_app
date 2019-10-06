import 'package:flutter/material.dart';

class EmptyListMessage extends StatelessWidget {
  final String text;
  
  const EmptyListMessage(this.text, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .subhead
            .copyWith(color: Theme.of(context).hintColor),
      ),
    );
  }
}