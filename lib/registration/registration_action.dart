import 'package:flutter/material.dart';
import 'package:flutter_pk/events/event_detail_container.dart';
import 'package:flutter_pk/events/model.dart';
import 'package:flutter_pk/global.dart';
import 'package:flutter_pk/profile/model.dart';
import 'package:flutter_pk/registration/model.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

typedef void RegistrationCallback(
    BuildContext context, EventDetails event, User user);

class RegistrationAction extends StatelessWidget {
  static Map<String, String> _buttonTextMap = {
    RegistrationStates.undefined: 'REGISTER',
    RegistrationStates.registered: 'PENDING',
    RegistrationStates.shortlisted: 'CONFIRM',
    RegistrationStates.cancelled: 'RE-APPLY',
    RegistrationStates.confirmed: 'VIEW',
  };

  static Map<String, RegistrationCallback> _buttonActionMap = {
    RegistrationStates.undefined: _actionOnUnregistered,
    RegistrationStates.registered: _actionOnRegistered,
    RegistrationStates.shortlisted: _actionOnShortlisted,
    RegistrationStates.cancelled: _actionOnUnregistered,
    RegistrationStates.confirmed: _actionOnConfirmed,
  };

  final String _text;
  final RegistrationCallback _onTap;
  final EventDetails event;

  RegistrationAction(this.event)
      : _text = _buttonTextMap[event.registrationStatus],
        _onTap = _buttonActionMap[event.registrationStatus];

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      child: Text(_text),
      shape: StadiumBorder(),
      onPressed: () => _onTap(context, event, userCache.user),
    );
  }
}

void _actionOnUnregistered(
    BuildContext context, EventDetails event, User user) {
  _showInfoDialog(
    context: context,
    title: 'Register',
    content: 'This will submit your registration entry. '
        'Do you want to proceed?',
    postiveTitle: 'REGISTER',
    positiveAction: () async {
      var service = RegistrationService();
      await service.updateStatus(event.id, user, RegistrationStates.registered);
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration request submitted'),
        ),
      );
    },
    negativeTitle: 'CANCEL',
  );
}

void _actionOnRegistered(BuildContext context, EventDetails event, User user) {
  _showInfoDialog(
    context: context,
    title: 'Hold on!',
    content: 'Your registration is pending. '
        'You\'ll be notified when you\'re shortlisted for the event.',
  );
}

void _actionOnShortlisted(BuildContext context, EventDetails event, User user) {
  _showInfoDialog(
    context: context,
    title: 'Confirm',
    content: 'You\'ve been shortlisted for the event. '
        'Please confirm your registration '
        'or cancel it to give other people a chance.',
    postiveTitle: 'CONFIRM',
    positiveAction: () async {
      var service = RegistrationService();
      await service.updateStatus(event.id, user, RegistrationStates.confirmed);
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration confirmed'),
        ),
      );
    },
    negativeTitle: 'CANCEL',
    negativeAction: () async {
      var service = RegistrationService();
      await service.updateStatus(event.id, user, RegistrationStates.cancelled);
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration cancelled'),
        ),
      );
    },
  );
}

void _actionOnConfirmed(BuildContext context, EventDetails event, User user) =>
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventDetailContainer(event),
      ),
    );

void _showInfoDialog({
  @required BuildContext context,
  String title: 'Information',
  @required String content,
  String postiveTitle: 'OKAY',
  VoidCallback positiveAction,
  String negativeTitle,
  VoidCallback negativeAction,
}) {
  Alert(
    context: context,
    type: AlertType.info,
    title: title,
    desc: content,
    buttons: [
      if (negativeTitle != null)
        DialogButton(
          child: Text(
            'CANCEL',
            style: Theme.of(context).textTheme.title.copyWith(
                  color: Colors.white,
                ),
          ),
          color: Colors.red,
          onPressed: () {
            Navigator.of(context).pop();
            if (negativeAction != null) negativeAction();
          },
        ),
      DialogButton(
        child: Text(
          postiveTitle,
          style: Theme.of(context).textTheme.title.copyWith(
                color: Colors.white,
              ),
        ),
        color: Colors.green,
        onPressed: () {
          Navigator.of(context).pop();
          if (positiveAction != null) positiveAction();
        },
      ),
    ],
  ).show();
}
