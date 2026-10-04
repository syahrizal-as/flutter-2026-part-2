import 'package:absensi_2026/core/helper/global_helper.dart';
import 'package:absensi_2026/core/widget/app_widget.dart';
import 'package:absensi_2026/app/presentation/map/map_notifier.dart';
import 'package:absensi_2026/core/widget/loading_app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MapScreen extends AppWidget<MapNotifier, void, void> {
  @override
  AppBar? appBarBuild(BuildContext context) {
    return AppBar(
      title: const Text('Buat Kehadiran'),
      centerTitle: true,
      elevation: 0,
    );
  }

  @override
  void checkVariableAfterUi(BuildContext context) {
    if (notifier.isSuccess) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget bodyBuild(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Stack(
      children: [
        /// MAP
        Positioned.fill(
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
                  icon: Icon(
                    Icons.double_arrow,
                    size: 48,
                  ),
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

        /// FOOTER CARD
        Positioned(left: 0, right: 0, bottom: 0, child: _footerLayout(context)),

        /// STATUS INDICATOR (Top Float)
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: _statusHeader(context),
        ),

        /// RECENTER BUTTON
        Positioned(
          bottom: 230,
          right: 16,
          child: FloatingActionButton(
            onPressed: () => notifier.recenterMap(),
            backgroundColor: color.primary,
            foregroundColor: color.onPrimary,
            mini: true,
            child: const Icon(Icons.my_location_rounded),
          ),
        ),
      ],
    );
  }

  Widget _statusHeader(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final inRadius = notifier.isEnableSubmitButton;
    final distance = notifier.distanceFromOffice;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            inRadius ? Icons.check_circle_rounded : Icons.info_rounded,
            color: inRadius ? Colors.green : color.error,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  notifier.currentLocation == null
                      ? "Menunggu GPS..."
                      : notifier.schedule == null
                          ? "Mengambil data jadwal..."
                          : inRadius
                              ? "Anda berada di dalam radius"
                              : "Anda berada di luar radius kantor",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: inRadius ? Colors.green.shade800 : color.error,
                  ),
                ),
                Text(
                  notifier.currentLocation == null
                      ? "Mencari lokasi Anda..."
                      : notifier.schedule == null
                          ? "Tunggu sebentar..."
                          : inRadius
                              ? "Silakan kirim kehadiran Anda"
                              : "Jarak Anda: ${distance.toStringAsFixed(0)} meter lagi",
                  style: TextStyle(
                    fontSize: 11,
                    color: inRadius ? Colors.green : color.error.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _footerLayout(BuildContext context) {
    final color = GlobalHelper.getColorSchema(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// DRAG INDICATOR
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          /// INFO ROW
          Row(
            children: [
              _infoTile(
                context,
                icon: Icons.location_city,
                title: notifier.schedule?.office.name ?? "-",
                badge: (notifier.schedule?.isWfa == 1) ? "WFA" : "WFO",
              ),
              const SizedBox(width: 12),
              _infoTile(
                context,
                icon: Icons.access_time,
                title: notifier.schedule?.shift.name ?? "-",
                subtitle:
                    "${notifier.schedule?.shift.startTime} - ${notifier.schedule?.shift.endTime}",
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// BUTTON
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed:
                  notifier.isEnableSubmitButton ? () => notifier.send() : null,
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                "Kirim Kehadiran",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    String? badge,
  }) {
    final color = GlobalHelper.getColorSchema(context);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color.onPrimaryContainer),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: TextStyle(
                  color: color.onPrimaryContainer.withOpacity(0.8),
                ),
              ),
            if (badge != null)
              Container(
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: color.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: color.onPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
