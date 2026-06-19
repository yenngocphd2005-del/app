package com.nguyenthiyenngoc.authapp.service.impl;

import com.nguyenthiyenngoc.authapp.entity.OrderItem;
import com.nguyenthiyenngoc.authapp.repository.OrderItemRepository;
import com.nguyenthiyenngoc.authapp.service.OrderItemService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class OrderItemServiceImpl implements OrderItemService {

    private final OrderItemRepository orderItemRepository;

    public OrderItemServiceImpl(OrderItemRepository orderItemRepository) {
        this.orderItemRepository = orderItemRepository;
    }

    @Override
    public List<OrderItem> getAllOrderItems() {
        return orderItemRepository.findAll();
    }

    @Override
    public OrderItem getOrderItemById(UUID id) {
        return orderItemRepository.findById(id).orElse(null);
    }

    @Override
    public OrderItem createOrderItem(OrderItem orderItem) {
        return orderItemRepository.save(orderItem);
    }

    @Override
    public OrderItem updateOrderItem(UUID id, OrderItem orderItem) {

        OrderItem existing =
                orderItemRepository.findById(id).orElse(null);

        if (existing == null) {
            return null;
        }

        existing.setProduct(orderItem.getProduct());
        existing.setOrder(orderItem.getOrder());
        existing.setPrice(orderItem.getPrice());
        existing.setQuantity(orderItem.getQuantity());

        return orderItemRepository.save(existing);
    }

    @Override
    public void deleteOrderItem(UUID id) {
        orderItemRepository.deleteById(id);
    }
}
