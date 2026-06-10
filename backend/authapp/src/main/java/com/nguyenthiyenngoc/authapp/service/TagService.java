package com.nguyenthiyenngoc.authapp.service;

import com.nguyenthiyenngoc.authapp.entity.Tag;

import java.util.List;
import java.util.UUID;

public interface TagService {
    Tag createTag(Tag tag);
    Tag getTagById(UUID id);
    Tag getTagByName(String tagName);
    List<Tag> getAllTags();
    void deleteTag(UUID id);
}
