package com.nguyenthiyenngoc.authapp.controller;

import com.nguyenthiyenngoc.authapp.entity.CardItem;
import com.nguyenthiyenngoc.authapp.service.CardItemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/card-items")
@CrossOrigin(origins = "*")
public class CardItemController {

    private final CardItemService cardItemService;

    @Autowired
    public CardItemController(CardItemService cardItemService) {
        this.cardItemService = cardItemService;
    }

    @GetMapping
    public ResponseEntity<List<CardItem>> getAllCardItems() {
        return ResponseEntity.ok(cardItemService.getAllCardItems());
    }

    @GetMapping("/{id}")
    public ResponseEntity<CardItem> getCardItemById(@PathVariable UUID id) {
        return ResponseEntity.ok(cardItemService.getCardItemById(id));
    }

    @PostMapping
    public ResponseEntity<CardItem> createCardItem(@RequestBody CardItem cardItem) {
        return ResponseEntity.ok(cardItemService.createCardItem(cardItem));
    }

    @PutMapping("/{id}")
    public ResponseEntity<CardItem> updateCardItem(
            @PathVariable UUID id,
            @RequestBody CardItem cardItem) {
        return ResponseEntity.ok(cardItemService.updateCardItem(id, cardItem));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteCardItem(@PathVariable UUID id) {
        cardItemService.deleteCardItem(id);
        return ResponseEntity.noContent().build();
    }
}
