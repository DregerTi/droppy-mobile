import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:go_router/go_router.dart';
import '../../../../../injection_container.dart';
import '../../bloc/place_search/place_search_bloc.dart';
import '../../bloc/place_search/place_search_event.dart';
import '../../widgets/molecules/app_bar_widget.dart';
import '../../widgets/organisms/map_widget.dart';

class DropMap extends StatefulWidget {

  const DropMap({Key? key}) : super(key: key);

  @override
  State<DropMap> createState() => _DropMapState();

}

class _DropMapState extends State<DropMap> {
  late final MapController mapController;

  String activeElement = 'main';
  TextEditingController searchFieldController = TextEditingController();
  late AlignOnUpdate alignPositionOnUpdate;
  late final StreamController<double?> alignPositionStreamController;
  Timer? debounce;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    alignPositionOnUpdate = AlignOnUpdate.never;
    alignPositionStreamController = StreamController<double?>();
  }

  @override
  void dispose() {
    mapController.dispose();
    alignPositionStreamController.close();
    debounce?.cancel();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider<PlaceSearchBloc>(
          create: (context) => sl(),
          child: Builder(
            builder: (BuildContext context) => _buildBody(context),
          ),
        )
    );
  }

  Widget _buildBody(BuildContext context){
    EdgeInsets devicePadding = MediaQuery.of(context).padding;
    return Stack(
      children: [
        MapWidget(
          mapController: mapController,
          userLocation: true,
          hasSearchBar: true,
          alignPositionStreamController: alignPositionStreamController.stream,
          alignPositionOnUpdate: alignPositionOnUpdate,
          onMapReady: (evt){
            setState(() {
              activeElement = 'main';
            });
            if (evt is MapEventMoveEnd) {
              BlocProvider.of<PlaceSearchBloc>(context).add(GetPlaceReverseGeocoding({
                'latlng': '${evt.camera.center.latitude},${evt.camera.center.longitude}',
              }));
            }
          },
          onPositionChanged: (position, hasGesture) {
            if (hasGesture && alignPositionOnUpdate != AlignOnUpdate.never) {
              setState(
                    () => alignPositionOnUpdate = AlignOnUpdate.never,
              );
            }
          },
        ),
        AppBarWidget(
          leadingIcon: const Icon(Icons.arrow_back),
          leadingOnPressed: () => context.pop(),
        ),

        Positioned(
          bottom: 200,
          left: 0,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          setState(
                                () => alignPositionOnUpdate = AlignOnUpdate.always,
                          );
                          alignPositionStreamController.add(18);
                        },
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}