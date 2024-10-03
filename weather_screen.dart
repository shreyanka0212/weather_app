import "dart:convert";
import "dart:ui";

import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:weather_app/Additionalinformation.dart";
import "package:weather_app/Hourlyforecastitem.dart";
import "package:http/http.dart" as http;
import "package:weather_app/secrets.dart";

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  
  
  late Future <Map<String, dynamic>> weather;  
  Future<Map<String, dynamic>> getCurrentWeather() async{
    try{
    String cityName = "London";
    final result= await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q= $cityName,uk&APPID= $openWeatherAPIKey'));
    
    final data = jsonDecode(result.body);
    if(data["cod"] != 200){
      throw 'An unexpected error occured';
    }
    
      //temp = data['list'][0]['main']['temp'];
      
    return data;


  } catch (e){
    throw e.toString();
  }}
  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
       appBar: AppBar(
        title: const Text('Weather App', style: TextStyle(
          fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        actions:  [
          IconButton(
            onPressed: () {
              setState(() {
                weather = getCurrentWeather();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
       
       
       body: 
       FutureBuilder(
        future: getCurrentWeather(),
         builder:(context, snapshot) {
          if(snapshot.connectionState== ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()));
          }
          final data = snapshot.data!;
          final currentTemp = data['list'][0]['main']['temp'];
           return Padding(
          
           padding: const EdgeInsets.all(16.0),
           child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Padding(
                        padding:  const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text('$currentTemp K', style: const TextStyle(
                              fontWeight: FontWeight.bold,fontSize: 32
                              ),
                               ),
                               const SizedBox(height: 16,),
                              const Icon(
                                Icons.cloud, size: 64,
                                ),
                                const SizedBox(height: 16),
                                const Text('Rain', style: TextStyle(
                                  fontSize: 20
                                  ),
                                  ),
                          ]
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            //main card
              //weather forecast card
              const SizedBox(height: 20, ),
              
              const Text('Weather Forecast', style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                  ),
                  ),
              const SizedBox(height: 16),
              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [ 
                  Hourlyforecastitem(
                    time: '9:00',
                    icon: Icons.sunny,
                    word: '301.17',
                  ),
                  Hourlyforecastitem(
                    time: '12:00',
                    icon: Icons.cloud,
                    word: '301.54'
                  ),
                  Hourlyforecastitem(
                    time : '15:00',
                    icon: Icons.cloudy_snowing,
                    word : '301.11'
                  ),
                  Hourlyforecastitem(
                    time : '18:00',
                    icon: Icons.cloud,
                    word: '300.75',
                  ),
                  Hourlyforecastitem(
                    time: '21:00',
                    icon: Icons.cloudy_snowing,
                    word : '300.25'
                  )
                      ],
                ),
              ),
            
              
                
              
              // additional informtion
              const SizedBox(height: 20),
              const Text('Additional Information', style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                  ),
                  ),
              const SizedBox(height: 16),
             const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [ Additionalinformation(
                  icon: Icons.water_drop,
                  label : 'Humidity',
                  value: '96',
                ),
                Additionalinformation(
                  icon: Icons.air,
                  label: 'WindSpeed',
                  value: '7.67'
                ),
                Additionalinformation(
                  icon: Icons.beach_access,
                  label: 'Pressure',
                  value: '1000', 
                ),
                ],
              ),
            ]    
           
         ),
         
         );
         },
       ),   
    );
    
  }
}
