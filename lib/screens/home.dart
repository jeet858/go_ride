import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_ride/widgets/custom_bottom_appbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_ride/constants.dart';
import 'package:go_ride/widgets/custom_button.dart';
import 'package:go_ride/widgets/maps.dart';
import 'package:mappls_gl/mappls_gl.dart';
import 'package:mappls_place_widget/mappls_place_widget.dart';

import '../utils/polyline.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ReverseGeocodePlace _origin = ReverseGeocodePlace();
  ReverseGeocodePlace _destination = ReverseGeocodePlace();
  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(25.321684, 82.987289),
    zoom: 14.0,
  );
  static const String accessToken = "";
  static const String restApiKey = "";
  static const String atlasClientId =
      "";
  static const String atlasClientSecret =
      "";
  late MapplsMapController controller;


  late LatLng originLatLng;
  late LatLng destinationLatLng;
  LatLng currentLocation = const LatLng(25.321684, 82.987289);
  late ResourceList selectedResource;
  DirectionsRoute? route;
  List<String> profile = [
    DirectionCriteria.PROFILE_DRIVING,
    DirectionCriteria.PROFILE_BIKING,
    DirectionCriteria.PROFILE_WALKING,
  ];
  bool isLoaded = false;
  int markerCount = 0;
  bool _isOriginSelected = false;
  String pickupPlaceName = '';
  String destinationPlaceName = '';
  openMapplsPlacePickerWidget() async {
    ReverseGeocodePlace place;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      place = await openPlacePicker(PickerOption(
          includeDeviceLocationButton: true,
          showMarkerShadow: false,
          includeSearch: true,
          pickerButtonBackgroundColor: '#4D1B6A',
          placeOptions: PlaceOptions(
            isShowCurrentLocation: true,
          )));
    } on PlatformException {
      place = ReverseGeocodePlace();
    }
    if (kDebugMode) {
      print(json.encode(place.toJson()));
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    if (!_isOriginSelected) {
      setState(() {
        _origin = place;
        _isOriginSelected = true;
      });

    } else {
      setState(() {
        _destination = place;
      });
    }
    print(place.toJson());
  }

  openOriginPickupWidget() async {
    ReverseGeocodePlace place;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      place = await openPlacePicker(PickerOption(
          includeDeviceLocationButton: true,
          showMarkerShadow: false,
          includeSearch: true,
          pickerButtonBackgroundColor: '#4D1B6A',
          placeOptions: PlaceOptions(
            isShowCurrentLocation: true,
          )));
    } on PlatformException {
      print('in platform exception');
      place = ReverseGeocodePlace();
    }
    if (kDebugMode) {
      print(json.encode(place.toJson()));
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    controller.clearSymbols();
    controller.clearLines();
    setState(() {
      _origin = place;
      pickupPlaceName = place.formattedAddress.toString();
      currentLocation =
          LatLng(_origin.latitude!.toDouble(), _origin.longitude!.toDouble());
      addMarker(currentLocation, "icon", "assets/images/custom-icon.png");
    });
    controller.easeCamera(CameraUpdate.newLatLngZoom(
        LatLng(_origin.latitude!.toDouble(), _origin.longitude!.toDouble()),
        14));
    print(place.toJson());
  }

  openDestinationPickupWidget() async {
    ReverseGeocodePlace place;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      place = await openPlacePicker(PickerOption(
          includeDeviceLocationButton: true,
          showMarkerShadow: false,
          includeSearch: true,
          pickerButtonBackgroundColor: '#4D1B6A',
          placeOptions: PlaceOptions(
            isShowCurrentLocation: true,
          )));
    } on PlatformException {
      place = ReverseGeocodePlace();
    }
    if (kDebugMode) {
      print(json.encode(place.toJson()));
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    // controller.clearSymbols();
    setState(() {
      _destination = place;
      destinationPlaceName = place.formattedAddress.toString();
      addMarker(
          LatLng(_destination.latitude!.toDouble(),
              _destination.longitude!.toDouble()),
          "car-icon",
          "assets/images/car-icon.png");

    });
    callDirection(
        LatLng(_origin.latitude!.toDouble(), _origin.longitude!.toDouble()),
        LatLng(_destination.latitude!.toDouble(),
            _destination.longitude!.toDouble()));

    print(place.toJson());
  }

  Future<Position> _getCurrentLocation() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return Future.error('Location services are disabled.');
    }

    // Request location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permissions are denied.");
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permissions are permanently denied.");
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    print('before getting location');
    // Get current location
    Position position = await Geolocator.getCurrentPosition();
    print('after getting location');

    // Print the current location
    print(
        "Current Location: Latitude ${position.latitude}, Longitude ${position.longitude}");
    // controller.easeCamera(CameraUpdate.newLatLngZoom(
    //     LatLng(position.latitude, position.longitude), 14));
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
      isLoaded = true;
      originLatLng = LatLng(position.latitude, position.longitude);
    });
    return position;
  }

  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return controller.addImage(name, list);
  }

  void addMarker(
      LatLng coordinates, String markerName, String assetName) async {
    await addImageFromAsset(markerName, assetName);
    controller.addSymbol(
        SymbolOptions(geometry: coordinates, iconImage: markerName, iconSize: 1));
  }

  void drawPath(List<LatLng> latlngList) {
    controller.addLine(LineOptions(
      geometry: latlngList,
      lineColor: "#3bb2d0",
      lineWidth: 4,
    ));
    LatLngBounds latLngBounds = boundsFromLatLngList(latlngList);
    controller.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds,
        top: 100, bottom: 20, left: 10, right: 10));
  }

  boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null || x1 == null || y0 == null || y1 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
        northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }

  void callDirection(LatLng origin, LatLng destination) async {
    await controller.clearSymbols();
    await controller.clearLines();
    await addImageFromAsset("icon", "assets/images/custom-icon.png");
    await addImageFromAsset("car-icon", "assets/images/car-icon.png");
    var imageCounter = 1;

    setState(() {
      route = null;
    });
    try {
      DirectionResponse? directionResponse = await MapplsDirection(
        origin: origin,
        destination: destination,
        alternatives: false,
        steps: true,
        resource: DirectionCriteria.RESOURCE_ROUTE_ETA,
        profile: DirectionCriteria.PROFILE_DRIVING,
      ).callDirection();
      if (directionResponse != null &&
          directionResponse.routes != null &&
          directionResponse.routes!.length > 0) {
        setState(() {
          route = directionResponse.routes![0];
        });
        Polyline polyline = Polyline.Decode(
            encodedString: directionResponse.routes![0].geometry, precision: 6);
        List<LatLng> latlngList = [];
        if (polyline.decodedCoords != null) {
          polyline.decodedCoords?.forEach((element) {
            latlngList.add(LatLng(element[0], element[1]));
          });
        }
        if (directionResponse.waypoints != null) {
          List<SymbolOptions> symbols = [];
          directionResponse.waypoints?.forEach((element) {
            if (imageCounter == 1) {
              symbols.add(
                SymbolOptions(geometry: element.location, iconImage: 'icon', iconSize:10),
              );
              imageCounter++;
            } else {
              symbols.add(
                SymbolOptions(
                    geometry: element.location,
                    iconImage: 'car-icon',
                    iconSize: 10),
              );
            }
          });
          controller.addSymbols(symbols);
        }
        drawPath(latlngList);
      }
    } on PlatformException catch (e) {
      print(e.code);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    MapplsAccountManager.setMapSDKKey(accessToken);
    MapplsAccountManager.setRestAPIKey(restApiKey);
    MapplsAccountManager.setAtlasClientId(atlasClientId);
    MapplsAccountManager.setAtlasClientSecret(atlasClientSecret);
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          child: Stack(
            children: [
              isLoaded
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: MapplsMap(
                        initialCameraPosition: _kInitialPosition,
                        myLocationEnabled: false,
                        onMapCreated: (map) => {
                          controller = map,
                          controller.easeCamera(CameraUpdate.newLatLngZoom(
                              LatLng(currentLocation.latitude,
                                  currentLocation.longitude),
                              14)),
                          addMarker(
                              LatLng(currentLocation.latitude,
                                  currentLocation.longitude),
                              "icon",
                              "assets/images/custom-icon.png"),
                        },
                        onMapClick: (lat, lng) async {

                          controller.easeCamera(CameraUpdate.newLatLngZoom(
                              LatLng(lng.latitude, lng.longitude), 14));
                        },
                        onMapLongClick: (point, mark) {
                          addMarker(
                              mark, "car-icon", "assets/images/car-icon.png");
                          callDirection(currentLocation, mark);
                        },
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
              Container(
                width: double.infinity,
                height: 60,
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MaterialButton(
                      onPressed: null,
                      minWidth: 30,
                      child: Image.asset(
                        'assets/images/back-arrow-button.png',
                        width: 30,
                      ),
                    ),
                    MaterialButton(
                      onPressed: null,
                      minWidth: 30,
                      child: Image.asset(
                        'assets/images/user-avatar.png',
                        width: 30,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.48,
                  margin: const EdgeInsets.only(bottom: 50),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Text(
                        'Choose a trip',
                        style: GoogleFonts.poppins().copyWith(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                          top: 5,
                          left: MediaQuery.of(context).size.width * 0.1,
                          right: MediaQuery.of(context).size.width * 0.1,
                          bottom: 10,
                        ),
                        height: 2,
                        color: const Color.fromRGBO(144, 144, 144, 0.35),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RawMaterialButton(
                            onPressed: null,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: 60,
                              padding: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6E6E6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    'assets/images/car-image.png',
                                    width: 30,
                                  ),
                                  Text(
                                    'Car',
                                    style: GoogleFonts.roboto(
                                        color: kPrimaryColor, fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                          ),
                          RawMaterialButton(
                            onPressed: null,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: 60,
                              padding: const EdgeInsets.only(
                                  top: 5, left: 10, right: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6E6E6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    'assets/images/bike-image.png',
                                    width: 30,
                                  ),
                                  Text(
                                    'Bike',
                                    style: GoogleFonts.roboto(
                                        color: kPrimaryColor, fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(
                          top: 5,
                          bottom: 10,
                        ),
                        height: 1,
                        color: const Color.fromRGBO(144, 144, 144, 0.35),
                      ),
                      RawMaterialButton(
                        onPressed: () {
                          openOriginPickupWidget();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(
                              Icons.location_searching,
                              color: kPrimaryColor,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.33,
                              height: 50,
                              child: Center(
                                child: Text(
                                  pickupPlaceName.isNotEmpty?pickupPlaceName:'Current Location  ',
                                  style: const TextStyle(
                                    color: kPrimaryColor,
                                    overflow: TextOverflow.clip
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(15)),
                              child: const Text(
                                'Change',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      RawMaterialButton(
                        onPressed: () {
                          openDestinationPickupWidget();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: kPrimaryColor,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.33,
                              height: 50,
                              child: Center(
                                child: Text(
                                  destinationPlaceName.isNotEmpty?destinationPlaceName:'Select Destination',
                                  style: const TextStyle(
                                      color: kPrimaryColor,
                                      overflow: TextOverflow.clip,
                                  ),

                                ),
                              ),
                            ),

                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(15)),
                              child: const Text(
                                'Change',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      Container(
                        height: 40,
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.05),
                        decoration: BoxDecoration(
                          color: Color(0xFFE6E6E6),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Offer Your fare',
                            contentPadding:
                                const EdgeInsets.only(top: 2, left: 5),
                            border: InputBorder.none,
                            suffixIconColor: kPrimaryColor,
                            hintStyle: GoogleFonts.roboto(
                                fontWeight: FontWeight.w400, fontSize: 12),
                            suffixIcon: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: FaIcon(
                                FontAwesomeIcons.pencilAlt,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      CustomButton(
                        onPressed: () {
                          print(_origin.toJson());
                          print(_destination.toJson());
                        },
                        backgroundColor: kPrimaryColor,
                        buttonText: 'Find a Driver',
                        margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.06,
                          right: MediaQuery.of(context).size.width * 0.06,
                          top: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: CustomBottomAppbar(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
