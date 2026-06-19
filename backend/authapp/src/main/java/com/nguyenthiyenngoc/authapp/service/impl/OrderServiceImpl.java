package com.nguyenthiyenngoc.authapp.service.impl;

import com.nguyenthiyenngoc.authapp.entity.Order;
import com.nguyenthiyenngoc.authapp.repository.OrderRepository;
import com.nguyenthiyenngoc.authapp.service.OrderService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class OrderServiceImpl implements OrderService {

    private final OrderRepository orderRepository;

    public OrderServiceImpl(OrderRepository orderRepository) {
        this.orderRepository = orderRepository;
    }

    @Override
    public List<Order> getAllOrders() {
        return orderRepository.findAll();
    }

    @Override
    public Order getOrderById(String id) {
        return orderRepository.findById(id).orElse(null);
    }

    @Override
    public Order createOrder(Order order) {
        return orderRepository.save(order);
    }

    @Override
    public Order updateOrder(String id, Order order) {

        Order existing =
                orderRepository.findById(id).orElse(null);

        if (existing == null) {
            return null;
        }

        existing.setCoupon(order.getCoupon());
        existing.setCustomer(order.getCustomer());
        existing.setOrderStatus(order.getOrderStatus());
        existing.setOrderApprovedAt(order.getOrderApprovedAt());
        existing.setOrderDeliveredCarrierDate(order.getOrderDeliveredCarrierDate());
        existing.setOrderDeliveredCustomerDate(order.getOrderDeliveredCustomerDate());
        existing.setUpdatedBy(order.getUpdatedBy());

        return orderRepository.save(existing);
    }

    @Override
    public void deleteOrder(String id) {
        orderRepository.deleteById(id);
    }
}
