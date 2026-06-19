package com.nguyenthiyenngoc.authapp.service.impl;

import com.nguyenthiyenngoc.authapp.entity.Country;
import com.nguyenthiyenngoc.authapp.repository.CountryRepository;
import com.nguyenthiyenngoc.authapp.service.CountryService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CountryServiceImpl implements CountryService {

    private final CountryRepository countryRepository;

    public CountryServiceImpl(CountryRepository countryRepository) {
        this.countryRepository = countryRepository;
    }

    @Override
    public List<Country> getAllCountries() {
        return countryRepository.findAll();
    }

    @Override
    public Country getCountryById(Integer id) {
        return countryRepository.findById(id).orElse(null);
    }

    @Override
    public Country createCountry(Country country) {
        return countryRepository.save(country);
    }

    @Override
    public Country updateCountry(Integer id, Country country) {
        Country existing = countryRepository.findById(id).orElse(null);

        if (existing == null) {
            return null;
        }

        existing.setIso(country.getIso());
        existing.setName(country.getName());
        existing.setUpperName(country.getUpperName());
        existing.setIso3(country.getIso3());
        existing.setNumCode(country.getNumCode());
        existing.setPhoneCode(country.getPhoneCode());

        return countryRepository.save(existing);
    }

    @Override
    public void deleteCountry(Integer id) {
        countryRepository.deleteById(id);
    }
}