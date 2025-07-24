import 'package:flutter/material.dart';

class OverlayLoader extends StatelessWidget {
  final bool showLoader;
  final Widget child;

  const OverlayLoader({
    super.key,
    required this.showLoader,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          child,
          if (showLoader)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.6),
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
