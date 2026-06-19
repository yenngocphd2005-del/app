package com.nguyenthiyenngoc.authapp.controller;

import com.nguyenthiyenngoc.authapp.entity.Country;
import com.nguyenthiyenngoc.authapp.service.CountryService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/countries")
@CrossOrigin(origins = "*")
public class CountryController {

    private final CountryService countryService;

    public CountryController(CountryService countryService) {
        this.countryService = countryService;
    }

    @GetMapping
    public List<Country> getAllCountries() {
        return countryService.getAllCountries();
    }

    @GetMapping("/{id}")
    public Country getCountryById(@PathVariable Integer id) {
        return countryService.getCountryById(id);
    }

    @PostMapping
    public Country createCountry(@RequestBody Country country) {
        return countryService.createCountry(country);
    }

    @PutMapping("/{id}")
    public Country updateCountry(
            @PathVariable Integer id,
            @RequestBody Country country) {

        return countryService.updateCountry(id, country);
    }

    @DeleteMapping("/{id}")
    public void deleteCountry(@PathVariable Integer id) {
        countryService.deleteCountry(id);
    }
}