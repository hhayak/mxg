import 'package:flutter/material.dart';
import 'package:mxg/models/weight_entry.dart';
import 'package:mxg/services/services.dart';
import 'package:mxg/services/user_service.dart';
import 'package:mxg/services/weight_entry_service.dart';
import 'package:mxg/widgets/flat_card.dart';
import 'package:mxg/widgets/text_title.dart';
import 'package:mxg/widgets/weight_entry_list.dart';
import 'package:animated_stream_list/animated_stream_list.dart';

class HomeTab extends StatelessWidget {
  final Future<List<WeightEntry>> future =
      getIt<WeightEntryService>().getUserWeightEntries();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 60, left: 10, right: 10),
        child: FutureBuilder<List<WeightEntry>>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Could not retrieve entries.'),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return AnimatedRecentEntries(
                  initialData: snapshot.data!,
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}

class NoDataAvailable extends StatelessWidget {
  const NoDataAvailable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatCard.filled(
      color: Colors.orangeAccent.withOpacity(0.5),
      child: Center(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: TextTitle(
                text: 'No data available',
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                child: Text('Add weight entry'),
                onPressed: () async {
                  var entry =
                      WeightEntry(id: '0', weight: 67, date: DateTime.now());
                  await getIt<WeightEntryService>().addWeightEntry(entry);
                  var user = await getIt<UserService>()
                      .getUser(getIt<AuthService>().getCurrentUser()!.uid);
                  print(user!.toJson());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecentEntries extends StatelessWidget {
  final Stream<List<WeightEntry>> _stream =
      getIt<WeightEntryService>().getUserWeightEntryStream();
  final List<WeightEntry> initialData;

  RecentEntries({Key? key, required this.initialData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<WeightEntry>>(
        stream: _stream,
        initialData: initialData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Could not retrieve entries.'),
            );
          }
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextTitle(text: 'Recent'),
                snapshot.data!.isEmpty
                    ? NoDataAvailable()
                    : WeightEntryList(
                        entries: snapshot.data!,
                      ),
              ],
            );
          }
          return Text('Refreshing');
        });
  }
}

class AnimatedRecentEntries extends StatelessWidget {
  final Stream<List<WeightEntry>> _stream =
      getIt<WeightEntryService>().getUserWeightEntryStream();
  final List<WeightEntry> initialData;

  AnimatedRecentEntries({Key? key, required this.initialData})
      : super(key: key);

  Widget _createTile(WeightEntry entry, Animation<double> animation) {
    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: animation,
      child: WeightEntryTile(
        entry: entry,
      ),
    );
  }

  bool equal(WeightEntry a, WeightEntry b) => a.id == b.id;

  @override
  Widget build(BuildContext context) {
    return AnimatedStreamList<WeightEntry>(
        streamList: _stream,
        initialList: initialData,
        shrinkWrap: true,
        scrollPhysics: BouncingScrollPhysics(),
        equals: (a, b) => equal(a, b),
        itemBuilder: (item, index, context, animation) =>
            _createTile(item, animation),
        itemRemovedBuilder: (item, index, context, animation) =>
            _createTile(item, animation));
  }
}
