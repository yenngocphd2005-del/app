package com.nguyenthiyenngoc.authapp.service.impl;

import com.nguyenthiyenngoc.authapp.entity.Sell;
import com.nguyenthiyenngoc.authapp.repository.SellRepository;
import com.nguyenthiyenngoc.authapp.service.SellService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class SellServiceImpl implements SellService {

    private final SellRepository sellRepository;

    public SellServiceImpl(SellRepository sellRepository) {
        this.sellRepository = sellRepository;
    }

    @Override
    public List<Sell> getAllSells() {
        return sellRepository.findAll();
    }

    @Override
    public Sell getSellById(UUID id) {
        return sellRepository.findById(id).orElse(null);
    }

    @Override
    public Sell createSell(Sell sell) {
        return sellRepository.save(sell);
    }

    @Override
    public Sell updateSell(UUID id, Sell sell) {
        Sell existing = sellRepository.findById(id).orElse(null);
        if (existing == null) {
            return null;
        }
        existing.setProduct(sell.getProduct());
        existing.setPrice(sell.getPrice());
        existing.setQuantity(sell.getQuantity());
        return sellRepository.save(existing);
    }

    @Override
    public void deleteSell(UUID id) {
        sellRepository.deleteById(id);
    }
}
