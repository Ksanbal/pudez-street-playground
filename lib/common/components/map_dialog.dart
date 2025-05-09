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
  bool rotate = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              rotate = !rotate;
            });
          },
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: ExtendedImage.asset(
              rotate ? 'assets/images/map/map_rotate.png' : 'assets/images/map/map.png',
              mode: ExtendedImageMode.gesture,
              enableSlideOutPage: true,
              fit: BoxFit.contain,
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
