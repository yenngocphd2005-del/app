package com.nguyenthiyenngoc.authapp.service;

import com.nguyenthiyenngoc.authapp.entity.Country;

import java.util.List;

public interface CountryService {

    List<Country> getAllCountries();

    Country getCountryById(Integer id);

    Country createCountry(Country country);

    Country updateCountry(Integer id, Country country);

    void deleteCountry(Integer id);
}