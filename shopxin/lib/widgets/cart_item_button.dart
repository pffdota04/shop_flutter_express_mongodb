import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartItemButton extends StatelessWidget {
  const CartItemButton({
    Key? key,
    required this.title,
    required this.function,
  }) : super(key: key);

  final String title;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        function();
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? null
              : Colors.grey.shade200,
          border: title == "Remove"
              ? Border(
                  top: BorderSide(width: 2, color: Colors.grey.shade300),
                  left: BorderSide(width: 1, color: Colors.grey.shade300),
                )
              : Border(
                  top: BorderSide(width: 2, color: Colors.grey.shade300),
                  right: BorderSide(width: 1, color: Colors.grey.shade300),
                ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              title == "Remove" ? Icons.delete : Icons.favorite,
              color: title == 'Remove' ? Colors.red : Colors.cyan,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              title,
              style: GoogleFonts.poppins(),
            ),
          ],
        ),
      ),
    );
  }
}
