// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'dart:convert';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'My JSON Parsing App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   List<Shop> shops = [];
//   bool isLoading = false;
//   String error = '';
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     fetchShops();
//   }
// // Ulaanbaatar latitude
// // Ulaanbaatar longitude
//
//   Future<void> fetchShops() async {
//     setState(() {
//       isLoading = true;
//       error = ''; // Reset error message
//     });
//
//     const token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NTQsImlhdCI6MTcxMzIzMjQwOCwiZXhwIjoxNzI2MTkyNDA4fQ.hdJsGEMYRAAEs5y6RERuT2TNJTBUITkWy-7FarMc_C4"; // Replace with your actual token
//
//     try {
//       final response = await http.get(
//         Uri.parse('https://api.carcare.mn/v1/shop'),
//         headers: {'Authorization': 'Bearer $token'},
//       );
//
//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body)['data']; // Extract 'data' from JSON response
//
//         if (jsonData != null) {
//           setState(() {
//             shops = jsonData.map<Shop>((data) => Shop.fromJson(data)).toList(); // Parse JSON data and convert to list of Shop objects
//           });
//         } else {
//           setState(() {
//             shops = []; // Use empty list if data is null
//           });
//         }
//       } else {
//         setState(() {
//           error = 'Failed to load shops (${response.statusCode})'; // Set error message with status code
//         });
//       }
//     } catch (e) {
//       setState(() {
//         error = 'Error fetching data: $e'; // Set error message with the specific error
//       });
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Shop List'),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : error.isNotEmpty
//           ? Center(child: Text(error))
//           : MapWithMarkers(shops: shops),
//     );
//   }
// }
//
// class Shop {
//   final int id;
//   final String name;
//   final String description;
//   final String phone;
//   final String type;
//   final List<dynamic> additional;
//   final String thumbnail;
//   final List<BannerImage> bannerImages;
//   final List<dynamic> branches;
//   final List<dynamic> schedules;
//   final Location location;
//   final List<dynamic> services;
//
//   Shop({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.phone,
//     required this.type,
//     required this.additional,
//     required this.thumbnail,
//     required this.bannerImages,
//     required this.branches,
//     required this.schedules,
//     required this.location,
//     required this.services,
//   });
//
//   factory Shop.fromJson(Map<String, dynamic>? json) {
//     return Shop(
//       id: json?['id'] ?? 0,
//       name: json?['name'] ?? '',
//       description: json?['description'] ?? '',
//       phone: json?['phone'] ?? '',
//       type: json?['type'] ?? '',
//       additional: List<dynamic>.from(json?['additional'] ?? []),
//       thumbnail: json?['thumbnail'] ?? '',
//       bannerImages: (json?['bannerImages'] as List<dynamic>?)
//           ?.map<BannerImage>((bannerImage) => BannerImage.fromJson(bannerImage))
//           .toList() ??
//           [],
//       branches: List<dynamic>.from(json?['branches'] ?? []),
//       schedules: List<dynamic>.from(json?['schedules'] ?? []),
//       location: Location.fromJson(json?['location'] ?? {}),
//       services: List<dynamic>.from(json?['services'] ?? []),
//     );
//   }
// }
//
// class BannerImage {
//   final int id;
//   final String name;
//   final String path;
//   final String fileMimeType;
//   final int fileSize;
//   final int fileWidth;
//   final int fileHeight;
//
//   BannerImage({
//     required this.id,
//     required this.name,
//     required this.path,
//     required this.fileMimeType,
//     required this.fileSize,
//     required this.fileWidth,
//     required this.fileHeight,
//   });
//
//   factory BannerImage.fromJson(Map<String, dynamic> json) {
//     return BannerImage(
//       id: json['id'] ?? 0,
//       name: json['name'] ?? '',
//       path: json['path'] ?? '',
//       fileMimeType: json['fileMimeType'] ?? '',
//       fileSize: json['fileSize'] ?? 0,
//       fileWidth: json['fileWidth'] ?? 0,
//       fileHeight: json['fileHeight'] ?? 0,
//     );
//   }
// }
//
// class Location {
//   final int id;
//   final double longitude;
//   final double latitude;
//   final String address;
//   final dynamic city;
//   final dynamic country;
//   final dynamic province;
//   final dynamic subProvince;
//   final dynamic street;
//
//   Location({
//     required this.id,
//     required this.longitude,
//     required this.latitude,
//     required this.address,
//     this.city,
//     this.country,
//     this.province,
//     this.subProvince,
//     this.street,
//   });
//
//   factory Location.fromJson(Map<String, dynamic> json) {
//     return Location(
//       id: json['id'] ?? 0,
//       longitude: json['longitude'] ?? 0.0,
//       latitude: json['latitude'] ?? 0.0,
//       address: json['address'] ?? '',
//       city: json['city'],
//       country: json['country'],
//       province: json['province'],
//       subProvince: json['subProvince'],
//       street: json['street'],
//     );
//   }
// }
//
// class MapWithMarkers extends StatelessWidget {
//   final List<Shop> shops;
//
//   const MapWithMarkers({Key? key, required this.shops}) : super(key: key);
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     double DEFAULT_LATITUDE = 47.9187;
//     double DEFAULT_LONGITUDE = 106.917;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Map with Markers'),
//       ),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: shops.isNotEmpty
//               ? LatLng(
//             shops.first.location.latitude,
//             shops.first.location.longitude,
//           )
//               : LatLng(DEFAULT_LATITUDE, DEFAULT_LONGITUDE), // Provide default coordinates
//           zoom: 14,
//         ),
//         markers: Set<Marker>.of(
//           shops.map((shop) {
//             final location = shop.location;
//
//             return Marker(
//   markerId: MarkerId(shop.id.toString()),
//   position: LatLng(location.latitude, location.longitude),
//   infoWindow: InfoWindow(
//   title: shop.name,
//   snippet: shop.description,
//   ),
//   );
//           }),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'dart:convert';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'My JSON Parsing App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   List<Shop> shops = [];
//   bool isLoading = false;
//   String error = '';
//
//   @override
//   void initState() {
//     super.initState();
//     fetchShops();
//   }
//
//   Future<void> fetchShops() async {
//     setState(() {
//       isLoading = true;
//       error = ''; // Reset error message
//     });
//
//     const token =
//         "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NTQsImlhdCI6MTcxMzIzMjQwOCwiZXhwIjoxNzI2MTkyNDA4fQ.hdJsGEMYRAAEs5y6RERuT2TNJTBUITkWy-7FarMc_C4"; // Replace with your actual token
//
//     try {
//       final response = await http.get(
//         Uri.parse('https://api.carcare.mn/v1/shop'),
//         headers: {'Authorization': 'Bearer $token'},
//       );
//
//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body)['data']; // Extract 'data' from JSON response
//
//         if (jsonData != null) {
//           setState(() {
//             shops = jsonData
//                 .map<Shop>((data) => Shop.fromJson(data))
//                 .toList(); // Parse JSON data and convert to list of Shop objects
//           });
//         } else {
//           setState(() {
//             shops = []; // Use empty list if data is null
//           });
//         }
//       } else {
//         setState(() {
//           error =
//           'Failed to load shops (${response.statusCode})'; // Set error message with status code
//         });
//       }
//     } catch (e) {
//       setState(() {
//         error = 'Error fetching data: $e'; // Set error message with the specific error
//       });
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Shop List'),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : error.isNotEmpty
//           ? Center(child: Text(error))
//           : MapWithMarkers(shops: shops),
//     );
//   }
// }
//
// class Shop {
//   final int id;
//   final String name;
//   final String description;
//   final String phone;
//   final String type;
//   final List<dynamic> additional;
//   final String thumbnail;
//   final List<BannerImage> bannerImages;
//   final List<dynamic> branches;
//   final List<dynamic> schedules;
//   final Location location;
//   final List<dynamic> services;
//
//   Shop({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.phone,
//     required this.type,
//     required this.additional,
//     required this.thumbnail,
//     required this.bannerImages,
//     required this.branches,
//     required this.schedules,
//     required this.location,
//     required this.services,
//   });
//
//   factory Shop.fromJson(Map<String, dynamic>? json) {
//     return Shop(
//       id: json?['id'] ?? 0,
//       name: json?['name'] ?? '',
//       description: json?['description'] ?? '',
//       phone: json?['phone'] ?? '',
//       type: json?['type'] ?? '',
//       additional: List<dynamic>.from(json?['additional'] ?? []),
//       thumbnail: json?['thumbnail'] ?? '',
//       bannerImages: (json?['bannerImages'] as List<dynamic>?)
//           ?.map<BannerImage>((bannerImage) =>
//           BannerImage.fromJson(bannerImage))
//           .toList() ??
//           [],
//       branches: List<dynamic>.from(json?['branches'] ?? []),
//       schedules: List<dynamic>.from(json?['schedules'] ?? []),
//       location: Location.fromJson(json?['location'] ?? {}),
//       services: List<dynamic>.from(json?['services'] ?? []),
//     );
//   }
// }
//
// class BannerImage {
//   final int id;
//   final String name;
//   final String path;
//   final String fileMimeType;
//   final int fileSize;
//   final int fileWidth;
//   final int fileHeight;
//
//   BannerImage({
//     required this.id,
//     required this.name,
//     required this.path,
//     required this.fileMimeType,
//     required this.fileSize,
//     required this.fileWidth,
//     required this.fileHeight,
//   });
//
//   factory BannerImage.fromJson(Map<String, dynamic> json) {
//     return BannerImage(
//       id: json['id'] ?? 0,
//       name: json['name'] ?? '',
//       path: json['path'] ?? '',
//       fileMimeType: json['fileMimeType'] ?? '',
//       fileSize: json['fileSize'] ?? 0,
//       fileWidth: json['fileWidth'] ?? 0,
//       fileHeight: json['fileHeight'] ?? 0,
//     );
//   }
// }
//
// class Location {
//   final int id;
//   final double longitude;
//   final double latitude;
//   final String address;
//   final dynamic city;
//   final dynamic country;
//   final dynamic province;
//   final dynamic subProvince;
//   final dynamic street;
//
//   Location({
//     required this.id,
//     required this.longitude,
//     required this.latitude,
//     required this.address,
//     this.city,
//     this.country,
//     this.province,
//     this.subProvince,
//     this.street,
//   });
//
//   factory Location.fromJson(Map<String, dynamic> json) {
//     return Location(
//       id: json['id'] ?? 0,
//       longitude: json['longitude'] ?? 0.0,
//       latitude: json['latitude'] ?? 0.0,
//       address: json['address'] ?? '',
//       city: json['city'],
//       country: json['country'],
//       province: json['province'],
//       subProvince: json['subProvince'],
//       street: json['street'],
//     );
//   }
// }
//
// class MapWithMarkers extends StatelessWidget {
//   final List<Shop> shops;
//
//   const MapWithMarkers({Key? key, required this.shops}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // double DEFAULT_LATITUDE = 47.9187;
//     // double DEFAULT_LONGITUDE = 106.917;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Map with Markers'),
//       ),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: shops.isNotEmpty
//               ? LatLng(
//             shops.first.location.latitude,
//             shops.first.location.longitude,
//           )
//               : LatLng(
//               47.9187, 106.917
//           ),
//
//           zoom: 14,
//         ),
//         markers: Set<Marker>.of(
//           shops.map(
//                 (shop) {
//               final location = shop.location;
//
//               return Marker(
//                 markerId: MarkerId(shop.id.toString()),
//                 position: LatLng(location.latitude, location.longitude),
//                 infoWindow: InfoWindow(
//                   title: shop.name,
//                   snippet: shop.description,
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }


// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'dart:convert';
//
// void main() {
//   runApp(MyApp());
// }
// class NullableUint8List {
//   Uint8List? data;
//
// }
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'My JSON Parsing App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   List<Shop> shops = [];
//   late Map<int, BitmapDescriptor> markerIcons;
//   bool? isLoading;
//
//   String error = '';
//
//   @override
//   void initState() {
//     super.initState();
//     markerIcons = {};
//     fetchShops();
//   }
//
//   Future<void> fetchShops() async {
//     setState(() {
//       isLoading = true;
//       error = ''; // Reset error message
//     });
//
//     const token =
//         "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NTQsImlhdCI6MTcxMzIzMjQwOCwiZXhwIjoxNzI2MTkyNDA4fQ.hdJsGEMYRAAEs5y6RERuT2TNJTBUITkWy-7FarMc_C4"; // Replace with your actual token
//
//     try {
//       final response = await http.get(
//         Uri.parse('https://api.carcare.mn/v1/shop'),
//         headers: {'Authorization': 'Bearer $token'},
//       );
//
//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body)['data']; // Extract 'data' from JSON response
//
//         if (jsonData != null) {
//           setState(() {
//             shops = jsonData
//                 .map<Shop>((data) => Shop.fromJson(data))
//                 .toList(); // Parse JSON data and convert to list of Shop objects
//           });
//         } else {
//           setState(() {
//             shops = []; // Use empty list if data is null
//           });
//         }
//       } else {
//         setState(() {
//           error =
//           'Failed to load shops (${response.statusCode})'; // Set error message with status code
//         });
//       }
//     } catch (e) {
//       setState(() {
//         error = 'Error fetching data: $e'; // Set error message with the specific error
//       });
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//
//
//
//   Future<Uint8List?> getMarkerIcon(String imageUrl) async {
//     try {
//       final response = await http.get(Uri.parse(imageUrl));
//       if (response.statusCode == 200) {
//         return response.bodyBytes;
//       } else {
//         print('Failed to load image: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       print('Error loading image: $e');
//       return null;
//     }
//   }
//
//   Future<void> loadMarkerIcons() async {
//     for (var shop in shops) {
//       Uint8List? markerIcon = await getMarkerIcon(shop.thumbnail);
//       if (markerIcon != null) {
//         markerIcons[shop.id] = BitmapDescriptor.fromBytes(markerIcon);
//       } else {
//         // Handle error or provide default icon
//         markerIcons[shop.id] = BitmapDescriptor.defaultMarker;
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double DEFAULT_LATITUDE = 47.9187;
//     double DEFAULT_LONGITUDE = 106.917;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Map with Markers'),
//       ),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: shops.isNotEmpty
//               ? shops.fold(
//             LatLng(DEFAULT_LATITUDE, DEFAULT_LONGITUDE),
//                 (previousValue, shop) => LatLng(
//               shop.location.latitude ?? previousValue.latitude,
//               shop.location.longitude ?? previousValue.longitude,
//             ),
//           )
//               : LatLng(DEFAULT_LATITUDE, DEFAULT_LONGITUDE),
//           zoom: 14,
//         ),
//         markers: Set<Marker>.of(
//           shops.map(
//                 (shop) => Marker(
//               markerId: MarkerId(shop.id.toString()),
//               position: LatLng(shop.location.latitude, shop.location.longitude),
//               infoWindow: InfoWindow(
//                 title: shop.name,
//                 snippet: shop.description,
//               ),
//               icon: markerIcons.containsKey(shop.id)
//                   ? markerIcons[shop.id]!
//                   : BitmapDescriptor.defaultMarker,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class Shop {
//   final int id;
//   final String name;
//   final String description;
//   final String phone;
//   final String type;
//   final List<dynamic> additional;
//   final String thumbnail;
//   final List<BannerImage> bannerImages;
//   final List<dynamic> branches;
//   final List<dynamic> schedules;
//   final Location location;
//   final List<dynamic> services;
//
//   Shop({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.phone,
//     required this.type,
//     required this.additional,
//     required this.thumbnail,
//     required this.bannerImages,
//     required this.branches,
//     required this.schedules,
//     required this.location,
//     required this.services,
//   });
//
//   factory Shop.fromJson(Map<String, dynamic>? json) {
//     return Shop(
//       id: json?['id'] ?? 0,
//       name: json?['name'] ?? '',
//       description: json?['description'] ?? '',
//       phone: json?['phone'] ?? '',
//       type: json?['type'] ?? '',
//       additional: List<dynamic>.from(json?['additional'] ?? []),
//       thumbnail: json?['thumbnail'] ?? '',
//       bannerImages: (json?['bannerImages'] as List<dynamic>?)
//           ?.map<BannerImage>((bannerImage) =>
//           BannerImage.fromJson(bannerImage))
//           .toList() ??
//           [],
//       branches: List<dynamic>.from(json?['branches'] ?? []),
//       schedules: List<dynamic>.from(json?['schedules'] ?? []),
//       location: Location.fromJson(json?['location'] ?? {}),
//       services: List<dynamic>.from(json?['services'] ?? []),
//     );
//   }
// }
//
// class BannerImage {
//   final int id;
//   final String name;
//   final String path;
//   final String fileMimeType;
//   final int fileSize;
//   final int fileWidth;
//   final int fileHeight;
//
//   BannerImage({
//     required this.id,
//     required this.name,
//     required this.path,
//     required this.fileMimeType,
//     required this.fileSize,
//     required this.fileWidth,
//     required this.fileHeight,
//   });
//
//   factory BannerImage.fromJson(Map<String, dynamic> json) {
//     return BannerImage(
//       id: json['id'] ?? 0,
//       name: json['name'] ?? '',
//       path: json['path'] ?? '',
//       fileMimeType: json['fileMimeType'] ?? '',
//       fileSize: json['fileSize'] ?? 0,
//       fileWidth: json['fileWidth'] ?? 0,
//       fileHeight: json['fileHeight'] ?? 0,
//     );
//   }
// }
//
// class Location {
//   final int id;
//   final double longitude;
//   final double latitude;
//   final String address;
//   final dynamic city;
//   final dynamic country;
//   final dynamic province;
//   final dynamic subProvince;
//   final dynamic street;
//
//   Location({
//     required this.id,
//     required this.longitude,
//     required this.latitude,
//     required this.address,
//     this.city,
//     this.country,
//     this.province,
//     this.subProvince,
//     this.street,
//   });
//
//   factory Location.fromJson(Map<String, dynamic> json) {
//     return Location(
//       id: json['id'] ?? 0,
//       longitude: json['longitude'] ?? 0.0,
//       latitude: json['latitude'] ?? 0.0,
//       address: json['address'] ?? '',
//       city: json['city'],
//       country: json['country'],
//       province: json['province'],
//       subProvince: json['subProvince'],
//       street: json['street'],
//     );
//   }
// }


// import 'dart:async';
// import 'dart:convert';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps_flutter;
//
// void main() {
//   runApp(MyApp());
// }
//
// class NullableUint8List {
//   Uint8List? data;
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'My JSON Parsing App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   List<Shop> shops = [];
//   late Map<int, Uint8List> markerIcons;
//   bool? isLoading;
//   String error = '';
//
//   @override
//   void initState() {
//     super.initState();
//     markerIcons = {};
//     fetchShops();
//   }
//
//   Future<void> fetchShops() async {
//     setState(() {
//       isLoading = true;
//       error = ''; // Reset error message
//     });
//
//     const token =
//         "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NTQsImlhdCI6MTcxMzIzMjQwOCwiZXhwIjoxNzI2MTkyNDA4fQ.hdJsGEMYRAAEs5y6RERuT2TNJTBUITkWy-7FarMc_C4"; // Replace with your actual token
//
//     try {
//       final response = await http.get(
//         Uri.parse('https://api.carcare.mn/v1/shop'),
//         headers: {'Authorization': 'Bearer $token'},
//       );
//
//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body)['data']; // Extract 'data' from JSON response
//
//         if (jsonData != null) {
//           setState(() {
//             shops = jsonData
//                 .map<Shop>((data) => Shop.fromJson(data))
//                 .toList(); // Parse JSON data and convert to list of Shop objects
//           });
//           await loadMarkerIcons();
//         } else {
//           setState(() {
//             shops = []; // Use empty list if data is null
//           });
//         }
//       } else {
//         setState(() {
//           error =
//           'Failed to load shops (${response.statusCode})'; // Set error message with status code
//         });
//       }
//     } catch (e) {
//       setState(() {
//         error = 'Error fetching data: $e'; // Set error message with the specific error
//       });
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   Future<Uint8List?> getMarkerIcon(String imageUrl) async {
//     try {
//       final response = await http.get(Uri.parse(imageUrl));
//       if (response.statusCode == 200) {
//         return response.bodyBytes;
//       } else {
//         print('Failed to load image: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       print('Error loading image: $e');
//       return null;
//     }
//   }
//
//   Future<Uint8List> _getBytesFromBitmapDescriptor(
//       google_maps_flutter.BitmapDescriptor bitmapDescriptor) async {
//     final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
//     final Canvas canvas = Canvas(pictureRecorder);
//     final int width = 60; // Adjust the width as needed
//     final int height = 60; // Adjust the height as needed
//     final Paint paint = Paint()..color = Colors.transparent; // Set the paint color to transparent
//     final Rect rect = Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble());
//     canvas.drawRect(rect, paint); // Draw a transparent rectangle to clear the canvas
//     final MarkerGenerator markerGenerator = MarkerGenerator(width, height, bitmapDescriptor);
//     markerGenerator.paint(canvas, Offset.zero); // Draw the marker icon onto the canvas
//     final img = await pictureRecorder.endRecording().toImage(width, height);
//     final data = await img.toByteData(format: ui.ImageByteFormat.png);
//     return data!.buffer.asUint8List();
//   }
//
//   Future<void> loadMarkerIcons() async {
//     for (var shop in shops) {
//       Uint8List? markerIcon = await getMarkerIcon(shop.thumbnail);
//       if (markerIcon != null) {
//         markerIcons[shop.id] = markerIcon;
//       } else {
//         // Use default marker icon if image loading fails
//         markerIcons[shop.id] = await _getBytesFromBitmapDescriptor(
//             google_maps_flutter.BitmapDescriptor.defaultMarkerWithHue(
//                 google_maps_flutter.BitmapDescriptor.hueAzure));
//       }
//     }
//     setState(() {}); // Update the state to reflect marker icons loaded
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Map with Markers'),
//       ),
//       body: google_maps_flutter.GoogleMap(
//         initialCameraPosition: google_maps_flutter.CameraPosition(
//           target: google_maps_flutter.LatLng(47.9187, 106.917),
//           zoom: 14,
//         ),
//         markers: Set<google_maps_flutter.Marker>.of(
//           shops.map(
//                 (shop) => google_maps_flutter.Marker(
//               markerId: google_maps_flutter.MarkerId(shop.id.toString()),
//               position: google_maps_flutter.LatLng(
//                 shop.location.latitude ?? 0,
//                 shop.location.longitude ?? 0,
//               ),
//               infoWindow: google_maps_flutter.InfoWindow(
//                 title: shop.name,
//                 snippet: shop.description,
//               ),
//               icon: google_maps_flutter.BitmapDescriptor.fromBytes(markerIcons[shop.id]!),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class Shop {
//   final int id;
//   final String name;
//   final String description;
//   final String phone;
//   final String type;
//   final List<dynamic> additional;
//   final String thumbnail;
//   final List<BannerImage> bannerImages;
//   final List<dynamic> branches;
//   final List<dynamic> schedules;
//   final Location location;
//   final List<dynamic> services;
//
//   Shop({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.phone,
//     required this.type,
//     required this.additional,
//     required this.thumbnail,
//     required this.bannerImages,
//     required this.branches,
//     required this.schedules,
//     required this.location,
//     required this.services,
//   });
//
//   factory Shop.fromJson(Map<String, dynamic>? json) {
//     return Shop(
//       id: json?['id'] ?? 0,
//       name: json?['name'] ?? '',
//       description: json?['description'] ?? '',
//       phone: json?['phone'] ?? '',
//       type: json?['type'] ?? '',
//       additional: List<dynamic>.from(json?['additional'] ?? []),
//       thumbnail: json?['thumbnail'] ?? '',
//       bannerImages: (json?['bannerImages'] as List<dynamic>?)
//           ?.map<BannerImage>((bannerImage) => BannerImage.fromJson(bannerImage))
//           .toList() ??
//           [],
//       branches: List<dynamic>.from(json?['branches'] ?? []),
//       schedules: List<dynamic>.from(json?['schedules'] ?? []),
//       location: Location.fromJson(json?['location'] ?? {}),
//       services: List<dynamic>.from(json?['services'] ?? []),
//     );
//   }
// }
//
// class BannerImage {
//   final int id;
//   final String name;
//   final String path;
//   final String fileMimeType;
//   final int fileSize;
//   final int fileWidth;
//   final int fileHeight;
//
//   BannerImage({
//     required this.id,
//     required this.name,
//     required this.path,
//     required this.fileMimeType,
//     required this.fileSize,
//     required this.fileWidth,
//     required this.fileHeight,
//   });
//
//   factory BannerImage.fromJson(Map<String, dynamic> json) {
//     return BannerImage(
//       id: json['id'] ?? 0,
//       name: json['name'] ?? '',
//       path: json['path'] ?? '',
//       fileMimeType: json['fileMimeType'] ?? '',
//       fileSize: json['fileSize'] ?? 0,
//       fileWidth: json['fileWidth'] ?? 0,
//       fileHeight: json['fileHeight'] ?? 0,
//     );
//   }
// }
//
// class Location {
//   final int id;
//   final double longitude;
//   final double latitude;
//   final String address;
//   final dynamic city;
//   final dynamic country;
//   final dynamic province;
//   final dynamic subProvince;
//   final dynamic street;
//
//   Location({
//     required this.id,
//     required this.longitude,
//     required this.latitude,
//     required this.address,
//     this.city,
//     this.country,
//     this.province,
//     this.subProvince,
//     this.street,
//   });
//
//   factory Location.fromJson(Map<String, dynamic> json) {
//     return Location(
//       id: json['id'] ?? 0,
//       longitude: json['longitude'] ?? 0.0,
//       latitude: json['latitude'] ?? 0.0,
//       address: json['address'] ?? '',
//       city: json['city'],
//       country: json['country'],
//       province: json['province'],
//       subProvince: json['subProvince'],
//       street: json['street'],
//     );
//   }
// }
//
// class MarkerGenerator {
//   final int width;
//   final int height;
//   final google_maps_flutter.BitmapDescriptor bitmapDescriptor;
//
//   MarkerGenerator(this.width, this.height, this.bitmapDescriptor);
//
//   void paint(Canvas canvas, Offset offset) {
//     final rect = Rect.fromPoints(
//       offset,
//       Offset(offset.dx + width.toDouble(), offset.dy + height.toDouble()),
//     );
//     final Paint paint = Paint()..color = Colors.transparent;
//     canvas.drawRect(rect, paint); // Draw a transparent rectangle to clear the canvas
//     final Uint8List imageData = bitmapDescriptor.toImageData()!.buffer.asUint8List();
//     final ui.Image image = decodeImageFromList(imageData)!;
//     final src = Rect.fromLTWH(0.0, 0.0, image.width.toDouble(), image.height.toDouble());
//     final dst = Rect.fromLTWH(offset.dx, offset.dy, width.toDouble(), height.toDouble());
//     canvas.drawImageRect(image, src, dst, paint);
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps_flutter;

void main() {
  runApp(MyApp());
}

class NullableUint8List {
  Uint8List? data;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My JSON Parsing App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Shop> shops = [];
  late Map<int, Uint8List> markerIcons;
  bool? isLoading;
  String error = '';

  @override
  void initState() {
    super.initState();
    markerIcons = {};
    fetchShops();
  }

  Future<void> fetchShops() async {
    setState(() {
      isLoading = true;
      error = ''; // Reset error message
    });

    const token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NTQsImlhdCI6MTcxMzIzMjQwOCwiZXhwIjoxNzI2MTkyNDA4fQ.hdJsGEMYRAAEs5y6RERuT2TNJTBUITkWy-7FarMc_C4"; // Replace with your actual token

    try {
      final response = await http.get(
        Uri.parse('https://api.carcare.mn/v1/shop'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {

        final jsonData = json.decode(response.body)['data']; // Extract 'data' from JSON response

        if (jsonData != null) {
          setState(() {
            shops = jsonData
                .map<Shop>((data) => Shop.fromJson(data))
                .toList(); // Parse JSON data and convert to list of Shop objects
          });
          await loadMarkerIcons();
        } else {
          setState(() {
            shops = []; // Use empty list if data is null
          });
        }
      } else {
        setState(() {
          error =
          'Failed to load shops (${response.statusCode})'; // Set error message with status code
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error fetching data: $e'; // Set error message with the specific error
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Uint8List?> getMarkerIcon(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      print('Response Body: ${response.body}');
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print('Failed to load image: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error loading image: $e');
      return null;
    }
  }

  Future<void> loadMarkerIcons() async {
    for (var shop in shops) {
      Uint8List? markerIcon = await getMarkerIcon(shop.thumbnail);
      if (markerIcon != null) {
        markerIcons[shop.id] = markerIcon;
      } else {
        // Use default marker icon if image loading fails
        markerIcons[shop.id] = await MarkerGenerator.defaultMarkerBytes();
      }
    }
    setState(() {}); // Update the state to reflect marker icons loaded
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map with Markers'),
      ),
      body: google_maps_flutter.GoogleMap(
        initialCameraPosition: google_maps_flutter.CameraPosition(
          target: google_maps_flutter.LatLng(47.9187, 106.917),
          zoom: 14,
        ),
        markers: Set<google_maps_flutter.Marker>.of(
          shops.map(
                (shop) => google_maps_flutter.Marker(
              markerId: google_maps_flutter.MarkerId(shop.id.toString()),
              position: google_maps_flutter.LatLng(
                shop.location.latitude ?? 0,
                shop.location.longitude ?? 0,
              ),
              infoWindow: google_maps_flutter.InfoWindow(
                title: shop.name,
                snippet: shop.description,
              ),
                  icon: markerIcons[shop.id] != null
                      ? google_maps_flutter.BitmapDescriptor.fromBytes(markerIcons[shop.id]!)
                      : google_maps_flutter.BitmapDescriptor.defaultMarker,
            ),
          ),
        ),
      ),
    );
  }
}

class Shop {
  final int id;
  final String name;
  final String description;
  final String phone;
  final String type;
  final List<dynamic> additional;
  final String thumbnail;
  final List<BannerImage> bannerImages;
  final List<dynamic> branches;
  final List<dynamic> schedules;
  final Location location;
  final List<dynamic> services;

  Shop({
    required this.id,
    required this.name,
    required this.description,
    required this.phone,
    required this.type,
    required this.additional,
    required this.thumbnail,
    required this.bannerImages,
    required this.branches,
    required this.schedules,
    required this.location,
    required this.services,
  });

  factory Shop.fromJson(Map<String, dynamic>? json) {
    return Shop(
      id: json?['id'] ?? 0,
      name: json?['name'] ?? '',
      description: json?['description'] ?? '',
      phone: json?['phone'] ?? '',
      type: json?['type'] ?? '',
      additional: List<dynamic>.from(json?['additional'] ?? []),
      thumbnail: json?['thumbnail'] ?? '',
      bannerImages: (json?['bannerImages'] as List<dynamic>?)
          ?.map<BannerImage>((bannerImage) => BannerImage.fromJson(bannerImage))
          .toList() ??
          [],
      branches: List<dynamic>.from(json?['branches'] ?? []),
      schedules: List<dynamic>.from(json?['schedules'] ?? []),
      location: Location.fromJson(json?['location'] ?? {}),
      services: List<dynamic>.from(json?['services'] ?? []),
    );
  }
}

class BannerImage {
  final int id;
  final String name;
  final String path;
  final String fileMimeType;
  final int fileSize;
  final int fileWidth;
  final int fileHeight;

  BannerImage({
    required this.id,
    required this.name,
    required this.path,
    required this.fileMimeType,
    required this.fileSize,
    required this.fileWidth,
    required this.fileHeight,
  });

  factory BannerImage.fromJson(Map<String, dynamic> json) {
    return BannerImage(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      path: json['path'] ?? '',
      fileMimeType: json['fileMimeType'] ?? '',
      fileSize: json['fileSize'] ?? 0,
      fileWidth: json['fileWidth'] ?? 0,
      fileHeight: json['fileHeight'] ?? 0,
    );
  }
}

class Location {
  final int id;
  final double longitude;
  final double latitude;
  final String address;
  final dynamic city;
  final dynamic country;
  final dynamic province;
  final dynamic subProvince;
  final dynamic street;

  Location({
    required this.id,
    required this.longitude,
    required this.latitude,
    required this.address,
    this.city,
    this.country,
    this.province,
    this.subProvince,
    this.street,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] ?? 0,
      longitude: json['longitude'] ?? 0.0,
      latitude: json['latitude'] ?? 0.0,
      address: json['address'] ?? '',
      city: json['city'],
      country: json['country'],
      province: json['province'],
      subProvince: json['subProvince'],
      street: json['street'],
    );
  }
}

class MarkerGenerator {
  static Future<Uint8List> defaultMarkerBytes() async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.blue;
    final Radius radius = Radius.circular(20);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0, 0, 40, 40),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
      paint,
    );
    final ui.Image img = await pictureRecorder.endRecording().toImage(40, 40);
    final ByteData? data = await img.toByteData(format: ui.ImageByteFormat.png);
    if (data != null && data.lengthInBytes != 0) {
      return data.buffer.asUint8List();
    } else {
      // If byte data is empty or null, return a placeholder byte data
      return Uint8List.fromList([0]); // Provide a non-empty byte data
    }
  }
}




