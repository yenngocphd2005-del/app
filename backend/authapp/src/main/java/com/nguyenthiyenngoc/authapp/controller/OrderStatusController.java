package com.nguyenthiyenngoc.authapp.controller;

import com.nguyenthiyenngoc.authapp.entity.OrderStatus;
import com.nguyenthiyenngoc.authapp.service.OrderStatusService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/order-statuses")
@CrossOrigin(origins = "*")
public class OrderStatusController {

    private final OrderStatusService orderStatusService;

    public OrderStatusController(OrderStatusService orderStatusService) {
        this.orderStatusService = orderStatusService;
    }

    @GetMapping
    public List<OrderStatus> getAllOrderStatuses() {
        return orderStatusService.getAllOrderStatuses();
    }

    @GetMapping("/{id}")
    public OrderStatus getOrderStatusById(@PathVariable UUID id) {
        return orderStatusService.getOrderStatusById(id);
    }

    @PostMapping
    public OrderStatus createOrderStatus(
            @RequestBody OrderStatus orderStatus) {
        return orderStatusService.createOrderStatus(orderStatus);
    }

    @PutMapping("/{id}")
    public OrderStatus updateOrderStatus(
            @PathVariable UUID id,
            @RequestBody OrderStatus orderStatus) {

        return orderStatusService.updateOrderStatus(id, orderStatus);
    }

    @DeleteMapping("/{id}")
    public void deleteOrderStatus(@PathVariable UUID id) {
        orderStatusService.deleteOrderStatus(id);
    }
}