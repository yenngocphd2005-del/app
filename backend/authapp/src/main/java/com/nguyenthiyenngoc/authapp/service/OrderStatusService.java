package com.nguyenthiyenngoc.authapp.service;

import com.nguyenthiyenngoc.authapp.entity.OrderStatus;

import java.util.List;
import java.util.UUID;

public interface OrderStatusService {

    List<OrderStatus> getAllOrderStatuses();

    OrderStatus getOrderStatusById(UUID id);

    OrderStatus createOrderStatus(OrderStatus orderStatus);

    OrderStatus updateOrderStatus(UUID id, OrderStatus orderStatus);

    void deleteOrderStatus(UUID id);
}