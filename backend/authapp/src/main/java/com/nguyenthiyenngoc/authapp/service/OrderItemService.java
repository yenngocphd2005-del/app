package com.nguyenthiyenngoc.authapp.service;

import com.nguyenthiyenngoc.authapp.entity.OrderItem;

import java.util.List;
import java.util.UUID;

public interface OrderItemService {

    List<OrderItem> getAllOrderItems();

    OrderItem getOrderItemById(UUID id);

    OrderItem createOrderItem(OrderItem orderItem);

    OrderItem updateOrderItem(UUID id, OrderItem orderItem);

    void deleteOrderItem(UUID id);
}
