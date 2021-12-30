import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SliderRecorder extends StatefulWidget {
  final double paddingHorizontal;
  final Color trackColor;
  final Color trackColorOnDrag;
  final Color buttonColor;
  final Color buttonColorOnDrag;
  final Color buttonColorOnDragEnd;
  final Icon dragEndIcon;
  final Icon dragStartIcon;
  final void Function()? onTap;
  final void Function()? onDragStart;
  final void Function()? onDragEnd;
  final void Function()? onTapAtEnd;

  const SliderRecorder({
    Key? key,
    this.onTap,
    this.onTapAtEnd,
    this.onDragStart,
    this.onDragEnd,
    required this.paddingHorizontal,
    this.trackColor = Colors.grey,
    this.trackColorOnDrag = Colors.green,
    this.buttonColor = Colors.blue,
    this.buttonColorOnDrag = Colors.green,
    this.buttonColorOnDragEnd = Colors.blue,
    required this.dragEndIcon,
    required this.dragStartIcon,
  }) : super(key: key);

  @override
  _SliderRecorderState createState() => _SliderRecorderState();
}

class _SliderRecorderState extends State<SliderRecorder> {
  Offset position = Offset(0, 0);
  Offset currentPosition = Offset(0, 0);
  bool isDragging = false;
  bool showRecordingGif = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    GlobalKey key = GlobalKey();

    print(width);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: widget.paddingHorizontal),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            width: width,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: showRecordingGif
                  ? widget.trackColorOnDrag
                  : widget.trackColor,
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade700,
              child: Padding(
                padding: const EdgeInsets.only(left: 48),
                child: isDragging
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chevron_right_rounded),
                          Icon(Icons.chevron_right_rounded),
                          Icon(Icons.chevron_right_rounded),
                        ],
                      )
                    : Container(),
              ),
            ),
          ),
          AnimatedPositioned(
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 250),
            left: position.dx,
            child: LongPressDraggable(
              axis: Axis.horizontal,
              onDragStarted: () => setState(() => isDragging = true),
              onDragEnd: (d) {
                if (d.offset.dx < 0) {
                  setState(() {
                    position = Offset(0, 0);
                    currentPosition = position;
                    showRecordingGif = false;
                    isDragging = false;
                  });
                } else if (d.offset.dx > width) {
                  setState(() {
                    position = Offset(width - 0, 0);
                    currentPosition = position;
                    showRecordingGif = false;
                    isDragging = false;
                  });
                }
                setState(() {
                  (d.offset.dx > width / 3)
                      ? position =
                          Offset(width - 48 - (widget.paddingHorizontal * 2), 0)
                      : position = Offset(0, 0);
                  currentPosition = position;
                  showRecordingGif = (d.offset.dx > width / 3);
                  isDragging = false;
                });
                print("dragend");
              },
              child: FloatingActionButton.small(
                onPressed: () => widget.onTap?.call(),
                child: showRecordingGif
                    ? widget.dragEndIcon
                    : widget.dragStartIcon,
                backgroundColor: showRecordingGif
                    ? widget.buttonColorOnDragEnd
                    : widget.buttonColor,
              ),
              feedback: FloatingActionButton.small(
                onPressed: () {},
                backgroundColor: widget.buttonColorOnDrag,
                child: Icon(Icons.chevron_right_rounded),
              ),
              childWhenDragging: FloatingActionButton.small(
                onPressed: () {},
                backgroundColor: widget.buttonColorOnDrag,
              ),
            ),
          ),
          if (showRecordingGif)
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: widget.paddingHorizontal * 2),
              child: Image.asset(
                "images/sound.gif",
                height: 24,
                width: width - (48 * 2) - (widget.paddingHorizontal * 2),
                fit: BoxFit.fitWidth,
              ),
            ),
        ],
      ),
    );
  }
}
