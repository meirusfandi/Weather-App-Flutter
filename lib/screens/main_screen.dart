import 'package:flutter/material.dart';
import 'package:weather_app/data/model/weather_response.dart';
import 'package:weather_app/data/network/api_services.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {

  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();

}

class _MainScreenState extends State<MainScreen> {

  late WeatherResponse weatherResponse;
  late ApiServices _apiServices;

  @override
  void initState() {
    _apiServices = ApiServices();
    super.initState();
  }

  Widget onLoading() {
    return Center(
      child: Column(
        children: const [
          Text("Loading..."),
          CircularProgressIndicator()
        ],
      ),
    );
  }

  Widget onEmptyOrError(String message) {
    return Center(
      child: Column(
        children: [
          Text(message),
        ],
      ),
    );
  }

  Widget onSuccess(WeatherResponse data) {
    print("Weather Forecast:");
    return Flex(
      direction: Axis.vertical,
      children: [
        Text("Longitude   : ${data.lon}"),
        Text("Latitude    : ${data.lat}"),
        Text("Timezone    : ${data.timezone}"),
        Text("Time Now    : ${DateFormat("EEE, dd MMM yyyy").format(DateTime.fromMillisecondsSinceEpoch(data.current.dt * 1000))}"),
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: data.daily.length,
            itemBuilder: (context, index) {
              var eachData = data.daily[index];
              print("${DateFormat("EEE, dd MMM yyyy").format(DateTime.fromMillisecondsSinceEpoch(eachData.dt * 1000))} : ${eachData.temp.day}\u2103");
              return Container(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    title: Text(DateFormat("EEE, dd MMM yyyy").format(DateTime.fromMillisecondsSinceEpoch(eachData.dt * 1000))),
                    trailing: Text("${eachData.temp.day.toString()}\u2103"),
                  ),
                ),
              );
            }
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
      ),
      body: Column(
        children: [
          const Text("List Weather in Jakarta (Monas)"),
          FutureBuilder<WeatherResponse>(
            future: _apiServices.fetchWeather(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  var data = snapshot.data;
                  return onSuccess(data!);
                } else {
                  return onEmptyOrError("No Data Found");
                }
                // return onSuccess(data!);
              } else if (snapshot.hasError) {
                return onEmptyOrError(snapshot.error.toString());
              } else {
                return onLoading();
              }
            }
          )
        ],
      ),
    );
  }

}