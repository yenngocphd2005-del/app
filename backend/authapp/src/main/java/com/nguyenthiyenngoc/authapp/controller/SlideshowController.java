package com.nguyenthiyenngoc.authapp.controller;

import com.nguyenthiyenngoc.authapp.entity.Slideshow;
import com.nguyenthiyenngoc.authapp.service.SlideshowService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/slideshows")
@CrossOrigin(origins = "*")
public class SlideshowController {

    private final SlideshowService slideshowService;

    public SlideshowController(SlideshowService slideshowService) {
        this.slideshowService = slideshowService;
    }

    @GetMapping
    public List<Slideshow> getAllSlideshows() {
        return slideshowService.getAllSlideshows();
    }

    @GetMapping("/{id}")
    public Slideshow getSlideshowById(@PathVariable UUID id) {
        return slideshowService.getSlideshowById(id);
    }

    @PostMapping
    public Slideshow createSlideshow(@RequestBody Slideshow slideshow) {
        return slideshowService.createSlideshow(slideshow);
    }

    @PutMapping("/{id}")
    public Slideshow updateSlideshow(
            @PathVariable UUID id,
            @RequestBody Slideshow slideshow) {
        return slideshowService.updateSlideshow(id, slideshow);
    }

    @DeleteMapping("/{id}")
    public void deleteSlideshow(@PathVariable UUID id) {
        slideshowService.deleteSlideshow(id);
    }
}
