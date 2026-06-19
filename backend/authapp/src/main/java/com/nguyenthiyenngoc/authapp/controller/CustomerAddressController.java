package com.nguyenthiyenngoc.authapp.controller;

import com.nguyenthiyenngoc.authapp.entity.CustomerAddress;
import com.nguyenthiyenngoc.authapp.service.CustomerAddressService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/customer-addresses")
@CrossOrigin(origins = "*")
public class CustomerAddressController {

    private final CustomerAddressService customerAddressService;

    public CustomerAddressController(CustomerAddressService customerAddressService) {
        this.customerAddressService = customerAddressService;
    }

    @GetMapping
    public List<CustomerAddress> getAllCustomerAddresses() {
        return customerAddressService.getAllCustomerAddresses();
    }

    @GetMapping("/{id}")
    public CustomerAddress getCustomerAddressById(@PathVariable UUID id) {
        return customerAddressService.getCustomerAddressById(id);
    }

    @PostMapping
    public CustomerAddress createCustomerAddress(@RequestBody CustomerAddress customerAddress) {
        return customerAddressService.createCustomerAddress(customerAddress);
    }

    @PutMapping("/{id}")
    public CustomerAddress updateCustomerAddress(
            @PathVariable UUID id,
            @RequestBody CustomerAddress customerAddress) {

        return customerAddressService.updateCustomerAddress(id, customerAddress);
    }

    @DeleteMapping("/{id}")
    public void deleteCustomerAddress(@PathVariable UUID id) {
        customerAddressService.deleteCustomerAddress(id);
    }
}
