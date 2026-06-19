package com.nguyenthiyenngoc.authapp.service;

import com.nguyenthiyenngoc.authapp.entity.Order;

import java.util.List;

public interface OrderService {

    List<Order> getAllOrders();

    Order getOrderById(String id);

    Order createOrder(Order order);

    Order updateOrder(String id, Order order);

    void deleteOrder(String id);
}
