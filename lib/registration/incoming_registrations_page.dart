import 'package:flutter/material.dart';
import 'package:flutter_pk/events/model.dart';
import 'package:flutter_pk/profile/model.dart';
import 'package:flutter_pk/registration/model.dart';
import 'package:flutter_pk/widgets/empty_list_message.dart';
import 'package:flutter_pk/widgets/two_line_title_app_bar.dart';

class IncomingRegistrationsPage extends StatefulWidget {
  final EventDetails event;

  IncomingRegistrationsPage(this.event);

  @override
  _IncomingRegistrationsPageState createState() =>
      _IncomingRegistrationsPageState();
}

class _IncomingRegistrationsPageState extends State<IncomingRegistrationsPage> {
  List<String> _registeredUserIDs = [];
  final _listKey = GlobalKey<AnimatedListState>();

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
        .toList()
        .cast<String>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildTwoLineTitleAppBar(
        context,
        'Registrations',
        widget.event.eventTitle,
      ),
      body: _registeredUserIDs.length > 0
          ? AnimatedList(
              key: _listKey,
              padding: const EdgeInsets.only(top: 8),
              initialItemCount: _registeredUserIDs.length,
              itemBuilder: (context, index, animation) {
                User user = User.fromMap(
                    widget.event.registrations[_registeredUserIDs[index]]);
                return SizeTransition(
                  sizeFactor: animation,
                  axis: Axis.vertical,
                  child: IncomingRegistrationTile(
                    user: user,
                    eventId: widget.event.id,
                    onApproved: (userId) {
                      _listKey.currentState.removeItem(
                        index,
                        (context, animation) => SizeTransition(
                          sizeFactor: animation,
                          axis: Axis.vertical,
                          child: IncomingRegistrationTile(
                            user: user,
                            eventId: widget.event.id,
                            onApproved: null,
                          ),
                        ),
                      );
                      _registeredUserIDs.remove(userId);

                      if (_registeredUserIDs.length == 0) setState(() {});
                    },
                  ),
                );
              },
            )
          : EmptyListMessage('No incoming registrations requiring approval'),
    );
  }
}

typedef void RegistrationApprovedCallback(String userId);

class IncomingRegistrationTile extends StatelessWidget {
  const IncomingRegistrationTile({
    Key key,
    @required this.eventId,
    @required this.user,
    @required this.onApproved,
  }) : super(key: key);

  final User user;
  final String eventId;
  final RegistrationApprovedCallback onApproved;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
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
            onPressed: () => _approve(context),
          ),
        ),
        Divider(),
      ],
    );
  }

  void _approve(BuildContext context) async {
    var service = RegistrationService();
    onApproved(user.id);
    await service.updateStatus(eventId, user, RegistrationStates.shortlisted);
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Registration request submitted by ${user.name} is approved'),
      ),
    );
  }
}
