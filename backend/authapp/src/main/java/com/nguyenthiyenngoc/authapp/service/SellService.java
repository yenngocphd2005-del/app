package com.nguyenthiyenngoc.authapp.service;

import com.nguyenthiyenngoc.authapp.entity.Sell;

import java.util.List;
import java.util.UUID;

public interface SellService {

    List<Sell> getAllSells();

    Sell getSellById(UUID id);

    Sell createSell(Sell sell);

    Sell updateSell(UUID id, Sell sell);

    void deleteSell(UUID id);
}
