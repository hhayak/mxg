import 'package:flutter/material.dart';
import 'package:mxg/models/weight_entry.dart';
import 'package:mxg/services/services.dart';
import 'package:mxg/widgets/future_button.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'flat_card.dart';

class WeightEntryList extends StatelessWidget {
  final List<WeightEntry> entries;

  const WeightEntryList({Key? key, required this.entries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return entries.isEmpty
        ? Center(child: Text('No entries.'))
        : ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: entries.length,
            itemBuilder: (context, index) => WeightEntryTile(
              entry: entries[index],
            ),
          );
  }
}

class WeightEntryTile extends StatelessWidget {
  final WeightEntry entry;

  const WeightEntryTile({Key? key, required this.entry}) : super(key: key);

  void showModalSheet(BuildContext context) {
    var _btnController = RoundedLoadingButtonController();
    showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        builder: (context) => SizedBox(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FutureButton(
                      controller: _btnController,
                      text: 'Delete',
                      color: Colors.red.shade500,
                      onPressed: () async {
                        await getIt<WeightEntryService>()
                            .deleteWeightEntry(entry.id);
                        getIt<NavigationService>().pop();
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    OutlinedButton(
                      onPressed: getIt<NavigationService>().pop,
                      child: Text('Cancel'),
                    ),
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return FlatCard.filled(
      child: Row(
        children: [
          Text(
            entry.weight.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Spacer(),
          Text('${entry.date.day}/${entry.date.month}/${entry.date.year}'),
        ],
      ),
      color: Theme.of(context).primaryColor,
      elevated: true,
      onTap: () => showModalSheet(context),
    );
  }
}
