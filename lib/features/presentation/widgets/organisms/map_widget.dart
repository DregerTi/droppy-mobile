import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:droppy/config/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/constants/constants.dart';
import '../../bloc/place_search/place_search_bloc.dart';
import '../../bloc/place_search/place_search_state.dart';

class MapWidget extends StatelessWidget {
  final MapController mapController;
  final bool userLocation;
  final Widget? markers;
  final bool hasSearchBar;
  final Function? onMapReady;
  final Stream<double?>? alignPositionStreamController;
  final AlignOnUpdate? alignPositionOnUpdate;
  final Function(MapCamera, bool)? onPositionChanged;
  final LatLng? initialCenter;

  MapWidget({
    Key ? key,
    required this.mapController,
    this.userLocation = false,
    this.markers,
    this.hasSearchBar = false,
    this.onMapReady,
    this.alignPositionStreamController,
    this.alignPositionOnUpdate,
    this.onPositionChanged,
    this.initialCenter
  }): super(key: key);

  final dio = Dio();
  final double initialZoom = 15.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity - kBottomNavigationBarHeight,
      width: double.infinity,
      child: FutureBuilder(
        future: getTemporaryDirectory(),
        builder: (context, snapshot){
          if (snapshot.hasData) {
            final dataPath = snapshot.requireData.path;
            return ClipRRect(
              borderRadius: BorderRadius.circular(46),
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  initialCenter: initialCenter ?? const LatLng(48.867633949382075, 2.3405098044043435),
                  initialZoom: initialZoom,
                  maxZoom: 25,
                  minZoom: 2,
                    interactionOptions: const InteractionOptions(
                      rotationThreshold: 0.0,
                    ),
                  onMapReady: () {
                    mapController.mapEventStream.listen((evt) {
                      if (onMapReady != null) {
                        onMapReady!(evt);
                      }
                    });
                  },
                  onPositionChanged: (MapCamera position, bool hasGesture){
                    onPositionChanged!(position, hasGesture);
                  }
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://api.mapbox.com/styles/v1/dregert/clsme7060002801qq9dqph3ub/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZHJlZ2VydCIsImEiOiJjbGRqeXV6dDUwaWR1M29uemg0MnlwaWh5In0.OOmby3d29Ahfgl4xqbUi5A',
                    additionalOptions: const {
                      'accessToken': mapBoxAccessToken,
                    },
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                    maxZoom: 20,
                    tileProvider: CachedTileProvider(
                      dio: dio,
                      maxStale: const Duration(days: 90),
                      store: HiveCacheStore(
                        '$dataPath${Platform.pathSeparator}HivacheStore',
                        hiveBoxName: 'HivacheStore',
                      ),
                    ),
                  ),
                  if(hasSearchBar) BlocListener<PlaceSearchBloc, PlaceSearchState>(
                    listener: (_,state){
                      if(state is PlaceDetailsDone){
                        mapController.move(LatLng(state.placeSearch!.lat, state.placeSearch!.lng), initialZoom);
                      }
                    },
                    child: const SizedBox(),
                  ),
                  if(markers != null) markers!,
                  if(userLocation
                    && alignPositionStreamController != null
                    && alignPositionOnUpdate != null) CurrentLocationLayer(
                    alignDirectionOnUpdate: AlignOnUpdate.never,
                    alignPositionStream: alignPositionStreamController,
                    alignPositionOnUpdate: alignPositionOnUpdate,
                    style: const LocationMarkerStyle(
                      headingSectorColor: secondaryColor,
                      marker: DefaultLocationMarker(
                        color: primaryColor,
                        child: Icon(
                          Icons.navigation,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                      markerSize: Size(26, 26),
                      markerDirection: MarkerDirection.heading,
                    ),
                  ),
                ]
              ),
            );
          }else{
            return const SizedBox();
          }
        },
      )
    );
  }
}