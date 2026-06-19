package com.nguyenthiyenngoc.authapp.service.impl;

import com.nguyenthiyenngoc.authapp.entity.CardItem;
import com.nguyenthiyenngoc.authapp.repository.CardItemRepository;
import com.nguyenthiyenngoc.authapp.service.CardItemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class CardItemServiceImpl implements CardItemService {

    private final CardItemRepository cardItemRepository;

    @Autowired
    public CardItemServiceImpl(CardItemRepository cardItemRepository) {
        this.cardItemRepository = cardItemRepository;
    }

    @Override
    public CardItem createCardItem(CardItem cardItem) {
        return cardItemRepository.save(cardItem);
    }

    @Override
    public CardItem getCardItemById(UUID id) {
        return cardItemRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("CardItem not found with ID: " + id));
    }

    @Override
    public List<CardItem> getAllCardItems() {
        return cardItemRepository.findAll();
    }

    @Override
    public CardItem updateCardItem(UUID id, CardItem cardItem) {
        CardItem existing = cardItemRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("CardItem not found with ID: " + id));

        existing.setCard(cardItem.getCard());
        existing.setProduct(cardItem.getProduct());
        existing.setQuantity(cardItem.getQuantity());

        return cardItemRepository.save(existing);
    }

    @Override
    public void deleteCardItem(UUID id) {
        cardItemRepository.deleteById(id);
    }
}
