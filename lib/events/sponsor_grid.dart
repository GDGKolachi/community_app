import 'package:flutter/material.dart';
import 'package:flutter_pk/events/model.dart';

class SponsorGrid extends StatefulWidget {
  const SponsorGrid(this.eventId, {
    Key key,
  }) : super(key: key);

  final String eventId;

  @override
  _SponsorGridState createState() => _SponsorGridState();
}

class _SponsorGridState extends State<SponsorGrid> {
  final bloc = SponsorBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Sponsor>>(
      stream: bloc.getSponsors(widget.eventId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var sponsors = snapshot.data;
        return GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: sponsors.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            return GridTile(
              child: Image.network(sponsors[index].imageUrl),
            );
          },
        );
      }
    );
  }
}