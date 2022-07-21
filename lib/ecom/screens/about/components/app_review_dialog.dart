
import 'package:flutter/material.dart';

import '../../../components/default_button.dart';
import '../../../models/AppReview.dart';
import '../../../size_config.dart';

class AppReviewDialog extends StatelessWidget {
  final AppReview? appReview;
  const AppReviewDialog({
    Key? key,
    required this.appReview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Center(
        child: Text(
          "Feedback",
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      children: [
        Center(
          child: TextFormField(
            initialValue: appReview!.feedback,
            decoration: const InputDecoration(
              hintText: "Feedback for App",
              labelText: "Feedback (optional)",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            onChanged: (value) {
              appReview!.feedback = value;
            },
            maxLines: null,
            maxLength: 150,
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(10)),
        Center(
          child: DefaultButton(
            text: "Submit",
            press: () {
              Navigator.pop(context, appReview);
            },
          ),
        ),
      ],
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 24,
      ),
    );
  }
}
