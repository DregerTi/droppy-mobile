import 'dart:async';
import 'package:droppy/config/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:go_router/go_router.dart';
import '../../../../../injection_container.dart';
import '../../../../config/theme/widgets/text.dart';
import '../../bloc/place_search/place_search_bloc.dart';
import '../../bloc/place_search/place_search_event.dart';
import '../../widgets/atoms/cached_image_widget.dart';
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
    super.dispose();
    mapController.dispose();
    alignPositionStreamController.close();
    debounce?.cancel();
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: BlocProvider<PlaceSearchBloc>(
            create: (context) => sl(),
            child: Builder(
              builder: (BuildContext context) => _buildBody(context),
            ),
          )
      ),
    );
  }

  Widget _buildBody(BuildContext context){
    return SizedBox(
      height: MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight - 50,
      child: Stack(
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
          Container(
            height: 30,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: backgroundColor.withOpacity(0.8),
                  offset: const Offset(0, -15),
                  spreadRadius: 30,
                  blurRadius: 30,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: AppBarWidget(
              leadingIcon: const Icon(Icons.person_add),
              mainActionIcon: const Icon(Icons.notifications),
              mainActionOnPressed: () => context.goNamed('notifications'),
            ),
          ),
          Positioned(
            child: Padding(
              padding: const EdgeInsets.only(top: 34),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Map',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FloatingActionButton(
                          backgroundColor: onBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          onPressed: () {
                            setState(
                                  () => alignPositionOnUpdate = AlignOnUpdate.always,
                            );
                            alignPositionStreamController.add(18);
                          },
                          child: const Icon(
                            Icons.my_location,
                            color: onSurfaceColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: onBackgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(46)),
                    ),
                    height: (MediaQuery.of(context).size.width / 5.5) < 60 ? 140 : (MediaQuery.of(context).size.width / 5.5) + 70,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(width: 16);
                      },
                      itemCount: 8,
                      itemBuilder: (BuildContext context, int index) {
                        if(index == 0 || index == 7){
                          return const SizedBox(width: 14);
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CachedImageWidget(
                              borderRadius: BorderRadius.circular(16),
                              imageUrl: "https://pbs.twimg.com/media/F7_vMxKWAAAf9CV?format=jpg&name=4096x4096",
                              height: (MediaQuery.of(context).size.width / 5.5) < 60 ? 60 : MediaQuery.of(context).size.width / 5.5,
                              width: (MediaQuery.of(context).size.width / 5.5) < 60 ? 60 : MediaQuery.of(context).size.width / 5.5,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Moi ouei',
                              style: textTheme.labelSmall,
                            ),
                          ],
                        );
                      }
                    )
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}