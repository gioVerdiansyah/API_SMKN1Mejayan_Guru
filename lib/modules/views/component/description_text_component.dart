import 'package:flutter/cupertino.dart';

class DescriptionText extends StatefulWidget {
  const DescriptionText({super.key, required this.alasan, this.maxLength = 200});
  final String alasan;
  final int maxLength;

  @override
  State<DescriptionText> createState() => _DescriptionFragment();
}

class _DescriptionFragment extends State<DescriptionText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    String alasan = widget.alasan;
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Text(
        isExpanded ? alasan : (alasan.length > widget.maxLength ? '${alasan.substring(0, widget.maxLength)}...' : alasan),
        overflow: TextOverflow.visible,
      ),
    );
  }
}