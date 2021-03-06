import 'package:flutter/material.dart';
import 'package:mxg/models/weight_entry.dart';
import 'package:mxg/services/services.dart';
import 'package:mxg/services/weight_entry_service.dart';
import 'package:mxg/utils.dart';
import 'package:mxg/widgets/flat_card.dart';
import 'package:mxg/widgets/text_title.dart';
import 'package:mxg/widgets/weight_entry_list.dart';
import 'package:animated_stream_list/animated_stream_list.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 60, left: 10, right: 10),
        child: ConsumerRecentEntries(
            // TODO: add skeleton loading
            ),
      ),
    );
  }
}

class NoDataAvailable extends StatelessWidget {
  const NoDataAvailable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isLight = Utils.isLight(context);
    return FlatCard.filled(
      color:
          isLight ? Colors.orangeAccent.withOpacity(0.5) : Colors.orangeAccent,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                onPressed: () =>
                    getIt<NavigationService>().showWeightEntryDialog(),
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
      getIt<WeightEntryService>().getOrderedStream();
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

class ConsumerRecentEntries extends StatelessWidget {
  ConsumerRecentEntries({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<List<WeightEntry>>(builder: (context, snapshot, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextTitle(text: 'Recent'),
          snapshot.isEmpty
              ? NoDataAvailable()
              : WeightEntryList(entries: snapshot),
        ],
      );
    });
  }
}

class AnimatedRecentEntries extends StatelessWidget {
  final Stream<List<WeightEntry>> _stream =
      getIt<WeightEntryService>().getStream();
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextTitle(text: 'Recent'),
        initialData.isEmpty
            ? NoDataAvailable()
            : AnimatedStreamList<WeightEntry>(
                streamList: _stream,
                initialList: initialData,
                shrinkWrap: true,
                scrollPhysics: NeverScrollableScrollPhysics(),
                equals: (a, b) => equal(a, b),
                itemBuilder: (item, index, context, animation) =>
                    _createTile(item, animation),
                itemRemovedBuilder: (item, index, context, animation) =>
                    _createTile(item, animation)),
      ],
    );
  }
}
