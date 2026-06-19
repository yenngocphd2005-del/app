package com.nguyenthiyenngoc.authapp.service;

import com.nguyenthiyenngoc.authapp.entity.CardItem;

import java.util.List;
import java.util.UUID;

public interface CardItemService {
    CardItem createCardItem(CardItem cardItem);
    CardItem getCardItemById(UUID id);
    List<CardItem> getAllCardItems();
    CardItem updateCardItem(UUID id, CardItem cardItem);
    void deleteCardItem(UUID id);
}
