import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class MinimalTimePicker extends StatefulWidget {
  final FormControl<DateTime> control;

  const MinimalTimePicker({Key? key, required this.control}) : super(key: key);

  @override
  _MinimalTimePickerState createState() => _MinimalTimePickerState();
}

class _MinimalTimePickerState extends State<MinimalTimePicker>
    with SingleTickerProviderStateMixin {
  late DateTime today;

  bool isToday() {
    return widget.control.value!.difference(today).inDays == 0;
  }

  void setDate(DateTime value) {
    setState(() {
      widget.control.updateValue(value);
    });
  }

  @override
  void initState() {
    today = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var date = widget.control.value;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('${date!.day.toString()}/${date.month}/${date.year}'),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            vsync: this,
            child: OutlinedButton(
              onPressed: () => setDate(today),
              child: Row(
                children: [
                  Text('Today'),
                  if (isToday()) ...{
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Icon(
                        Icons.check,
                        size: 20,
                      ),
                    )
                  },
                ],
              ),
            ),
          ),
          IconButton(
              onPressed: () async {
                var selectedDate = await showDatePicker(
                  context: context,
                  initialDate: today,
                  firstDate: today.subtract(Duration(days: 365)),
                  lastDate: today,
                  currentDate: today,
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                  initialDatePickerMode: DatePickerMode.day,
                );
                if (selectedDate != null) {
                  setDate(selectedDate);
                }
              },
              icon: Icon(Icons.date_range_outlined)),
        ],
      ),
    );
  }
}
