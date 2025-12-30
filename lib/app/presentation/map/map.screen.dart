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
  Widget bodyBuild(BuildContext context) {
    return Stack(
      children: [
        /// MAP
        Positioned.fill(
          child: OSMFlutter(
            controller: notifier.mapController,
            osmOption: OSMOption(
              zoomOption: ZoomOption(initZoom: 15.5, minZoomLevel: 10),
            ),
            mapIsLoading: LoadingAppWidget(),
          ),
        ),

        /// FOOTER CARD
        Positioned(left: 0, right: 0, bottom: 0, child: _footerLayout(context)),
      ],
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
                title: "Bekasi",
                badge: "WFA",
              ),
              const SizedBox(width: 12),
              _infoTile(
                context,
                icon: Icons.access_time,
                title: "Siang",
                subtitle: "09:00 - 17:00",
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// BUTTON
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: null, // aktifkan kalau lokasi valid
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
