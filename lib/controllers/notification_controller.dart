import 'package:get/get.dart';
import 'package:anymex/controllers/service_handler/service_handler.dart';

class NotificationController extends GetxController {
  final serviceHandler = Get.find<ServiceHandler>();

  RxList<dynamic> notifications = RxList([]);
  RxBool isLoading = RxBool(false);
  RxBool hasUnread = RxBool(false);
  RxInt unreadCount = RxInt(0);

  @override
  void onInit() {
    super.onInit();
    // Listen to login state changes
    ever(serviceHandler.isLoggedIn, (_) {
      if (serviceHandler.isLoggedIn.value) {
        fetchNotifications();
      } else {
        notifications.clear();
        unreadCount.value = 0;
        hasUnread.value = false;
      }
    });

    // Listen to service type changes
    ever(serviceHandler.serviceType, (_) {
      if (serviceHandler.isLoggedIn.value) {
        fetchNotifications(refresh: true);
      }
    });
  }

  Future<void> fetchNotifications({bool refresh = false}) async {
    if (!serviceHandler.isLoggedIn.value) return;

    if (refresh) {
      notifications.clear();
    }

    isLoading.value = true;

    try {
      // TODO: Implement service-specific notification fetching
      // Example:
      // if (serviceHandler.serviceType.value == ServicesType.anilist) {
      //   final newNotifications = await serviceHandler.anilistService.getNotifications();
      //   notifications.addAll(newNotifications);
      //   _updateUnreadCount();
      // }
    } catch (e) {
      debugPrint('Error fetching notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _updateUnreadCount() {
    // Count unread notifications
    unreadCount.value = notifications.length; // Adjust based on unread status
    hasUnread.value = unreadCount.value > 0;
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      // TODO: Call API to mark notification as read
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }

  void deleteNotification(String notificationId) {
    notifications.removeWhere((n) => n.id == notificationId);
    _updateUnreadCount();
  }
}
