import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../../core/enums/player_state.dart';

class PlayerAnimation {
  double animationTimer = 0.0;
  int currentFrame = 0;
  double laneTiltAngle = 0.0;
  double targetTiltAngle = 0.0;

  void update(double dt, {double currentX = 0, double targetX = 0}) {
    animationTimer += dt;
    if (animationTimer >= 0.07) {
      animationTimer = 0.0;
      currentFrame = (currentFrame + 1) % 8; // 8-frame smooth gait cycle
    }

    // 3D Lean Angle when moving between lanes
    final double diffX = targetX - currentX;
    targetTiltAngle = (diffX * 0.0035).clamp(-0.25, 0.25);
    laneTiltAngle +=
        (targetTiltAngle - laneTiltAngle) * (18.0 * dt).clamp(0.0, 1.0);
  }

  void renderPlayerCanvas(
    Canvas canvas,
    Size size,
    PlayerState state,
    bool isInvincible, {
    String activePowerUp = '',
    ui.Image? sprite3d,
  }) {
    canvas.save();

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // 1. Dynamic 3D Stride Bobbing (Step impact physics)
    final double stepBob = (state == PlayerState.running)
        ? sin(currentFrame * (pi / 4)).abs() * 5.0
        : 0.0;

    // 2. Dynamic Ground Shadow (Scales & fades with jump/slide physics)
    final Paint shadowPaint = Paint()
      ..color = Colors.black
          .withValues(alpha: (state == PlayerState.jumping) ? 0.2 : 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final double shadowWidth =
        (state == PlayerState.jumping) ? size.width * 0.45 : size.width * 0.8;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, size.height - 2),
        width: shadowWidth,
        height: 14,
      ),
      shadowPaint,
    );

    // 3. Active Power-Up 3D Aura Glow
    if (isInvincible || activePowerUp.isNotEmpty) {
      Color auraColor = Colors.cyanAccent;
      if (activePowerUp.contains('2X')) auraColor = Colors.amberAccent;
      if (activePowerUp.contains('Magnet')) auraColor = Colors.blueAccent;

      final Paint auraPaint = Paint()
        ..color =
            auraColor.withValues(alpha: 0.5 + 0.25 * sin(animationTimer * 12))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7.0
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

      canvas.drawCircle(
        Offset(centerX, centerY),
        size.width * 0.72,
        auraPaint,
      );
    }

    // 4. 3D Transforms (Lean Tilt, Step Bobbing, Jump Scale, Slide Compress)
    canvas.translate(centerX, centerY + stepBob);
    canvas.rotate(laneTiltAngle);

    if (state == PlayerState.jumping) {
      canvas.scale(1.15, 1.15); // Scale closer to 3D camera
    } else if (state == PlayerState.sliding) {
      canvas.scale(1.15, 0.55); // Crouch flatten when sliding under obstacles
    }

    canvas.translate(-centerX, -centerY);

    // 5. Render Realistic 3D Human Runner Character
    _renderRealisticHumanCharacter(canvas, size, state);

    canvas.restore();
  }

  void _renderRealisticHumanCharacter(
      Canvas canvas, Size size, PlayerState state) {
    final double centerX = size.width / 2;

    // 8-Phase Running Gait Kinematics
    final double stridePhase = currentFrame * (pi / 4);
    final double leftLegAngle = sin(stridePhase) * 22.0;
    final double rightLegAngle = -leftLegAngle;
    final double leftKneeBend = (leftLegAngle > 0) ? leftLegAngle * 0.6 : 0.0;
    final double rightKneeBend =
        (rightLegAngle > 0) ? rightLegAngle * 0.6 : 0.0;

    // --- PAINTS ---
    final Paint skinPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFFD1A4), Color(0xFFE0A96D)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final Paint shirtPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF15803D), Color(0xFF166534)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final Paint vestPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF9A3412), Color(0xFF7C2D12)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final Paint pantsPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF334155), Color(0xFF1E293B)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final Paint bootPaint = Paint()
      ..color = const Color(0xFF451A03)
      ..strokeCap = StrokeCap.round;

    final Paint outlinePaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Paint shadowShade = Paint()
      ..color = Colors.black.withValues(alpha: 0.25);

    // --- 1. LEGS & LEATHER BOOTS (FULL RUNNING GAIT) ---
    final double hipY = size.height * 0.62;

    // Left Leg (Thigh + Knee + Boot)
    final Offset leftKnee = Offset(
      centerX - 10 + leftLegAngle * 0.7,
      hipY + 20 - leftKneeBend,
    );
    final Offset leftFoot = Offset(
      centerX - 12 + leftLegAngle * 1.1,
      size.height - 6,
    );

    canvas.drawLine(
        Offset(centerX - 10, hipY), leftKnee, pantsPaint..strokeWidth = 12);
    canvas.drawLine(leftKnee, leftFoot, pantsPaint..strokeWidth = 10);
    // Boot
    canvas.drawCircle(leftFoot, 7, bootPaint);
    canvas.drawRect(
        Rect.fromLTWH(leftFoot.dx - 6, leftFoot.dy - 3, 14, 8), bootPaint);

    // Right Leg (Thigh + Knee + Boot)
    final Offset rightKnee = Offset(
      centerX + 10 + rightLegAngle * 0.7,
      hipY + 20 - rightKneeBend,
    );
    final Offset rightFoot = Offset(
      centerX + 10 + rightLegAngle * 1.1,
      size.height - 6,
    );

    canvas.drawLine(
        Offset(centerX + 10, hipY), rightKnee, pantsPaint..strokeWidth = 12);
    canvas.drawLine(rightKnee, rightFoot, pantsPaint..strokeWidth = 10);
    // Boot
    canvas.drawCircle(rightFoot, 7, bootPaint);
    canvas.drawRect(
        Rect.fromLTWH(rightFoot.dx - 6, rightFoot.dy - 3, 14, 8), bootPaint);

    // --- 2. TORSO & LEATHER VEST ---
    final RRect torso = RRect.fromRectAndRadius(
      Rect.fromLTWH(centerX - 18, size.height * 0.3, 36, size.height * 0.34),
      const Radius.circular(10),
    );
    canvas.drawRRect(torso, shirtPaint);
    canvas.drawRRect(torso, shadowShade);

    // Leather Vest (Left & Right Flaps)
    final Path leftVest = Path()
      ..moveTo(centerX - 18, size.height * 0.3)
      ..lineTo(centerX - 4, size.height * 0.3)
      ..lineTo(centerX - 6, size.height * 0.62)
      ..lineTo(centerX - 18, size.height * 0.62)
      ..close();

    final Path rightVest = Path()
      ..moveTo(centerX + 18, size.height * 0.3)
      ..lineTo(centerX + 4, size.height * 0.3)
      ..lineTo(centerX + 6, size.height * 0.62)
      ..lineTo(centerX + 18, size.height * 0.62)
      ..close();

    canvas.drawPath(leftVest, vestPaint);
    canvas.drawPath(rightVest, vestPaint);
    canvas.drawPath(leftVest, outlinePaint);
    canvas.drawPath(rightVest, outlinePaint);

    // Leather Belt & Brass Buckle
    final Paint beltPaint = Paint()..color = const Color(0xFF451A03);
    final Paint bucklePaint = Paint()..color = const Color(0xFFFFD700);
    canvas.drawRect(
        Rect.fromLTWH(centerX - 18, size.height * 0.6, 36, 7), beltPaint);
    canvas.drawRect(
        Rect.fromLTWH(centerX - 5, size.height * 0.59, 10, 9), bucklePaint);

    // --- 3. ANIMATED 3D ARMS & HANDS (SWINGING IN OPPOSITION) ---
    final double shoulderY = size.height * 0.34;
    final double armSwing = rightLegAngle *
        0.8; // Opposite to leg motion for natural running balance

    // Left Arm
    final Offset leftElbow =
        Offset(centerX - 24, shoulderY + 16 + armSwing * 0.3);
    final Offset leftHand = Offset(centerX - 28 + armSwing, shoulderY + 34);
    canvas.drawLine(
        Offset(centerX - 16, shoulderY), leftElbow, skinPaint..strokeWidth = 9);
    canvas.drawLine(leftElbow, leftHand, skinPaint..strokeWidth = 7);
    canvas.drawCircle(leftHand, 5, skinPaint); // Fist

    // Right Arm
    final Offset rightElbow =
        Offset(centerX + 24, shoulderY + 16 - armSwing * 0.3);
    final Offset rightHand = Offset(centerX + 28 - armSwing, shoulderY + 34);
    canvas.drawLine(Offset(centerX + 16, shoulderY), rightElbow,
        skinPaint..strokeWidth = 9);
    canvas.drawLine(rightElbow, rightHand, skinPaint..strokeWidth = 7);
    canvas.drawCircle(rightHand, 5, skinPaint); // Fist

    // --- 4. REALISTIC HEAD, FACE & EXPLORER HAT ---
    final double headCenterY = size.height * 0.18;

    // Head Oval
    canvas.drawCircle(Offset(centerX, headCenterY), 16, skinPaint);
    canvas.drawCircle(Offset(centerX, headCenterY), 16, outlinePaint);

    // Hair
    final Paint hairPaint = Paint()..color = const Color(0xFF451A03);
    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, headCenterY - 4), radius: 16),
      pi,
      pi,
      true,
      hairPaint,
    );

    // 3D Explorer Hat Brim
    final Paint hatPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF78350F), Color(0xFF451A03)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final Paint hatRibbonPaint = Paint()..color = const Color(0xFF0F172A);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, headCenterY - 10),
        width: 48,
        height: 16,
      ),
      hatPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, headCenterY - 10),
        width: 48,
        height: 16,
      ),
      outlinePaint,
    );

    // Hat Crown
    final RRect crown = RRect.fromRectAndRadius(
      Rect.fromLTWH(centerX - 14, headCenterY - 24, 28, 14),
      const Radius.circular(7),
    );
    canvas.drawRRect(crown, hatPaint);
    canvas.drawRect(
        Rect.fromLTWH(centerX - 14, headCenterY - 14, 28, 4), hatRibbonPaint);
  }
}
