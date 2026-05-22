import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:anymex/controllers/service_handler/service_handler.dart';
import 'package:anymex/widgets/custom_widgets/custom_text.dart';
import 'package:anymex/utils/theme_extensions.dart';
import 'package:anymex/utils/function.dart';
import 'package:iconsax/iconsax.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final serviceHandler = Get.find<ServiceHandler>();
  List<dynamic> notifications = [];
  bool isLoading = false;
  int currentPage = 1;
  bool hasNextPage = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    if (!serviceHandler.isLoggedIn.value) {
      return;
    }
    
    setState(() => isLoading = true);
    try {
      // TODO: Implement based on service type
      // Example for AniList:
      // notifications = await anilistService.getNotifications(page: currentPage);
    } catch (e) {
      debugPrint('Error loading notifications: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const AnymexText(
          text: 'Notifications',
          variant: TextVariant.semiBold,
          size: 18,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: notifications.isEmpty && !isLoading
          ? _buildEmptyState(theme)
          : _buildNotificationsList(theme),
    );
  }

  Widget _buildEmptyState(ColorScheme theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.notification,
            size: 64,
            color: theme.onSurface.opaque(0.2),
          ),
          const SizedBox(height: 16),
          AnymexText(
            text: 'No Notifications',
            size: 16,
            variant: TextVariant.semiBold,
            color: theme.onSurface.opaque(0.6),
          ),
          const SizedBox(height: 8),
          AnymexText(
            text: 'You\'re all caught up!',
            size: 13,
            color: theme.onSurface.opaque(0.4),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(ColorScheme theme) {
    return RefreshIndicator(
      onRefresh: () async {
        currentPage = 1;
        notifications.clear();
        await _loadNotifications();
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        itemCount: notifications.length + (isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == notifications.length) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation(theme.colorScheme.primary),
                  ),
                ),
              ),
            );
          }
          return _buildNotificationItem(notifications[index], theme);
        },
      ),
    );
  }

  Widget _buildNotificationItem(dynamic notification, ColorScheme theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // TODO: Navigate to notification detail or related content
          },
          child: Container(
            decoration: BoxDecoration(
              color: theme.surfaceContainer.opaque(0.25),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.outline.opaque(0.08),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.primaryContainer.opaque(0.3),
                  ),
                  child: Icon(
                    Iconsax.notification,
                    color: theme.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnymexText(
                        text: 'Notification Title',
                        variant: TextVariant.semiBold,
                        size: 13,
                      ),
                      const SizedBox(height: 3),
                      AnymexText(
                        text: 'Notification description',
                        size: 12,
                        color: theme.onSurface.opaque(0.6),
                      ),
                      const SizedBox(height: 4),
                      AnymexText(
                        text: '2 hours ago',
                        size: 11,
                        color: theme.onSurface.opaque(0.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
