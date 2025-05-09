import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pudez_street_playground/common/style/color.dart';

class MapDialog extends StatefulWidget {
  const MapDialog({super.key});

  @override
  State<MapDialog> createState() => _MapDialogState();
}

class _MapDialogState extends State<MapDialog> {
  double angle = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: Transform.rotate(
            angle: angle * 3.14 / 180,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (angle == 0) {
                    angle = 90;
                  } else {
                    angle = 0;
                  }
                });
              },
              child: ExtendedImage.asset(
                'images/map/map.png',
                mode: ExtendedImageMode.gesture,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: context.pop,
              child: CircleAvatar(
                backgroundColor: textPrimary.withValues(
                  alpha: 0.6,
                ),
                child: Icon(
                  Icons.close,
                  color: white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
