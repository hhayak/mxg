import 'package:flutter/material.dart';
import 'package:mxg/models/reminder.dart';
import 'package:mxg/services/services.dart';
import 'package:mxg/widgets/text_title.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:get/get.dart';

import 'flat_card.dart';
import 'future_button.dart';

class ReminderCreator extends GetxController {
  late FormGroup form;

  @override
  void onInit() {
    form = FormGroup({
      'frequency': FormControl<Frequency>(value: Frequency.daily),
      'time': FormControl<TimeOfDay>(value: TimeOfDay.now()),
      'weekday': FormControl<int>(value: DateTime.now().weekday),
    });
    super.onInit();
  }

  void setFrequency(Frequency value) {
    form.control('frequency').updateValue(value);
    update(['frequency', 'weekday']);
  }

  void setTime(TimeOfDay value) {
    form.control('time').updateValue(value);
    update(['time']);
  }

  void setWeekday(int value) {
    form.control('weekday').updateValue(value);
    update(['weekday']);
  }

  Future<void> handleAdd() async {
    var reminder = Reminder(0, form.control('frequency').value!,
        form.control('time').value!, form.control('weekday').value);
    print(form.value);
    await Future.wait([
      getIt<UserService>().addReminder(reminder),
      getIt<NotificationService>().setReminder(reminder),
    ]);
    getIt<NavigationService>().pop(reminder);
  }
}

class AddReminderDialog extends StatelessWidget {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  //final ReminderCreator controller = ReminderCreator()..onInit();
  AddReminderDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReminderCreator>(
      id: 'init',
      init: ReminderCreator(),
      builder: (controller) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ReactiveFormBuilder(
            form: () => controller.form,
            builder: (context, form, child) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    TextTitle(text: 'Add Reminder'),
                    Spacer(),
                    CloseButton(
                      onPressed: () => getIt<NavigationService>().pop(null),
                    ),
                  ],
                ),
                SizedBox(
                  width: 150,
                  child: ReactiveDropdownField(
                    formControlName: 'frequency',
                    itemHeight: 60,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: [
                      DropdownMenuItem<Frequency>(
                        child: Text('Daily'),
                        value: Frequency.daily,
                        onTap: () => controller.setFrequency(Frequency.daily),
                      ),
                      DropdownMenuItem<Frequency>(
                        child: Text('Weekly'),
                        value: Frequency.weekly,
                        onTap: () => controller.setFrequency(Frequency.weekly),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                WeekdayPicker(),
                SizedBox(height: 15),
                ReactiveTimePicker(
                  formControlName: 'time',
                  builder: (context, picker, child) => GestureDetector(
                    onTap: picker.showPicker,
                    child: GetBuilder<ReminderCreator>(
                      id: 'time',
                      builder: (controller) => TimeDisplay(
                        time: controller.form.control('time').value!,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                FutureButton(
                  controller: _btnController,
                  onPressed: controller.handleAdd,
                  text: 'Add',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimeDisplay extends StatelessWidget {
  final TimeOfDay time;

  const TimeDisplay({Key? key, required this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FlatCard.outlined(
            child: Text('${time.hour.toString()}H'), color: Colors.teal),
        FlatCard.outlined(
            child: Text('${time.minute.toString()}M'), color: Colors.teal),
      ],
    );
  }
}

class WeekdayPicker extends StatefulWidget {
  const WeekdayPicker({Key? key}) : super(key: key);

  @override
  _WeekdayPickerState createState() => _WeekdayPickerState();
}

class _WeekdayPickerState extends State<WeekdayPicker>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReminderCreator>(
      id: 'weekday',
      builder: (controller) => AnimatedSize(
        vsync: this,
        duration: Duration(milliseconds: 200),
        alignment: Alignment.topCenter,
        child: ListView.builder(
          itemBuilder: (context, index) =>
              controller.form.control('weekday').value == index + 1
                  ? FlatCard.filled(
                      child: Text(Reminder.weekdays[index + 1]!.capitalize!),
                      color: Colors.teal,
                      onTap: () => controller.setWeekday(index + 1),
                    )
                  : FlatCard.outlined(
                      child: Text(Reminder.weekdays[index + 1]!.capitalize!),
                      color: Colors.teal,
                      onTap: () => controller.setWeekday(index + 1),
                    ),
          shrinkWrap: true,
          itemCount:
              controller.form.control('frequency').value == Frequency.weekly
                  ? 7
                  : 0,
          physics: NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }
}
