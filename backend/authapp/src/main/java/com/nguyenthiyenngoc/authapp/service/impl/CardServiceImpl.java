package com.nguyenthiyenngoc.authapp.service.impl;

import com.nguyenthiyenngoc.authapp.entity.Card;
import com.nguyenthiyenngoc.authapp.repository.CardRepository;
import com.nguyenthiyenngoc.authapp.service.CardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class CardServiceImpl implements CardService {

    private final CardRepository cardRepository;

    @Autowired
    public CardServiceImpl(CardRepository cardRepository) {
        this.cardRepository = cardRepository;
    }

    @Override
    public Card createCard(Card card) {
        return cardRepository.save(card);
    }

    @Override
    public Card getCardById(UUID id) {
        return cardRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Card not found with ID: " + id));
    }

    @Override
    public List<Card> getAllCards() {
        return cardRepository.findAll();
    }

    @Override
    public Card updateCard(UUID id, Card card) {
        Card existing = cardRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Card not found with ID: " + id));

        existing.setCustomer(card.getCustomer());

        return cardRepository.save(existing);
    }

    @Override
    public void deleteCard(UUID id) {
        cardRepository.deleteById(id);
    }
}
