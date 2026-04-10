import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/extensions/context_extension.dart';

class HomeSheetContent extends StatelessWidget {
  const HomeSheetContent({
    super.key,
    required this.onTheme,
    required this.onLogout
  });

  final void Function(bool) onTheme;
  final void Function() onLogout;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Align(
          alignment: .center,
          child: Container(
            height: 4, width: 32,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: .circular(12)
            ),
          ),
        ),
        const SizedBox(height: 20),

        Text(
          'Settings',
          textAlign: .start,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w700
          ),
        ),
        const SizedBox(height: 24),

        Container(
          width: context.sizeContext.width,
          padding: .symmetric(vertical: 20, horizontal: 12),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: .circular(8),
              border: .all(color: Colors.black.withValues(alpha: 0.2))
          ),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text('Theme', style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600
              )),

              SizedBox(
                height: 12,
                  child: Switch(value: false, onChanged: onTheme)
              )
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        ElevatedButton(
            onPressed: onLogout, 
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: .circular(8)),
              fixedSize: Size(context.sizeContext.width, 48)
            ),
            child: Row(
              children: [
                Icon(
                  Icons.logout_rounded,
                  size: 20,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                
                Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14
                  ),
                )
              ],
            )
        )
      ],
    );
  }
}
