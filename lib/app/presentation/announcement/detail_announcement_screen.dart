import 'package:flutter/material.dart';

class DetailAnnouncementScreen extends StatelessWidget {
  final Map<String, dynamic> announcement;

  const DetailAnnouncementScreen({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final itemColor = announcement['color'] as Color;

    return Scaffold(
      backgroundColor: color.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [itemColor.withOpacity(0.8), itemColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Icon(
                    announcement['icon'] as IconData,
                    size: 80,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: itemColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      announcement['date'] as String,
                      style: TextStyle(
                        color: itemColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    announcement['title'] as String,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: color.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Divider(color: color.outlineVariant.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  Text(
                    announcement['desc'] as String,
                    style: textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: color.onSurface.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Dummy Content
                  Text(
                    "Informasi Tambahan",
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                    style: textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      color: color.outline,
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pop(context),
        label: const Text("Tandai Sudah Dibaca"),
        icon: const Icon(Icons.mark_email_read_rounded),
        backgroundColor: itemColor,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
