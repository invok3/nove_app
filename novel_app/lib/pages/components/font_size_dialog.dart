import 'package:flutter/material.dart';
import 'package:novel_app/translate/translator.dart';

class FontSizeAlertDialog extends StatefulWidget {
  final double value;
  const FontSizeAlertDialog({Key? key, required this.value}) : super(key: key);

  @override
  State<FontSizeAlertDialog> createState() => _FontSizeAlertDialogState();
}

class _FontSizeAlertDialogState extends State<FontSizeAlertDialog> {
  late double tsf;
  @override
  void initState() {
    tsf = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: tsf),
            child: Row(
              children: [
                Text(Translator.of(context, "fontSizeLabel") +
                    (tsf * 14).round().toString()),
              ],
            ),
          ),
          Slider(
              value: tsf * 14,
              min: 14,
              max: 28,
              divisions: 14,
              onChanged: (double v) {
                setState(() {
                  tsf = v / 14;
                });
              }),
          TextButton(
              onPressed: () {
                Navigator.pop(context, tsf);
              },
              child: Text(Translator.of(context, "set")))
        ],
      ),
    );
  }
}
