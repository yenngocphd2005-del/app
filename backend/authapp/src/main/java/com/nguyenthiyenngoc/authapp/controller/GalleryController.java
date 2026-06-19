package com.nguyenthiyenngoc.authapp.controller;

import com.nguyenthiyenngoc.authapp.entity.Gallery;
import com.nguyenthiyenngoc.authapp.service.GalleryService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/galleries")
@CrossOrigin(origins = "*")
public class GalleryController {

    private final GalleryService galleryService;

    public GalleryController(GalleryService galleryService) {
        this.galleryService = galleryService;
    }

    @GetMapping
    public List<Gallery> getAllGalleries() {
        return galleryService.getAllGalleries();
    }

    @GetMapping("/{id}")
    public Gallery getGalleryById(@PathVariable UUID id) {
        return galleryService.getGalleryById(id);
    }

    @PostMapping
    public Gallery createGallery(@RequestBody Gallery gallery) {
        return galleryService.createGallery(gallery);
    }

    @PutMapping("/{id}")
    public Gallery updateGallery(
            @PathVariable UUID id,
            @RequestBody Gallery gallery) {

        return galleryService.updateGallery(id, gallery);
    }

    @DeleteMapping("/{id}")
    public void deleteGallery(@PathVariable UUID id) {
        galleryService.deleteGallery(id);
    }
}
