import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ArCameraPreview extends StatelessWidget {
  const ArCameraPreview({
    super.key,
    required this.controller,
    required this.isReady,
    this.errorMessage,
  });

  final CameraController? controller;
  final bool isReady;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final previewController = controller;
    if (!isReady || previewController == null || !previewController.value.isInitialized) {
      return _CameraPreviewFallback(message: errorMessage ?? 'Opening camera preview...');
    }

    final previewSize = previewController.value.previewSize;
    if (previewSize == null) {
      return _CameraPreviewFallback(message: 'Camera preview unavailable.');
    }

    final fittedPreviewSize = Size(previewSize.height, previewSize.width);

    return ColoredBox(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: fittedPreviewSize.width,
                height: fittedPreviewSize.height,
                child: CameraPreview(previewController),
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.18),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.34),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CameraPreviewFallback extends StatelessWidget {
  const _CameraPreviewFallback({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF16191E),
            Color(0xFF11151C),
            Color(0xFF090B10),
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: const SizedBox.expand(),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}