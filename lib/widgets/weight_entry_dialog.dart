import 'package:flutter/material.dart';
import 'package:mxg/models/weight_entry.dart';
import 'package:mxg/services/services.dart';
import 'package:mxg/widgets/text_title.dart';
import 'package:mxg/widgets/weight_field.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'future_button.dart';
import 'minimal_time_picker.dart';

class WeightEntryDialog extends StatelessWidget {
  final FormControl<int> weightControl = FormControl<int>(
      value: 60, validators: [Validators.required, Validators.number]);
  final FormControl<DateTime> dateControl = FormControl<DateTime>(
      value: DateTime.now(), validators: [Validators.required]);
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  WeightEntryDialog({Key? key}) : super(key: key);

  Future<void> handleAdd() async {
    if (weightControl.valid && dateControl.valid) {
      var newEntry = WeightEntry(
          id: '0', weight: weightControl.value!, date: dateControl.value!);
      await getIt<WeightEntryService>().addWeightEntry(newEntry);
      getIt<NavigationService>().pop(newEntry);
    } else {
      _btnController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ReactiveFormBuilder(
          form: () => FormGroup({
            'weight': weightControl,
            'date': dateControl,
          }),
          builder: (context, form, child) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  TextTitle(text: 'New Measurement'),
                  Spacer(),
                  CloseButton(
                    onPressed: () => getIt<NavigationService>().pop(null),
                  ),
                ],
              ),
              MinimalTimePicker(control: dateControl),
              SizedBox(height: 15),
              WeightField(
                control: weightControl,
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    );
  }
}
