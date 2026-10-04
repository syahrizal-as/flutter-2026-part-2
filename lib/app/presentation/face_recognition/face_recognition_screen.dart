import 'package:absensi_2026/app/presentation/face_recognition/face_recognition_notifier.dart';
import 'package:absensi_2026/app/presentation/upload_photo/upload_photo_screen.dart';
import 'package:absensi_2026/core/widget/loading_app_widget.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:absensi_2026/core/widget/app_widget.dart';
import 'package:flutter/material.dart';

class FaceRecognitionScreen
    extends AppWidget<FaceRecognitionNotifier, void, void> {
  @override
  void checkVariableAfterUi(BuildContext context) {
    if (notifier.isMissingPhoto) {
      _goToUpload(context);
    } else if (notifier.isSuccess) {
      Navigator.pop(context, true);
    }
  }

  void _goToUpload(BuildContext context) async {
    notifier.isMissingPhoto = false;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UploadPhotoScreen()),
    );
    await Future.delayed(const Duration(milliseconds: 500));
    notifier.init();
  }

  @override
  AppBar? appBarBuild(BuildContext context) {
    return AppBar(
      title: const Text('Validasi Wajah'),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget bodyBuild(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bool isMatched = notifier.percentMatch >= 70;
    final bool hasResult = notifier.percentMatch != 0.0;
    final bool isNoMatch = notifier.percentMatch < 0;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Header ──────────────────────────────────────────
            Text(
              'Verifikasi Wajah',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Pastikan wajah Anda terlihat jelas\nuntuk pencocokan data.',
              textAlign: TextAlign.center,
              style: TextStyle(color: color.outline, height: 1.5),
            ),

            const SizedBox(height: 28),

            // ── Photo Comparison Card ────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: color.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: color.outlineVariant.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildPhotoFrame(
                          context,
                          label: 'Referensi',
                          badge: Icons.verified_user_rounded,
                          badgeColor: color.primary,
                          image: notifier.refPhotoBytes != null
                              ? Image.memory(
                                  notifier.refPhotoBytes!,
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // VS divider
                      Column(
                        children: [
                          Container(
                            width: 1,
                            height: 60,
                            color: color.outlineVariant.withOpacity(0.3),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: color.primaryContainer.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'VS',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 11,
                                color: color.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 1,
                            height: 60,
                            color: color.outlineVariant.withOpacity(0.3),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildPhotoFrame(
                          context,
                          label: 'Hasil Scan',
                          badge: Icons.face_retouching_natural_rounded,
                          badgeColor: color.secondary,
                          image: notifier.currentImage,
                        ),
                      ),
                    ],
                  ),

                  // ── Match Result ───────────────────────────────
                  if (hasResult) ...[
                    const SizedBox(height: 20),
                    Divider(color: color.outlineVariant.withOpacity(0.3)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isNoMatch
                                ? color.errorContainer
                                : isMatched
                                    ? Colors.green.withOpacity(0.15)
                                    : Colors.orange.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isNoMatch
                                ? Icons.close_rounded
                                : isMatched
                                    ? Icons.check_circle_rounded
                                    : Icons.warning_rounded,
                            color: isNoMatch
                                ? color.error
                                : isMatched
                                    ? Colors.green
                                    : Colors.orange,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isNoMatch
                                    ? 'Wajah Tidak Cocok'
                                    : isMatched
                                        ? 'Wajah Terverifikasi'
                                        : 'Kemiripan Rendah',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isNoMatch
                                      ? color.error
                                      : isMatched
                                          ? Colors.green
                                          : Colors.orange,
                                ),
                              ),
                              if (!isNoMatch) ...[
                                const SizedBox(height: 4),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: notifier.percentMatch / 100,
                                    backgroundColor:
                                        color.outlineVariant.withOpacity(0.2),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      isMatched ? Colors.green : Colors.orange,
                                    ),
                                    minHeight: 6,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${notifier.percentMatch.toStringAsFixed(1)}% kemiripan',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: color.outline,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            const SizedBox(height: 24),

            // ── Map Section (Visible after Face Match or if already matched) ──
            if (hasResult && !isNoMatch) ...[
              _buildMapSection(context),
              const SizedBox(height: 24),
            ],

            // ── Unified Submit Button ──────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 56,
              child: notifier.percentMatch >= 70
                  ? FilledButton.icon(
                      onPressed: notifier.isEnableSubmitButton
                          ? () => notifier.submitAttendance()
                          : null,
                      icon: const Icon(Icons.send_rounded),
                      label: const Text(
                        'KIRIM KEHADIRAN',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: notifier.isEnableSubmitButton
                            ? color.primary
                            : color.outline.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    )
                  : FilledButton.icon(
                      onPressed: () => notifier.getCurrentPhoto(),
                      icon: const Icon(Icons.face_retouching_natural_rounded),
                      label: Text(
                        notifier.currentImage == null
                            ? 'MULAI SCAN WAJAH'
                            : 'SCAN ULANG',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final inRadius = notifier.isEnableSubmitButton;
    final distance = notifier.distanceFromOffice;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Map Status Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: (inRadius ? Colors.green : color.error).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: (inRadius ? Colors.green : color.error).withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                inRadius ? Icons.check_circle_rounded : Icons.info_rounded,
                color: inRadius ? Colors.green : color.error,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      inRadius
                          ? "Lokasi Terverifikasi"
                          : "Di Luar Radius Kantor",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: inRadius ? Colors.green.shade800 : color.error,
                      ),
                    ),
                    Text(
                      inRadius
                          ? "Anda berada di dalam zona absen"
                          : "Jarak Anda: ${distance.toStringAsFixed(0)}m lagi",
                      style: TextStyle(
                        fontSize: 11,
                        color: inRadius
                            ? Colors.green
                            : color.error.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Map Widget
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: color.outlineVariant.withOpacity(0.3)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: OSMFlutter(
              controller: notifier.mapController,
              osmOption: OSMOption(
                zoomOption: const ZoomOption(initZoom: 15.5, minZoomLevel: 10),
                userTrackingOption: const UserTrackingOption(
                  enableTracking: true,
                  unFollowUser: false,
                ),
                userLocationMarker: UserLocationMaker(
                  personMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.location_history_rounded,
                      color: Colors.red,
                      size: 48,
                    ),
                  ),
                  directionArrowMarker: const MarkerIcon(
                    icon: Icon(Icons.double_arrow, size: 48),
                  ),
                ),
              ),
              onMapIsReady: (isReady) {
                if (isReady) {
                  notifier.mapIsReady();
                }
              },
              mapIsLoading: LoadingAppWidget(),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => notifier.recenterMap(),
            icon: const Icon(Icons.my_location_rounded, size: 16),
            label: const Text("Pusatkan Lokasi", style: TextStyle(fontSize: 12)),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoFrame(
    BuildContext context, {
    required String label,
    required IconData badge,
    required Color badgeColor,
    Widget? image,
  }) {
    final color = Theme.of(context).colorScheme;
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: color.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: color.outlineVariant.withOpacity(0.4),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: image != null
                    ? SizedBox.expand(
                        child: FittedBox(fit: BoxFit.cover, child: image),
                      )
                    : Center(
                        child: Icon(
                          Icons.person_rounded,
                          size: 48,
                          color: color.outline.withOpacity(0.3),
                        ),
                      ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: Icon(badge, color: Colors.white, size: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color.onSurface,
          ),
        ),
      ],
    );
  }
}
