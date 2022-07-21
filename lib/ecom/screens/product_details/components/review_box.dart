import 'package:new_swarn_holidays/ecom/models/Review.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';

class ReviewBox extends StatelessWidget {
  final Review review;
  const ReviewBox({
    Key? key,
    required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: kTextColor.withOpacity(0.075),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              review.feedback!,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            children: [
              const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              Text(
                "${review.rating}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
