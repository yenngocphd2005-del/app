package com.nguyenthiyenngoc.authapp.service;

import com.nguyenthiyenngoc.authapp.entity.Gallery;

import java.util.List;
import java.util.UUID;

public interface GalleryService {

    List<Gallery> getAllGalleries();

    Gallery getGalleryById(UUID id);

    Gallery createGallery(Gallery gallery);

    Gallery updateGallery(UUID id, Gallery gallery);

    void deleteGallery(UUID id);
}
