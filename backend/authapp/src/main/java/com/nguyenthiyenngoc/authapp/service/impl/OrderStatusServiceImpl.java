package com.nguyenthiyenngoc.authapp.service.impl;

import com.nguyenthiyenngoc.authapp.entity.OrderStatus;
import com.nguyenthiyenngoc.authapp.repository.OrderStatusRepository;
import com.nguyenthiyenngoc.authapp.service.OrderStatusService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class OrderStatusServiceImpl implements OrderStatusService {

    private final OrderStatusRepository orderStatusRepository;

    public OrderStatusServiceImpl(OrderStatusRepository orderStatusRepository) {
        this.orderStatusRepository = orderStatusRepository;
    }

    @Override
    public List<OrderStatus> getAllOrderStatuses() {
        return orderStatusRepository.findAll();
    }

    @Override
    public OrderStatus getOrderStatusById(UUID id) {
        return orderStatusRepository.findById(id).orElse(null);
    }

    @Override
    public OrderStatus createOrderStatus(OrderStatus orderStatus) {
        return orderStatusRepository.save(orderStatus);
    }

    @Override
    public OrderStatus updateOrderStatus(UUID id, OrderStatus orderStatus) {

        OrderStatus existing =
                orderStatusRepository.findById(id).orElse(null);

        if (existing == null) {
            return null;
        }

        existing.setStatusName(orderStatus.getStatusName());
        existing.setColor(orderStatus.getColor());
        existing.setPrivacy(orderStatus.getPrivacy());
        existing.setCreatedBy(orderStatus.getCreatedBy());
        existing.setUpdatedBy(orderStatus.getUpdatedBy());

        return orderStatusRepository.save(existing);
    }

    @Override
    public void deleteOrderStatus(UUID id) {
        orderStatusRepository.deleteById(id);
    }
}