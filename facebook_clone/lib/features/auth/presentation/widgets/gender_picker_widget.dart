import 'package:facebook_clone/features/auth/presentation/widgets/gender_radio_tile_widget.dart';
import 'package:flutter/cupertino.dart';

import '/core/constants/app_colors.dart';
import '/core/constants/constants.dart';

class GenderPickerWidget extends StatelessWidget {
  const GenderPickerWidget({
    Key? key,
    required this.gender,
    required this.onChanged,
  }) : super(key: key);

  final String? gender;
  final Function(String? value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Constants.defaultPadding,
      decoration: BoxDecoration(
        color: AppColors.darkWhiteColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          GenderRadioTileWidget(
            title: 'Male',
            value: 'male',
            selectedValue: gender,
            onChanged: onChanged,
          ),
          GenderRadioTileWidget(
            title: 'Female',
            value: 'female',
            selectedValue: gender,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
