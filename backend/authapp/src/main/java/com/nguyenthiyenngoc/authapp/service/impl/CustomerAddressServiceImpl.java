package com.nguyenthiyenngoc.authapp.service.impl;

import com.nguyenthiyenngoc.authapp.entity.CustomerAddress;
import com.nguyenthiyenngoc.authapp.repository.CustomerAddressRepository;
import com.nguyenthiyenngoc.authapp.service.CustomerAddressService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class CustomerAddressServiceImpl implements CustomerAddressService {

    private final CustomerAddressRepository customerAddressRepository;

    public CustomerAddressServiceImpl(CustomerAddressRepository customerAddressRepository) {
        this.customerAddressRepository = customerAddressRepository;
    }

    @Override
    public List<CustomerAddress> getAll() {
        return customerAddressRepository.findAll();
    }

    @Override
    public CustomerAddress getById(UUID id) {
        return customerAddressRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("CustomerAddress not found with id: " + id));
    }

    @Override
    public CustomerAddress create(CustomerAddress customerAddress) {
        return customerAddressRepository.save(customerAddress);
    }

    @Override
    public CustomerAddress update(UUID id, CustomerAddress customerAddress) {
        CustomerAddress existingAddress = customerAddressRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("CustomerAddress not found with id: " + id));

        existingAddress.setCustomer(customerAddress.getCustomer());
        existingAddress.setAddressLine1(customerAddress.getAddressLine1());
        existingAddress.setAddressLine2(customerAddress.getAddressLine2());
        existingAddress.setPhoneNumber(customerAddress.getPhoneNumber());
        existingAddress.setDialCode(customerAddress.getDialCode());
        existingAddress.setCountry(customerAddress.getCountry());
        existingAddress.setPostalCode(customerAddress.getPostalCode());
        existingAddress.setCity(customerAddress.getCity());

        return customerAddressRepository.save(existingAddress);
    }

    @Override
    public void delete(UUID id) {
        CustomerAddress existingAddress = customerAddressRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("CustomerAddress not found with id: " + id));
        customerAddressRepository.delete(existingAddress);
    }
}
