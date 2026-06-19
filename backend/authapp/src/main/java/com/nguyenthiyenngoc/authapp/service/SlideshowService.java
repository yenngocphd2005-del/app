package com.nguyenthiyenngoc.authapp.service;

import com.nguyenthiyenngoc.authapp.entity.Slideshow;

import java.util.List;
import java.util.UUID;

public interface SlideshowService {

    List<Slideshow> getAllSlideshows();

    Slideshow getSlideshowById(UUID id);

    Slideshow createSlideshow(Slideshow slideshow);

    Slideshow updateSlideshow(UUID id, Slideshow slideshow);

    void deleteSlideshow(UUID id);
}
