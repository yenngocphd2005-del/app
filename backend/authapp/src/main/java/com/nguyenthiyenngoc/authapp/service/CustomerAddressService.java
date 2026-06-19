package com.nguyenthiyenngoc.authapp.service;

import com.nguyenthiyenngoc.authapp.entity.CustomerAddress;

import java.util.List;
import java.util.UUID;

public interface CustomerAddressService {

    List<CustomerAddress> getAll();

    CustomerAddress getById(UUID id);

    CustomerAddress create(CustomerAddress customerAddress);

    CustomerAddress update(UUID id, CustomerAddress customerAddress);

    void delete(UUID id);
}
