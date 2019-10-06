import 'package:flutter/material.dart';
import 'package:flutter_pk/messages/model.dart';
import 'package:flutter_pk/widgets/animated_progress_indicator.dart';
import 'package:flutter_pk/widgets/empty_list_message.dart';

class MessageBoard extends StatelessWidget {
  final MessageBloc bloc = MessageBloc();
  final String eventId;

  MessageBoard(
    this.eventId, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: bloc.getMessages(eventId),
      initialData: <Message>[],
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return AnimatedProgressIndicator();
        }

        var messages = snapshot.data;

        if (messages.length == 0) {
          return EmptyListMessage('No incoming messages');
        }

        return ListView.separated(
          itemBuilder: (context, index) => ListTile(
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(messages[index].text),
            ),
            subtitle: Text(
              '${messages[index].user.name} ∙ ${messages[index].formattedDate}',
            ),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(messages[index].user.photoUrl),
            ),
          ),
          itemCount: messages.length,
          separatorBuilder: (_, __) => Divider(),
        );
      },
    );
  }
}
