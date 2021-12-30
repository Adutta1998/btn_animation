import 'package:flutter/material.dart';

class SliderRecorder extends StatefulWidget {
  final double paddingHorizontal;
  const SliderRecorder({
    Key? key,
    required this.paddingHorizontal,
  }) : super(key: key);

  @override
  _SliderRecorderState createState() => _SliderRecorderState();
}

class _SliderRecorderState extends State<SliderRecorder> {
  Offset position = Offset(0, 0);
  Offset currentPosition = Offset(0, 0);
  Offset previousPosition = Offset(0, 0);
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
              color: isDragging ? Colors.pink[100] : Colors.white,
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
                  });
                } else if (d.offset.dx > width) {
                  setState(() {
                    position = Offset(width - 0, 0);
                    currentPosition = position;
                    showRecordingGif = false;
                  });
                }
                setState(() {
                  (d.offset.dx > width / 3)
                      ? position =
                          Offset(width - 48 - (widget.paddingHorizontal * 2), 0)
                      : position = Offset(0, 0);
                  currentPosition = position;
                });
                showRecordingGif = true;
                print("dragend");
                previousPosition = d.offset;
              },
              child: FloatingActionButton.small(
                onPressed: () => _onTap(key),
                child: Icon(showRecordingGif ? Icons.stop : Icons.mic),
                backgroundColor:
                    showRecordingGif ? Colors.red : Colors.purple.shade300,
              ),
              feedback: FloatingActionButton.small(
                onPressed: () {},
                backgroundColor: Colors.pink,
                child: Icon(Icons.chevron_right_rounded),
              ),
              childWhenDragging: FloatingActionButton.small(
                onPressed: () {},
                backgroundColor: Colors.red,
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

  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
    setState(() {
      position = Offset(0, 0);
      isDragging = false;
      currentPosition = position;
      showRecordingGif = false;
    });
  }
}
