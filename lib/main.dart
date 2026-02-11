import 'package:flutter/material.dart';

void main() => runApp(const ValentineApp());

class ValentineApp extends StatelessWidget {
  const ValentineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ValentineHome(),
      theme: ThemeData(useMaterial3: true),
    );
  }
}

class ValentineHome extends StatefulWidget {
  const ValentineHome({super.key});

  @override
  State<ValentineHome> createState() => _ValentineHomeState();
}

class _ValentineHomeState extends State<ValentineHome>
    with SingleTickerProviderStateMixin {
  final List<String> emojiOptions = ['Sweet Heart', 'Party Heart'];
  String selectedEmoji = 'Sweet Heart';
  double heartScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cupid\'s Canvas')),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // ---The Emoji DropDown
          DropdownButton<String>(
            value: selectedEmoji,
            items: emojiOptions
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) =>
                setState(() => selectedEmoji = value ?? selectedEmoji),
          ),
          const SizedBox(height: 16),

          // <-- Added image from assets
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/chocolate.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                heartScale = heartScale == 1.0 ? 1.2 : 1.0;
              });
            },
            child: const Text('Pulse Heart'),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: Transform.scale(
                scale: heartScale,
                child: CustomPaint(
                  size: const Size(300, 300),
                  painter: HeartEmojiPainter(type: selectedEmoji),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeartEmojiPainter extends CustomPainter {
  HeartEmojiPainter({required this.type});
  final String type;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;

    // Heart base
    final heartPath = Path()
      ..moveTo(center.dx, center.dy + 60)
      ..cubicTo(
        center.dx + 110,
        center.dy - 10,
        center.dx + 60,
        center.dy - 120,
        center.dx,
        center.dy - 40,
      )
      ..cubicTo(
        center.dx - 60,
        center.dy - 120,
        center.dx - 110,
        center.dy - 10,
        center.dx,
        center.dy + 60,
      )
      ..close();

    paint.color = type == 'Party Heart'
        ? const Color(0xFFF48FB1)
        : const Color(0xFFE91E63);
    canvas.drawPath(heartPath, paint);

    // Face features
    if (type == 'Sweet Heart') {
      final eyePaint = Paint()..color = Colors.white;
      canvas.drawCircle(Offset(center.dx - 30, center.dy - 10), 10, eyePaint);
      canvas.drawCircle(Offset(center.dx + 30, center.dy - 10), 10, eyePaint);

      final mouthPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(center.dx, center.dy + 20), radius: 30),
        0,
        3.14,
        false,
        mouthPaint,
      );
    } else if (type == 'Party Heart') {
      final eyePaint = Paint()..color = Colors.white;
      canvas.drawCircle(Offset(center.dx - 30, center.dy - 10), 10, eyePaint);
      canvas.drawCircle(Offset(center.dx + 30, center.dy - 10), 10, eyePaint);

      final mouthPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(center.dx, center.dy + 20), radius: 30),
        0,
        3.14,
        false,
        mouthPaint,
      );

      // Party hat placeholder
      final hatPaint = Paint()..color = const Color(0xFFFFD54F);
      final hatPath = Path()
        ..moveTo(center.dx, center.dy - 110)
        ..lineTo(center.dx - 40, center.dy - 40)
        ..lineTo(center.dx + 40, center.dy - 40)
        ..close();
      canvas.drawPath(hatPath, hatPaint);

      // Confetti
      final confettiPaint = Paint()
        ..color = Colors
            .primaries[DateTime.now().millisecond % Colors.primaries.length]
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke;

      for (int i = 0; i < 20; i++) {
        final x = center.dx + (i * 7) * (i % 2 == 0 ? 1 : -1);
        final y = center.dy + (i * 5) * (i % 3 == 0 ? 1 : -1);
        canvas.drawCircle(Offset(x, y), 4, confettiPaint);
        canvas.drawLine(Offset(x, y), Offset(x + 5, y + 5), confettiPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant HeartEmojiPainter oldDelegate) =>
      oldDelegate.type != type;
}
