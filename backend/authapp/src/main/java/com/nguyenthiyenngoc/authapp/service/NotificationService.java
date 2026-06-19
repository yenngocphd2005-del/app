package com.nguyenthiyenngoc.authapp.service;

import com.nguyenthiyenngoc.authapp.entity.Notification;

import java.util.List;
import java.util.UUID;

public interface NotificationService {

    List<Notification> getAllNotifications();

    Notification getNotificationById(UUID id);

    Notification createNotification(Notification notification);

    Notification updateNotification(UUID id, Notification notification);

    void deleteNotification(UUID id);
}
