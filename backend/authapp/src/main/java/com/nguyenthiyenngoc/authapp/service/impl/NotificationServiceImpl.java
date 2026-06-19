package com.nguyenthiyenngoc.authapp.service.impl;

import com.nguyenthiyenngoc.authapp.entity.Notification;
import com.nguyenthiyenngoc.authapp.repository.NotificationRepository;
import com.nguyenthiyenngoc.authapp.service.NotificationService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class NotificationServiceImpl implements NotificationService {

    private final NotificationRepository notificationRepository;

    public NotificationServiceImpl(NotificationRepository notificationRepository) {
        this.notificationRepository = notificationRepository;
    }

    @Override
    public List<Notification> getAllNotifications() {
        return notificationRepository.findAll();
    }

    @Override
    public Notification getNotificationById(UUID id) {
        return notificationRepository.findById(id).orElse(null);
    }

    @Override
    public Notification createNotification(Notification notification) {
        return notificationRepository.save(notification);
    }

    @Override
    public Notification updateNotification(UUID id, Notification notification) {
        Notification existing = notificationRepository.findById(id).orElse(null);
        if (existing == null) {
            return null;
        }
        existing.setAccount(notification.getAccount());
        existing.setTitle(notification.getTitle());
        existing.setContent(notification.getContent());
        existing.setSeen(notification.getSeen());
        existing.setReceiveTime(notification.getReceiveTime());
        existing.setNotificationExpiryDate(notification.getNotificationExpiryDate());
        return notificationRepository.save(existing);
    }

    @Override
    public void deleteNotification(UUID id) {
        notificationRepository.deleteById(id);
    }
}
