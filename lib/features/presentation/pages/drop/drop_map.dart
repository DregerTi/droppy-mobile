import 'dart:async';
import 'package:droppy/config/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../../../config/theme/widgets/text.dart';
import '../../bloc/feed/feed_bloc.dart';
import '../../bloc/feed/feed_event.dart';
import '../../bloc/feed/feed_state.dart';
import '../../widgets/atoms/cached_image_widget.dart';
import '../../widgets/atoms/warning_card.dart';
import '../../widgets/molecules/app_bar_widget.dart';
import '../../widgets/organisms/map_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DropMap extends StatefulWidget {

  const DropMap({Key? key}) : super(key: key);

  @override
  State<DropMap> createState() => _DropMapState();

}

class _DropMapState extends State<DropMap> {
  late final MapController mapController;

  String activeElement = 'main';
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
          body: Builder(
            builder: (BuildContext context) => _buildBody(context),
          )
      ),
    );
  }

  Widget _buildBody(BuildContext context){
    return SizedBox(
      height: MediaQuery.of(context).size.height - 50,
      child: Stack(
        children: [
          MapWidget(
            mapController: mapController,
            userLocation: true,
            hasSearchBar: false,
            alignPositionStreamController: alignPositionStreamController.stream,
            alignPositionOnUpdate: alignPositionOnUpdate,
            onMapReady: (evt){
              setState(() {
                activeElement = 'main';
              });
              if (evt is MapEventMoveEnd) {

              }
            },
            onPositionChanged: (position, hasGesture) {
              if (hasGesture && alignPositionOnUpdate != AlignOnUpdate.never) {
                setState(
                      () => alignPositionOnUpdate = AlignOnUpdate.never,
                );
              }
            },
            markers: BlocConsumer<FeedBloc, FeedState>(
              listener: (context, state) {},
              builder: (_,state){
                if(state.drops != null && state.drops!.isNotEmpty) {
                  return MarkerClusterLayerWidget(
                    options: MarkerClusterLayerOptions(
                      maxClusterRadius: 45,
                      size: const Size(40, 40),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(50),
                      maxZoom: 15,
                      markers: state.drops!.map((drops) => Marker(
                        point: LatLng(drops.lat!, drops.lng!),
                        width: 75.0,
                        height: 75.0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              context.pushNamed(
                                'drop-from-map',
                                pathParameters: {
                                  'dropId': drops.id.toString(),
                                  'username': drops.user!.username ?? '',
                                },
                              );
                            });
                            mapController.move(LatLng(drops.lat! - 0.002, drops.lng!), 15.0);
                          },
                          child: Stack(
                            children: [
                              SizedBox(
                                width: 75,
                                child: Center(
                                  child: Icon(
                                    Icons.location_on,
                                    color: primaryColor,
                                    size: 75,
                                    shadows: [
                                      Shadow(
                                        color: secondaryColor.withOpacity(0.9),
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 7,
                                right: 7,
                                bottom: 14,
                                child: Container(
                                  width: 38,
                                  height: 38,
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(19),
                                  ),
                                  child: (drops.picturePath != null)
                                      ? CachedImageWidget(
                                    imageUrl: drops.picturePath!,
                                    borderRadius: BorderRadius.circular(18),
                                    height: 38,
                                    width: 38,
                                  ) : ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: SvgPicture.asset(
                                      'lib/assets/images/avatar.svg',
                                      height: 38,
                                      width: 38,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )).toList(),
                      builder: (context, markers) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: primaryColor,
                            boxShadow: [
                              BoxShadow(
                                color: secondaryColor.withOpacity(0.9),
                                blurRadius: 5,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              markers.length.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
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
              mainActionIcon: const Icon(Icons.notifications_rounded),
              isMainActionActive: true,
              mainActionOnPressed: () => context.pushNamed('notification'),
            ),
          ),
          Positioned(
            child: Padding(
              padding: const EdgeInsets.only(top: 34),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.map,
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
                    child: BlocConsumer<FeedBloc, FeedState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        if(state is WebSocketDisconnected) {
                          return Center(
                            child: WarningCard(
                                message: AppLocalizations.of(context)!.noDrops,
                                icon: 'empty'
                            ),
                          );
                        }

                        if(state is WebSocketMessageState || state is WebSocketMessageReceived) {
                          if(state.drops!.isEmpty) {
                            return Center(
                              child: WarningCard(
                                  message: AppLocalizations.of(context)!.noDrops,
                              ),
                            );
                          }

                          return ListView.separated(
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (BuildContext context, int index) {
                              return const SizedBox(width: 16);
                            },
                            itemCount: state.drops!.length + 1,
                            itemBuilder: (BuildContext context, int index) {
                              if(index == 0 || index == 7){
                                return const SizedBox(width: 14);
                              }
                              return GestureDetector(
                                onTap: (){
                                  mapController.move(LatLng(state.drops![index - 1].lat! - 0.001, state.drops![index - 1].lng!), 15.0);
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if(state.drops![index - 1].user!.avatar != null) CachedImageWidget(
                                      borderRadius: BorderRadius.circular(20),
                                      imageUrl: state.drops![index - 1].user!.avatar!,
                                      height: (MediaQuery.of(context).size.width / 5.5) < 60 ? 60 : MediaQuery.of(context).size.width / 5.5,
                                      width: (MediaQuery.of(context).size.width / 5.5) < 60 ? 60 : MediaQuery.of(context).size.width / 5.5,
                                    ) else ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: SvgPicture.asset(
                                        'lib/assets/images/avatar.svg',
                                        height: (MediaQuery.of(context).size.width / 5.5) < 60 ? 60 : MediaQuery.of(context).size.width / 5.5,
                                        width: (MediaQuery.of(context).size.width / 5.5) < 60 ? 60 : MediaQuery.of(context).size.width / 5.5,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      state.drops![index - 1].user!.username!,
                                      style: textTheme.labelSmall,
                                    ),
                                  ],
                                ),
                              );
                            }
                          );
                        }

                        return const SizedBox(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(child: CircularProgressIndicator()),
                            ],
                          ),
                        );
                      },
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