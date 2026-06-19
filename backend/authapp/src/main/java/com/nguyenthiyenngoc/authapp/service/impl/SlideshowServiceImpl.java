package com.nguyenthiyenngoc.authapp.service.impl;

import com.nguyenthiyenngoc.authapp.entity.Slideshow;
import com.nguyenthiyenngoc.authapp.repository.SlideshowRepository;
import com.nguyenthiyenngoc.authapp.service.SlideshowService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class SlideshowServiceImpl implements SlideshowService {

    private final SlideshowRepository slideshowRepository;

    public SlideshowServiceImpl(SlideshowRepository slideshowRepository) {
        this.slideshowRepository = slideshowRepository;
    }

    @Override
    public List<Slideshow> getAllSlideshows() {
        return slideshowRepository.findAll();
    }

    @Override
    public Slideshow getSlideshowById(UUID id) {
        return slideshowRepository.findById(id).orElse(null);
    }

    @Override
    public Slideshow createSlideshow(Slideshow slideshow) {
        return slideshowRepository.save(slideshow);
    }

    @Override
    public Slideshow updateSlideshow(UUID id, Slideshow slideshow) {
        Slideshow existing = slideshowRepository.findById(id).orElse(null);
        if (existing == null) {
            return null;
        }
        existing.setTitle(slideshow.getTitle());
        existing.setDestinationUrl(slideshow.getDestinationUrl());
        existing.setImage(slideshow.getImage());
        existing.setPlaceholder(slideshow.getPlaceholder());
        existing.setDescription(slideshow.getDescription());
        existing.setBtnLabel(slideshow.getBtnLabel());
        existing.setDisplayOrder(slideshow.getDisplayOrder());
        existing.setPublished(slideshow.getPublished());
        existing.setClicks(slideshow.getClicks());
        existing.setStyles(slideshow.getStyles());
        existing.setUpdatedBy(slideshow.getUpdatedBy());
        return slideshowRepository.save(existing);
    }

    @Override
    public void deleteSlideshow(UUID id) {
        slideshowRepository.deleteById(id);
    }
}
