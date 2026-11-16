// import 'package:flutter/material.dart';
// import 'package:vivahbharath_app/view/custom/app_colors.dart';
// import 'package:vivahbharath_app/view/register/family_details_screen.dart';
// import 'package:vivahbharath_app/view/register/sign_up_data.dart';
// import 'package:vivahbharath_app/view/register/sign_up_options.dart';
// import 'package:vivahbharath_app/view/register/sign_up_widget.dart';

// class PhotosAboutScreen extends StatefulWidget {
//   const PhotosAboutScreen({super.key, required this.data});

//   final SignUpData data;

//   @override
//   State<PhotosAboutScreen> createState() => _PhotosAboutScreenState();
// }

// class _PhotosAboutScreenState extends State<PhotosAboutScreen> {
//   SignUpData get d => widget.data;

//   late final _aboutCtrl = TextEditingController(text: d.aboutMe);

//   @override
//   void dispose() {
//     _aboutCtrl.dispose();
//     super.dispose();
//   }

//   void _pickPhoto(int index) {
//     // TODO: pick an image (e.g. with image_picker), then:
//     // setState(() => d.photos[index] = FileImage(file));
//   }

//   void _save() => d.aboutMe = _aboutCtrl.text.trim();

//   void _onSubmitNow() {
//     _save();
//     // TODO: save the partial profile (widget.data) and leave the flow
//   }

//   void _onContinue() {
//     FocusScope.of(context).unfocus();
//     _save();
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => FamilyDetailsScreen(data: d)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SignUpScaffold(
//       step: 5,
//       title: 'Photos & about you',
//       subtitle: 'Add photos and a few lines about yourself.',
//       primaryLabel: 'Continue',
//       onPrimary: _onContinue,
//       secondaryLabel: 'Submit now',
//       onSecondary: _onSubmitNow,
//       note: 'Profiles with photos get far more responses.',
//       children: [
//         FormCard(
//           title: 'Upload photos',
//           subtitle:
//               'A clear, medium close-up works best as your profile photo.',
//           children: [
//             LayoutBuilder(
//               builder: (context, c) => GridView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 padding: EdgeInsets.zero,
//                 itemCount: SignUpOptions.photoLabels.length,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   // 3 per row on very narrow cards so labels stay readable
//                   crossAxisCount: c.maxWidth < 280 ? 3 : 4,
//                   mainAxisSpacing: 10,
//                   crossAxisSpacing: 10,
//                   childAspectRatio: 0.75,
//                 ),
//                 itemBuilder: (_, i) => _PhotoSlot(
//                   label: SignUpOptions.photoLabels[i],
//                   image: d.photos[i],
//                   isProfile: i == 0,
//                   onTap: () => _pickPhoto(i),
//                   onRemove: () => setState(() => d.photos[i] = null),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             const InfoBox(
//               icon: Icons.shield_outlined,
//               text: 'Photos are watermarked and you control who can see them.',
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//         FormCard(title: 'About me', children: [
//           LabeledField(
//             child: AppTextInput(
//               controller: _aboutCtrl,
//               hint: 'Write a few lines about yourself',
//               maxLines: 4,
//               maxLength: 255,
//             ),
//           ),
//         ]),
//       ],
//     );
//   }
// }

// class _PhotoSlot extends StatelessWidget {
//   const _PhotoSlot({
//     required this.label,
//     required this.image,
//     required this.isProfile,
//     required this.onTap,
//     required this.onRemove,
//   });

//   final String label;
//   final ImageProvider? image;
//   final bool isProfile;
//   final VoidCallback onTap;
//   final VoidCallback onRemove;

//   @override
//   Widget build(BuildContext context) {
//     if (image != null) {
//       return Stack(
//         fit: StackFit.expand,
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: AppColors.tealB, width: 3),
//               image: DecorationImage(image: image!, fit: BoxFit.cover),
//             ),
//           ),
//           Positioned(
//             top: 4,
//             right: 4,
//             child: GestureDetector(
//               onTap: onRemove,
//               child: Container(
//                 width: 26,
//                 height: 26,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: const Color(0xFFC0392B),
//                   border: Border.all(color: Colors.white, width: 2),
//                 ),
//                 child: const Icon(Icons.close_rounded,
//                     color: Colors.white, size: 16),
//               ),
//             ),
//           ),
//           if (isProfile)
//             Positioned(
//               left: 6,
//               bottom: 6,
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                 decoration: BoxDecoration(
//                   color: AppColors.tealC,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Text('Profile',
//                     style: dmText(12, w: FontWeight.w700, c: Colors.white)),
//               ),
//             ),
//         ],
//       );
//     }

//     return GestureDetector(
//       onTap: onTap,
//       child: CustomPaint(
//         foregroundPainter: _DashedBorderPainter(),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             gradient: const LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [Color(0xFFFFFCF7), Color(0xFFF8EBDD)],
//             ),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 width: 32,
//                 height: 32,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.white,
//                   border: Border.all(color: AppColors.loginBorder),
//                 ),
//                 child: const Icon(Icons.add_rounded,
//                     color: AppColors.loginText, size: 18),
//               ),
//               const SizedBox(height: 8),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 4),
//                 child: FittedBox(
//                   fit: BoxFit.scaleDown,
//                   child: Text(label,
//                       style: dmText(13,
//                           w: FontWeight.w700, c: AppColors.loginText)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _DashedBorderPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = AppColors.loginBorder
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.5;
//     final path = Path()
//       ..addRRect(RRect.fromRectAndRadius(
//           Offset.zero & size, const Radius.circular(16)));
//     for (final metric in path.computeMetrics()) {
//       for (double dist = 0; dist < metric.length; dist += 9) {
//         canvas.drawPath(metric.extractPath(dist, dist + 5), paint);
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }




import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vivahbharath_app/function.dart';
import 'package:vivahbharath_app/provider/register_provider.dart';
import 'package:vivahbharath_app/services/register_helpers.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/register/family_details_screen.dart';
import 'package:vivahbharath_app/view/register/sign_up_data.dart';
import 'package:vivahbharath_app/view/register/sign_up_widget.dart';

class PhotosAboutScreen extends StatefulWidget {
  const PhotosAboutScreen({super.key, required this.data});

  final SignUpData data;

  @override
  State<PhotosAboutScreen> createState() => _PhotosAboutScreenState();
}

class _PhotosAboutScreenState extends State<PhotosAboutScreen> {
  SignUpData get d => widget.data;
  late final RegisterProvider _rp = context.read<RegisterProvider>();

  late final _aboutCtrl = TextEditingController(text: d.aboutMe);
  final _picker = ImagePicker();

  bool _busy = false;
  List<Opt> _imageTypes = [];

  @override
  void initState() {
    super.initState();
    CommonFunctions.afterInit(_loadImageTypes);
  }

  @override
  void dispose() {
    _aboutCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadImageTypes() async {
    final rp = _rp;
    setState(() => _busy = true);
    await rp.getImageTypes();
    if (!mounted) return;
    setState(() {
      _imageTypes = (rp.imageTypesModel?.imageTypes ?? [])
          .map((e) => Opt(e.id, e.name))
          .toList();
      _ensurePhotoSlots();
      _busy = false;
    });
    if (_imageTypes.isEmpty) {
      showMsg('Could not load photo types. Please check your connection.');
    }
  }

  /// Photo type id for a slot: slot i is the i-th type from the API.
  int? _typeIdFor(int slot) =>
      slot < _imageTypes.length ? _imageTypes[slot].id : null;

  Future<void> _pickPhoto(int index) async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1600,
      );
      if (picked == null) return;
      setState(() {
        d.photos[index] = FileImage(File(picked.path));
        d.uploadedPhotos.remove(index); // new picture -> needs uploading
      });
    } catch (e) {
      debugPrint('pick photo failed: $e');
      showMsg('Could not open your gallery');
    }
  }

  /// Uploads the photos / about text that haven't been sent yet.
  /// Returns true when there was nothing to send or the server accepted it.
  Future<bool> _save() async {
    final about = _aboutCtrl.text.trim();
    d.aboutMe = about;

    final pending = <int>[
      for (var i = 0; i < d.photos.length; i++)
        if (d.photos[i] is FileImage && !d.uploadedPhotos.contains(i)) i,
    ];
    final aboutChanged = about.isNotEmpty && about != d.uploadedAbout;
    if (pending.isEmpty && !aboutChanged) return true;

    // Multipart layout sent to POST photos. Adjust these key names here if
    // the backend expects different ones.
    final fields = <String, String>{if (about.isNotEmpty) 'about': about};
    final files = <String, File>{};
    for (var n = 0; n < pending.length; n++) {
      final slot = pending[n];
      final typeId = _typeIdFor(slot);
      if (typeId == null) {
        showMsg('Photo types are not available yet. Please try again.');
        return false;
      }
      files['images[$n]'] = (d.photos[slot] as FileImage).file;
      fields['type_ids[$n]'] = '$typeId';
      fields['is_main_image[$n]'] = slot == 0 ? '1' : '0';
    }

    final rp = _rp;
    setState(() => _busy = true);
    final ok = await rp.uploadPhotos(fields: fields, files: files);
    if (!mounted) return false;
    setState(() => _busy = false);

    if (!ok) {
      showMsg(rp.photosError ?? 'Something went wrong. Please try again');
      return false;
    }
    d.uploadedPhotos.addAll(pending);
    d.uploadedAbout = about;
    return true;
  }

  Future<void> _onSubmitNow() async {
    if (_busy) return;
    FocusScope.of(context).unfocus();
    if (await _save() && mounted) await finishRegistration(context);
  }

  Future<void> _onContinue() async {
    if (_busy) return;
    FocusScope.of(context).unfocus();
    if (!await _save() || !mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FamilyDetailsScreen(data: d)),
    );
  }

  /// Grows [SignUpData.photos] so there is one slot per image type. Called
  /// before the grid reads `d.photos[i]`, so the two lists can never get out
  /// of step (e.g. after a hot reload or a fresh SignUpData).
  void _ensurePhotoSlots() {
    while (d.photos.length < _imageTypes.length) {
      d.photos.add(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    _ensurePhotoSlots();
    return BusyOverlay(
      busy: _busy,
      child: SignUpScaffold(
        step: 5,
        title: 'Photos & about you',
        subtitle: 'Add photos and a few lines about yourself.',
        primaryLabel: 'Continue',
        onPrimary: _onContinue,
        secondaryLabel: 'Submit now',
        onSecondary: _onSubmitNow,
        note: 'Profiles with photos get far more responses.',
        children: [
          FormCard(
            title: 'Upload photos',
            subtitle:
                'A clear, medium close-up works best as your profile photo.',
            children: [
              if (_imageTypes.isEmpty && !_busy)
                Center(
                  child: TextButton.icon(
                    onPressed: _loadImageTypes,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Retry loading photo types'),
                  ),
                ),
              LayoutBuilder(
                builder: (context, c) => GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: _imageTypes.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    // 3 per row on very narrow cards so labels stay readable
                    crossAxisCount: c.maxWidth < 280 ? 3 : 4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (_, i) => _PhotoSlot(
                    label: _imageTypes[i].name,
                    image: d.photos[i],
                    isProfile: i == 0,
                    onTap: () => _pickPhoto(i),
                    onRemove: () => setState(() {
                      d.photos[i] = null;
                      d.uploadedPhotos.remove(i);
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const InfoBox(
                icon: Icons.shield_outlined,
                text: 'Photos are watermarked and you control who can see them.',
              ),
              const SizedBox(height: 20),
            ],
          ),
          FormCard(title: 'About me', children: [
            LabeledField(
              child: AppTextInput(
                controller: _aboutCtrl,
                hint: 'I am a simple and family-oriented individual with a positive outlook on life. Enjoy music, travel, and spending time with close ones. Looking for a genuine and understanding life partner.',
                maxLines: 4,
                maxLength: 255,
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

class _PhotoSlot extends StatelessWidget {
  const _PhotoSlot({
    required this.label,
    required this.image,
    required this.isProfile,
    required this.onTap,
    required this.onRemove,
  });

  final String label;
  final ImageProvider? image;
  final bool isProfile;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    if (image != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.tealB, width: 3),
              image: DecorationImage(image: image!, fit: BoxFit.cover),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFC0392B),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.close_rounded,
                    color: Colors.white, size: 16),
              ),
            ),
          ),
          if (isProfile)
            Positioned(
              left: 6,
              bottom: 6,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.tealC,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('Profile',
                    style: dmText(12, w: FontWeight.w700, c: Colors.white)),
              ),
            ),
        ],
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        foregroundPainter: _DashedBorderPainter(),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFFCF7), Color(0xFFF8EBDD)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: AppColors.loginBorder),
                ),
                child: const Icon(Icons.add_rounded,
                    color: AppColors.loginText, size: 18),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(label,
                      style: dmText(13,
                          w: FontWeight.w700, c: AppColors.loginText)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.loginBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Offset.zero & size, const Radius.circular(16)));
    for (final metric in path.computeMetrics()) {
      for (double dist = 0; dist < metric.length; dist += 9) {
        canvas.drawPath(metric.extractPath(dist, dist + 5), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}