import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  late Map<int, BitmapDescriptor> markerIcons;
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
        markerIcons[shop.id] = BitmapDescriptor.fromBytes(markerIcon);
      } else {
        // Handle error or provide default icon
        markerIcons[shop.id] = BitmapDescriptor.defaultMarker;
      }
    }
    setState(() {}); // Update the state to reflect marker icons loaded
  }

  @override
  Widget build(BuildContext context) {
    double DEFAULT_LATITUDE = 47.9187;
    double DEFAULT_LONGITUDE = 106.917;
    return Scaffold(
      appBar: AppBar(
        title: Text('Map with Markers'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: shops.isNotEmpty
              ? shops.fold(
            LatLng(DEFAULT_LATITUDE, DEFAULT_LONGITUDE),
                (previousValue, shop) => LatLng(
              shop.location.latitude ?? previousValue.latitude,
              shop.location.longitude ?? previousValue.longitude,
            ),
          )
              : LatLng(DEFAULT_LATITUDE, DEFAULT_LONGITUDE),
          zoom: 14,
        ),
        markers: Set<Marker>.of(
          shops.map(
                (shop) => Marker(
              markerId: MarkerId(shop.id.toString()),
              position: LatLng(
                shop.location.latitude,
                shop.location.longitude,
              ),
              infoWindow: InfoWindow(
                title: shop.name,
                snippet: shop.description,
              ),
              icon: markerIcons.containsKey(shop.id)
                  ? markerIcons[shop.id]!
                  : BitmapDescriptor.defaultMarker,
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