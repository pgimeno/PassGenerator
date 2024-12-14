import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:google_fonts/google_fonts.dart';

class ClickableLabel extends StatelessWidget {
  final VoidCallback onTap;
  final String label;

  const ClickableLabel({
    Key? key,
    required this.onTap,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FIcon(FAssets.icons.coffee),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.raleway(
              fontWeight: FontWeight.normal,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
