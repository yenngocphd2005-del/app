package com.nguyenthiyenngoc.authapp.service;

import com.nguyenthiyenngoc.authapp.entity.Customer;

import java.util.List;
import java.util.UUID;

public interface CustomerService {

    List<Customer> getAll();

    Customer getById(UUID id);

    Customer create(Customer customer);

    Customer update(UUID id, Customer customer);

    void delete(UUID id);
}
