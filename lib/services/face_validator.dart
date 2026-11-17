import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

/// Outcome of checking a picked photo for a usable face.
enum FaceCheckResult { ok, noFace, multipleFaces, faceTooSmall, notFrontal, error }

/// On-device face check (Google ML Kit) used before a profile photo is
/// accepted. Only runs on Android / iOS; other platforms always pass.
class FaceValidator {
  FaceValidator._();

  /// Face width must be at least this fraction of the image's shorter side.
  static const double minFaceRatio = 0.20;

  /// Max head turn (left/right) and tilt, in degrees, to count as "facing the camera".
  static const double maxYaw = 25;
  static const double maxRoll = 25;

  static FaceDetector? _detector;
  static FaceDetector get _faceDetector => _detector ??= FaceDetector(
        options: FaceDetectorOptions(
          performanceMode: FaceDetectorMode.accurate,
          minFaceSize: 0.1,
        ),
      );

  static bool get isSupported =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  /// Checks the image at [path].
  /// [requireSingle] = true rejects photos with more than one face
  /// (used for the main profile photo).
  static Future<FaceCheckResult> check(
    String path, {
    bool requireSingle = true,
  }) async {
    if (!isSupported) return FaceCheckResult.ok;
    try {
      final faces =
          await _faceDetector.processImage(InputImage.fromFilePath(path));
      if (faces.isEmpty) return FaceCheckResult.noFace;
      if (requireSingle && faces.length > 1) {
        return FaceCheckResult.multipleFaces;
      }

      // Judge the most prominent face.
      final face = faces.reduce(
        (a, b) => a.boundingBox.width >= b.boundingBox.width ? a : b,
      );

      final shortSide = await _shortSide(path);
      if (shortSide != null &&
          face.boundingBox.width < shortSide * minFaceRatio) {
        return FaceCheckResult.faceTooSmall;
      }

      final yaw = face.headEulerAngleY;
      final roll = face.headEulerAngleZ;
      if ((yaw != null && yaw.abs() > maxYaw) ||
          (roll != null && roll.abs() > maxRoll)) {
        return FaceCheckResult.notFrontal;
      }
      return FaceCheckResult.ok;
    } catch (e) {
      debugPrint('face check failed: $e');
      return FaceCheckResult.error;
    }
  }

  /// Shorter side of the image in pixels (orientation-independent),
  /// read from the image header without a full decode.
  static Future<int?> _shortSide(String path) async {
    try {
      final bytes = await File(path).readAsBytes();
      final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
      final descriptor = await ui.ImageDescriptor.encoded(buffer);
      final side = math.min(descriptor.width, descriptor.height);
      descriptor.dispose();
      buffer.dispose();
      return side;
    } catch (_) {
      return null;
    }
  }

  static String message(FaceCheckResult r) => switch (r) {
        FaceCheckResult.ok => '',
        FaceCheckResult.noFace =>
          "We couldn't find a face. Please upload a clear photo of yourself.",
        FaceCheckResult.multipleFaces =>
          'Please upload a photo with only you in it for your main photo.',
        FaceCheckResult.faceTooSmall =>
          'Your face is too small in this photo. Please use a closer photo.',
        FaceCheckResult.notFrontal =>
          'Please use a photo where you are facing the camera.',
        FaceCheckResult.error =>
          'Could not check this photo. Please try another one.',
      };
}
