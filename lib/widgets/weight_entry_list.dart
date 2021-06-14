import 'package:flutter/material.dart';
import 'package:mxg/models/weight_entry.dart';

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
      color: Colors.white,
      elevated: true,
    );
  }
}
