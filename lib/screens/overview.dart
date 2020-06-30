import 'dart:collection';

import 'package:covid19_dashboard/models/covid19_data.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HashMap<String, String> countries = HashMap();
    List<Covid19Data> data = Provider.of<Covid19GlobalData>(context)?.countries;
    data?.sort((a, b) => a.country.compareTo(b.country));
    if (data != null) {
      data.forEach((data) {
        countries.putIfAbsent(data.country, () => data.countryCode);
      });
    }

    return AppScreen(
      title: 'Overview',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Cases worldwide',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          Divider(),
          CasesCounter(),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              'Cases in your country',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          Divider(),
          DropdownButton(
              value: Provider.of<Covid19DataContext>(context).userCountry,
              items: [
                for (String country in countries.keys.toList()..sort())
                  DropdownMenuItem(
                    value: countries[country],
                    child: Text(country),
                  )
              ],
              onChanged: (String country) {
                Provider.of<Covid19DataContext>(context, listen: false)
                    .setUserCountry(country);
              }),
          CasesCounter(
            country: Provider.of<Covid19DataContext>(context).userCountry,
          ),
        ],
      ),
    );
  }
}

class AppScreen extends StatelessWidget {
  const AppScreen({Key key, @required this.child, @required this.title})
      : super(key: key);
  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).accentColor,
      body: Container(
          height: double.infinity,
          width: double.infinity,
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            color: Colors.white,
          ),
          child: child),
    );
  }
}

class CasesCounter extends StatelessWidget {
  const CasesCounter({Key key, this.country}) : super(key: key);

  final String country;

  @override
  Widget build(BuildContext context) {
    return Consumer<Covid19GlobalData>(
      builder: (BuildContext context, Covid19GlobalData value, Widget child) {
        Covid19Data data;
        if (country == null)
          data = value?.global;
        else
          data = value?.countries
              ?.firstWhere((covidData) => covidData.countryCode == country);
        return GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          primary: false,
          children: <Widget>[
            NumberCard(
              label: 'New Confirmed',
              number: data?.newConfirmed,
              color: Colors.orange,
            ),
            NumberCard(
              label: 'New Deaths',
              number: data?.newDeaths,
              color: Colors.red,
            ),
            NumberCard(
              label: 'New Recovered',
              number: data?.newRecovered,
              color: Colors.green,
            ),
            NumberCard(
              label: 'Total Confirmed',
              number: data?.totalConfirmed,
              color: Colors.orange,
            ),
            NumberCard(
              label: 'Total Deaths',
              number: data?.totalDeaths,
              color: Colors.red,
            ),
            NumberCard(
              label: 'Total Recovered',
              number: data?.totalRecovered,
              color: Colors.green,
            ),
          ],
        );
      },
    );
  }
}

class NumberCard extends StatelessWidget {
  const NumberCard({Key key, this.label, this.number, this.color})
      : super(key: key);

  final String label;
  final int number;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 120,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: Colors.orange[50],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              (number != null)
                  ? Text(
                      NumberFormat.compactCurrency(
                        decimalDigits: 0,
                        symbol:
                            '', // if you want to add currency symbol then pass that in this else leave it empty.
                      ).format(number),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: color),
                    )
                  : CircularProgressIndicator(),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
