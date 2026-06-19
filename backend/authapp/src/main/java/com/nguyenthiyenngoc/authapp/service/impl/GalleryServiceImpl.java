package com.nguyenthiyenngoc.authapp.service.impl;

import com.nguyenthiyenngoc.authapp.entity.Gallery;
import com.nguyenthiyenngoc.authapp.repository.GalleryRepository;
import com.nguyenthiyenngoc.authapp.service.GalleryService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class GalleryServiceImpl implements GalleryService {

    private final GalleryRepository galleryRepository;

    public GalleryServiceImpl(GalleryRepository galleryRepository) {
        this.galleryRepository = galleryRepository;
    }

    @Override
    public List<Gallery> getAllGalleries() {
        return galleryRepository.findAll();
    }

    @Override
    public Gallery getGalleryById(UUID id) {
        return galleryRepository.findById(id).orElse(null);
    }

    @Override
    public Gallery createGallery(Gallery gallery) {
        return galleryRepository.save(gallery);
    }

    @Override
    public Gallery updateGallery(UUID id, Gallery gallery) {

        Gallery existing =
                galleryRepository.findById(id).orElse(null);

        if (existing == null) {
            return null;
        }

        existing.setProduct(gallery.getProduct());
        existing.setImage(gallery.getImage());
        existing.setPlaceholder(gallery.getPlaceholder());
        existing.setIsThumbnail(gallery.getIsThumbnail());

        return galleryRepository.save(existing);
    }

    @Override
    public void deleteGallery(UUID id) {
        galleryRepository.deleteById(id);
    }
}
