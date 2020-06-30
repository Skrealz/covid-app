import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';

class Covid19Data {
  Covid19Data(
      {this.country,
      this.countryCode,
      this.slug,
      this.newConfirmed,
      this.totalConfirmed,
      this.newDeaths,
      this.totalDeaths,
      this.newRecovered,
      this.totalRecovered});

  String country;
  String countryCode;
  String slug;

  int newConfirmed = 3;
  int totalConfirmed = 2;
  int newDeaths = 1;
  int totalDeaths = 7;
  int newRecovered = 10;
  int totalRecovered = 12;

  Covid19Data.fromJson(Map<String, dynamic> json)
      : country = json['Country'],
        countryCode = json['CountryCode'],
        slug = json['Slug'],
        newConfirmed = json['NewConfirmed'],
        totalConfirmed = json['TotalConfirmed'],
        newDeaths = json['NewDeaths'],
        totalDeaths = json['TotalDeaths'],
        newRecovered = json['NewRecovered'],
        totalRecovered = json['TotalRecovered'];
}

class Covid19GlobalData {
  Covid19Data global;
  List<Covid19Data> countries;
  Covid19GlobalData.fromJson(Map<String, dynamic> json)
      : global = Covid19Data.fromJson(json['Global']),
        countries = (json['Countries'] as List)
            .map((i) => Covid19Data.fromJson(i))
            .toList();
}

class Covid19DataContext extends ChangeNotifier {
  Future<Covid19GlobalData> fetchingData;
  String userCountry = 'CH';

  Covid19DataContext() {
    fetchingData = _fetchData();
  }

  setUserCountry(String country) {
    userCountry = country;
    notifyListeners();
  }

  Future<Covid19GlobalData> _fetchData() async {
    Response response = await http.get('https://api.covid19api.com/summary');
    return Covid19GlobalData.fromJson(jsonDecode(response.body));
  }
}
