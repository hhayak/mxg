import 'package:flutter/material.dart';
import 'package:mxg/models/mxg_user.dart';
import 'package:mxg/models/reminder.dart';
import 'package:mxg/routes.dart';
import 'package:mxg/services/all_services.dart';
import 'package:mxg/services/services.dart';
import 'package:mxg/widgets/flat_card.dart';
import 'package:mxg/widgets/future_button.dart';
import 'package:mxg/widgets/text_title.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ProfileTab extends StatelessWidget {
  final Future<MxgUser?> getUserFuture =
      getIt<UserService>().getUser(getIt<AuthService>().getCurrentUser()!.uid);

  Future<void> handleLogout() async {
    await getIt<AuthService>().logout();
    getIt<NavigationService>().push(Routes.login, clear: true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MxgUser?>(
      future: getUserFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UserReminder(
                reminder: snapshot.data!.reminder,
              ),
              ElevatedButton(
                child: Text('Logout'),
                onPressed: handleLogout,
              ),
            ],
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class UserReminder extends StatefulWidget {
  final Reminder? reminder;

  const UserReminder({Key? key, this.reminder}) : super(key: key);

  @override
  _UserReminderState createState() => _UserReminderState();
}

class _UserReminderState extends State<UserReminder> {
  Reminder? _reminder;

  @override
  void initState() {
    _reminder = widget.reminder;
    super.initState();
  }

  Future<void> handlePressed() async {
    if (_reminder == null) {
      _reminder = await showDialog<Reminder>(
        context: context,
        builder: (context) => AddReminderDialog(),
      );
      setState(() {});
    } else {
      getIt<NotificationService>().disableReminder(_reminder!);
      getIt<UserService>().deleteReminder(_reminder!);
      setState(() {
        _reminder = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var hasReminder = _reminder != null;
    return FlatCard.filled(
        color: Colors.teal.withOpacity(0.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextTitle(text: 'Reminders'),
            if (hasReminder) ...{
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                    'Frequency: ${_reminder.toString()}, at ${_reminder!.time.format(context)}'),
              )
            },
            TextButton.icon(
              onPressed: handlePressed,
              label: Text(hasReminder ? 'Delete Reminder' : 'Add Reminder'),
              icon: Icon(hasReminder ? Icons.remove : Icons.add),
            )
          ],
        ));
  }
}

class AddReminderDialog extends StatelessWidget {
  final FormControl<Frequency> freqControl =
      FormControl<Frequency>(value: Frequency.daily);
  final FormControl<TimeOfDay> timeControl =
      FormControl<TimeOfDay>(value: TimeOfDay.now());
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  Future<void> handleAdd() async {
    var reminder = Reminder(0, freqControl.value!, timeControl.value!);
    await Future.wait([
      getIt<UserService>().addReminder(reminder),
      getIt<NotificationService>().setReminder(reminder),
    ]);
    getIt<NavigationService>().pop(reminder);
  }

  AddReminderDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ReactiveFormBuilder(
          form: () => FormGroup({
            'frequency': freqControl,
            'time': timeControl,
          }),
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
                    ),
                    DropdownMenuItem<Frequency>(
                      child: Text('Weekly'),
                      value: Frequency.weekly,
                    ),
                    DropdownMenuItem<Frequency>(
                      child: Text('Monthly'),
                      value: Frequency.monthly,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              ReactiveTimePicker(
                formControlName: 'time',
                builder: (context, picker, child) => GestureDetector(
                  onTap: picker.showPicker,
                  child: TimeDisplay(
                    time: timeControl.value!,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              FutureButton(
                controller: _btnController,
                onPressed: handleAdd,
                text: 'Add',
              ),
            ],
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
