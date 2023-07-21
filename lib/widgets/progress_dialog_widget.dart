import 'package:flutter/material.dart';
import 'package:video_compress/video_compress.dart';

class ProgressDialogWidget extends StatefulWidget {
  const ProgressDialogWidget({super.key});

  @override
  State<ProgressDialogWidget> createState() => _ProgressDialogWidgetState();
}

class _ProgressDialogWidgetState extends State<ProgressDialogWidget> {
  late Subscription subscription;
  double? progress;

  @override
  void initState() {
    subscription = VideoCompress.compressProgress$.subscribe(
      (event) => setState(() => progress = event),
    );
    super.initState();
  }

  @override
  void dispose() {
    VideoCompress.cancelCompression();
    subscription.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /* using linear progress indicator to show the progress of
    image compression  */
    final value = progress == null ? progress : progress! / 100;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Compressing Video'),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            value: value,
            minHeight: 12,
            color: Colors.amberAccent,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).appBarTheme.backgroundColor,
                  foregroundColor: Colors.black),
              onPressed: () => VideoCompress.cancelCompression(),
              child: const Text('Cancel'))
        ],
      ),
    );
  }
}
