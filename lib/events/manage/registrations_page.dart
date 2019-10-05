import 'package:flutter/material.dart';
import 'package:flutter_pk/caches/user.dart';
import 'package:flutter_pk/events/model.dart';
import 'package:flutter_pk/registration/model.dart';

class IncomingRegistrationsPage extends StatefulWidget {
  final EventDetails event;

  IncomingRegistrationsPage(this.event);

  @override
  _IncomingRegistrationsPageState createState() =>
      _IncomingRegistrationsPageState();
}

class _IncomingRegistrationsPageState extends State<IncomingRegistrationsPage> {
  List<String> _registeredUserIDs = [];

  @override
  void initState() {
    super.initState();
    _registeredUserIDs = _getRegisteredUsers();
  }

  List<String> _getRegisteredUsers() {
    /// TODO: This is part of business logic and 
    /// should be moved outside of this widget code.
    return widget.event.registrations.keys
      .where((key) =>
          widget.event.registrations[key]['status'] ==
          RegistrationStates.registered)
      .toList().cast<String>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrations'),
      ),
      body: ListView.separated(
        itemCount: _registeredUserIDs.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          User user =
              User.fromMap(widget.event.registrations[_registeredUserIDs[index]]);
          return ListTile(
            title: Text(user.name),
            subtitle:
                Text('${user.occupation.designation ?? user.occupation.type}'
                    ' at ${user.occupation.workOrInstitute}\n${user.email}'),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl),
            ),
            trailing: RaisedButton(
              child: Text('APPROVE'),
              shape: StadiumBorder(),
              onPressed: () {
                var service = RegistrationService();
                setState(() => _registeredUserIDs.remove(user.id));
                service.updateStatus(
                    widget.event.id, user, RegistrationStates.shortlisted);
              },
            ),
          );
        },
      ),
    );
  }
}
