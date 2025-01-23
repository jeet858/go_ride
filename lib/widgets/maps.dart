import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mappls_gl/mappls_gl.dart';
import 'package:go_ride/utils/polyline.dart';

class Maps extends StatefulWidget {
  final ReverseGeocodePlace? origin;
  final ReverseGeocodePlace? destination;
  const Maps({super.key, this.origin, this.destination});

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  static const String ACCESS_TOKEN = "";
  static const String REST_API_KEY = "";
  static const String ATLAS_CLIENT_ID =
      "";
  static const String ATLAS_CLIENT_SECRET =
      "";
  late MapplsMapController controller;
  late LatLng latlng;

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
  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(25.321684, 82.987289),
    zoom: 14.0,
  );

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

    // Get current location
    Position position = await Geolocator.getCurrentPosition();

    // Print the current location
    print(
        "Current Location: Latitude ${position.latitude}, Longitude ${position.longitude}");
    // controller.easeCamera(CameraUpdate.newLatLngZoom(
    //     LatLng(position.latitude, position.longitude), 14));
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
      isLoaded = true;
    });
    return position;
  }

  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return controller.addImage(name, list);
  }

  void addMarker(LatLng coordinates) async {
    if (markerCount == 0) {
      await addImageFromAsset("icon", "assets/images/custom-icon.png");
      controller.addSymbol(
          SymbolOptions(geometry: coordinates, iconImage: "icon", iconSize: 1));
      setState(() {
        markerCount += 1;
        originLatLng = coordinates;
      });
      print('in first marker');
    } else if (markerCount == 1) {
      await addImageFromAsset("car-icon", "assets/images/car-icon.png");
      controller.addSymbol(SymbolOptions(
          geometry: coordinates, iconImage: "car-icon", iconSize: 4));
      setState(() {
        markerCount += 1;
        destinationLatLng = coordinates;
      });
      callDirection(originLatLng, destinationLatLng);
      print('in second marker');
    } else {
      setState(() {
        markerCount = 0;

      });
      controller.clearSymbols();
      controller.clearLines();
      print('in third marker');
    }
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
    await addImageFromAsset("icon", "assets/images/custom-icon.png");
    await addImageFromAsset("car-icon", "assets/images/car-icon.png");
    var imageCounter = 1;
    controller.clearSymbols();
    controller.clearLines();
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
                SymbolOptions(geometry: element.location, iconImage: 'icon'),
              );
              imageCounter = 2;
            } else {
              symbols.add(
                SymbolOptions(
                    geometry: element.location,
                    iconImage: 'car-icon',
                    iconSize: 4),
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
    print('in it again');
    MapplsAccountManager.setMapSDKKey(ACCESS_TOKEN);
    MapplsAccountManager.setRestAPIKey(REST_API_KEY);
    MapplsAccountManager.setAtlasClientId(ATLAS_CLIENT_ID);
    MapplsAccountManager.setAtlasClientSecret(ATLAS_CLIENT_SECRET);
    if(widget.origin!=null){
      originLatLng = LatLng(widget.origin!.latitude!.toDouble(), widget.origin!.longitude!.toDouble());
    }
    if(widget.destination!=null){
      destinationLatLng=LatLng(widget.destination!.latitude!.toDouble(), widget.destination!.longitude!.toDouble());
    }
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded
        ? Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: MapplsMap(
              initialCameraPosition: _kInitialPosition,
              onMapCreated: (map) => {
                controller = map,
                controller.easeCamera(CameraUpdate.newLatLngZoom(
                    LatLng(currentLocation.latitude, currentLocation.longitude),
                    14)),
                addMarker(LatLng(
                    currentLocation.latitude, currentLocation.longitude)),
              },
              onMapClick: (lat, lng) async {
                print('latlng: $latlng');
                controller.easeCamera(CameraUpdate.newLatLngZoom(
                    LatLng(lng.latitude, lng.longitude), 14));
              },
              onMapLongClick: (point, mark) {
                addMarker(mark);
              },
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}

class ResourceList {
  final String value;
  final String text;

  ResourceList(this.value, this.text);
}
