import 'package:flutter/material.dart';
import 'dart:math';

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
  bool showBalloons = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
          ElevatedButton(
            onPressed: () {
              setState(() {
                showBalloons = !showBalloons;
              });
            },
            child: const Text('Balloon Celebration'),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: heartScale + 0.1 * _controller.value,
                    child: CustomPaint(
                      size: const Size(300, 300),
                      painter: HeartEmojiPainter(
                        type: selectedEmoji,
                        showBalloons: showBalloons,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeartEmojiPainter extends CustomPainter {
  HeartEmojiPainter({required this.type, this.showBalloons = false});
  final String type;
  final bool showBalloons;

  final Random random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Background radial gradient
    final bgRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final bgPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFFFC1E3), Color(0xFFE91E63)],
        center: Alignment.center,
        radius: 0.8,
      ).createShader(bgRect);
    canvas.drawRect(bgRect, bgPaint);

    // Love trail
    final trailPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.pink.withOpacity(0.2)
      ..strokeWidth = 4;
    final trailPath = Path()
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
    canvas.drawPath(trailPath, trailPaint);

    // Heart base with gradient
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
    final heartPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFF48FB1), Color(0xFFE91E63)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(center.dx - 110, center.dy - 120, 220, 180));
    canvas.drawPath(heartPath, heartPaint);

    // Face features
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

    // Party hat placeholder + confetti
    if (type == 'Party Heart') {
      final hatPaint = Paint()..color = const Color(0xFFFFD54F);
      final hatPath = Path()
        ..moveTo(center.dx, center.dy - 110)
        ..lineTo(center.dx - 40, center.dy - 40)
        ..lineTo(center.dx + 40, center.dy - 40)
        ..close();
      canvas.drawPath(hatPath, hatPaint);

      // Confetti
      for (int i = 0; i < 20; i++) {
        final confettiPaint = Paint()
          ..color = Colors.primaries[random.nextInt(Colors.primaries.length)];
        final dx = center.dx + random.nextDouble() * 200 - 100;
        final dy = center.dy + random.nextDouble() * 200 - 100;
        canvas.drawCircle(Offset(dx, dy), 5, confettiPaint);
      }
    }

    // Balloons
    if (showBalloons) {
      for (int i = 0; i < 5; i++) {
        final balloonPaint = Paint()
          ..color = Colors.primaries[i * 2 % Colors.primaries.length];
        final balloonCenter = Offset(
          center.dx - 100 + i * 50,
          center.dy - 150 - random.nextDouble() * 50,
        );
        canvas.drawOval(
          Rect.fromCenter(center: balloonCenter, width: 30, height: 40),
          balloonPaint,
        );
        canvas.drawLine(
          balloonCenter,
          Offset(balloonCenter.dx, balloonCenter.dy + 40),
          Paint()..color = Colors.black,
        );
      }
    }

    // Sparkles
    for (int i = 0; i < 15; i++) {
      final sparklePaint = Paint()..color = Colors.yellow.withOpacity(0.7);
      final angle = random.nextDouble() * 2 * pi;
      final radius = 150 * random.nextDouble();
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      canvas.drawLine(Offset(x - 2, y), Offset(x + 2, y), sparklePaint);
      canvas.drawLine(Offset(x, y - 2), Offset(x, y + 2), sparklePaint);
    }
  }

  @override
  bool shouldRepaint(covariant HeartEmojiPainter oldDelegate) =>
      oldDelegate.type != type || oldDelegate.showBalloons != showBalloons;
}
