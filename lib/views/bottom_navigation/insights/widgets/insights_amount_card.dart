import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/extensions/context_extension.dart';

class InsightsAmountCard extends StatelessWidget {
  final String cardTitle;
  final double amount;

  const InsightsAmountCard({
    super.key,

    required this.cardTitle,
    required this.amount
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.sizeContext.width,
      padding: .symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: .circular(12),
        border: .all(
          color: Colors.black.withValues(alpha: 0.2),
          width: 1
        )
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            cardTitle,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.4),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),

          RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 18
              ),
              children: [
                TextSpan(text: '£ '),
                TextSpan(text: amount.toString())
              ]
            ),
          )
        ],
      ),
    );
  }
}
