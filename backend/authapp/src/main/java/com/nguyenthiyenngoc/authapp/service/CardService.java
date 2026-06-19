package com.nguyenthiyenngoc.authapp.service;

import com.nguyenthiyenngoc.authapp.entity.Card;

import java.util.List;
import java.util.UUID;

public interface CardService {
    Card createCard(Card card);
    Card getCardById(UUID id);
    List<Card> getAllCards();
    Card updateCard(UUID id, Card card);
    void deleteCard(UUID id);
}
