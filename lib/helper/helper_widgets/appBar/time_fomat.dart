import 'dart:async';
import 'package:flutter/material.dart';

class TimeFormat extends StatefulWidget {
  const TimeFormat({
    Key? key,
    this.showDate = true,
    this.showSeconds = true,
    this.textStyle,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.leading,
    this.borderRadius = 12.0,
  }) : super(key: key);

  /// Short helper to use the common default.
  static Widget common() => const TimeFormat();

  final bool showDate;
  final bool showSeconds;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final EdgeInsets padding;
  final Widget? leading;
  final double borderRadius;

  @override
  State<TimeFormat> createState() => _TimeFormatState();
}

class _TimeFormatState extends State<TimeFormat> {
  late final Stream<DateTime> _timeStream;

  @override
  void initState() {
    super.initState();
    // Stream cập nhật mỗi giây — không cần hủy vì Stream.periodic tự dọn khi widget bị disposed.
    _timeStream = Stream<DateTime>.periodic(
      const Duration(seconds: 1),
          (_) => DateTime.now(),
    );
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  String _buildText(DateTime t) {
    final date = '${_twoDigits(t.day)}/${_twoDigits(t.month)}/${t.year}';
    final time = '${_twoDigits(t.hour)}:${_twoDigits(t.minute)}'
        '${widget.showSeconds ? ':${_twoDigits(t.second)}' : ''}';
    return widget.showDate ? '$date  $time' : time;
  }

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w600,
    );

    return StreamBuilder<DateTime>(
      stream: _timeStream,
      builder: (context, snapshot) {
        final now = snapshot.data ?? DateTime.now();
        final text = _buildText(now);

        return Container(
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.black.withOpacity(0.06),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.leading != null) ...[
                widget.leading!,
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: widget.textStyle ?? defaultStyle,
                semanticsLabel: 'Thời gian hiện tại: $text',
              ),
            ],
          ),
        );
      },
    );
  }
}
