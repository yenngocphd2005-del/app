package com.nguyenthiyenngoc.authapp.controller;

import com.nguyenthiyenngoc.authapp.entity.Sell;
import com.nguyenthiyenngoc.authapp.service.SellService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/sells")
@CrossOrigin(origins = "*")
public class SellController {

    private final SellService sellService;

    public SellController(SellService sellService) {
        this.sellService = sellService;
    }

    @GetMapping
    public List<Sell> getAllSells() {
        return sellService.getAllSells();
    }

    @GetMapping("/{id}")
    public Sell getSellById(@PathVariable UUID id) {
        return sellService.getSellById(id);
    }

    @PostMapping
    public Sell createSell(@RequestBody Sell sell) {
        return sellService.createSell(sell);
    }

    @PutMapping("/{id}")
    public Sell updateSell(
            @PathVariable UUID id,
            @RequestBody Sell sell) {
        return sellService.updateSell(id, sell);
    }

    @DeleteMapping("/{id}")
    public void deleteSell(@PathVariable UUID id) {
        sellService.deleteSell(id);
    }
}
