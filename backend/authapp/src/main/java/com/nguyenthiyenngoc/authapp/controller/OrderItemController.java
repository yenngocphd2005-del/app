package com.nguyenthiyenngoc.authapp.controller;

import com.nguyenthiyenngoc.authapp.entity.OrderItem;
import com.nguyenthiyenngoc.authapp.service.OrderItemService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/order-items")
@CrossOrigin(origins = "*")
public class OrderItemController {

    private final OrderItemService orderItemService;

    public OrderItemController(OrderItemService orderItemService) {
        this.orderItemService = orderItemService;
    }

    @GetMapping
    public List<OrderItem> getAllOrderItems() {
        return orderItemService.getAllOrderItems();
    }

    @GetMapping("/{id}")
    public OrderItem getOrderItemById(@PathVariable UUID id) {
        return orderItemService.getOrderItemById(id);
    }

    @PostMapping
    public OrderItem createOrderItem(@RequestBody OrderItem orderItem) {
        return orderItemService.createOrderItem(orderItem);
    }

    @PutMapping("/{id}")
    public OrderItem updateOrderItem(
            @PathVariable UUID id,
            @RequestBody OrderItem orderItem) {

        return orderItemService.updateOrderItem(id, orderItem);
    }

    @DeleteMapping("/{id}")
    public void deleteOrderItem(@PathVariable UUID id) {
        orderItemService.deleteOrderItem(id);
    }
}
