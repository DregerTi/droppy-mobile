import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../../injection_container.dart';
import '../../../../config/theme/color.dart';
import '../../bloc/place_search/place_search_bloc.dart';
import '../../bloc/place_search/place_search_event.dart';
import '../../bloc/place_search/place_search_state.dart';
import '../../widgets/molecules/app_bar_widget.dart';
import '../../widgets/organisms/map_widget.dart';
import '../../widgets/organisms/search_results.dart';

class AddressPicker extends StatefulWidget {

  const AddressPicker({Key? key}) : super(key: key);

  @override
  State<AddressPicker> createState() => _AddressPickerState();

}

class _AddressPickerState extends State<AddressPicker> {
  late final MapController mapController;
  final DraggableScrollableController draggableScrollableController = DraggableScrollableController();
  String? mapAddress;
  String? pladeId;

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
            draggableScrollableController.animateTo(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease
            );
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
        BlocListener<PlaceSearchBloc, PlaceSearchState>(
          listener: (_,state){
            if(state is PlaceReverseGeocodingDone){
              setState(() {
                pladeId = state.placeSearch!.placeId;
                mapAddress = state.placeSearch!.formattedAddress;
                _updateSearchField(mapAddress!);
              });
            }
          },
          child: const SizedBox(),
        ),

        //pointer icon to lat long
        Positioned(
          child: Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 45),
                child: SvgPicture.asset('lib/assets/images/add-pin.svg', height: 60),
              )
          ),
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

        AnimatedPositioned(
          duration: const Duration(milliseconds: 460),
          top: activeElement == 'main' || activeElement == 'searchSection' ? 0 : MediaQuery.of(context).size.height - kBottomNavigationBarHeight,
          left: 0,
          right: 0,
          child: Container(
            height: MediaQuery.of(context).size.height - kBottomNavigationBarHeight,
            padding: devicePadding,
            child:DraggableScrollableSheet(
              minChildSize: 0.22,
              initialChildSize: 0.22,
              snapAnimationDuration: const Duration(milliseconds: 9000),
              controller: draggableScrollableController,
              builder: (context, scrollController) => Container(
                decoration: const BoxDecoration(
                  color: backgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 10,
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(26),
                    topRight: Radius.circular(26),
                  ),
                ),
                child: CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  controller: scrollController,
                  slivers: [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      foregroundColor: Colors.transparent,
                      backgroundColor: backgroundColor,
                      scrolledUnderElevation : 0,
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(26),
                          topRight: Radius.circular(26),
                        ),
                      ),
                      floating: false,
                      pinned: true,
                      expandedHeight: activeElement == 'main' ? 122 : 0,
                      flexibleSpace: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          return _searchHeader(context, debounce, searchFieldController);
                        },
                      ),
                    ),

                    SliverList(
                      delegate: SliverChildListDelegate([
                        Visibility(
                          visible: activeElement == 'searchSection',
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                            child: SearchResults(
                              activeElement: activeElement,
                              setActiveElement: (value) => setState(() => activeElement = value),
                              setAddress: (value) {
                                draggableScrollableController.animateTo(
                                    0,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease
                                );
                                _updateSearchField(value);
                              },
                              getMyPosition: () {
                                draggableScrollableController.animateTo(
                                    0,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease
                                );
                                setState(() {
                                      () => alignPositionOnUpdate = AlignOnUpdate.always;
                                  alignPositionStreamController.add(18);
                                  activeElement = 'main';
                                });
                              },
                            ),
                          ),
                        )
                      ]),
                    ),
                  ],
                ),
              ),
            ),

          ),
        ),
      ],
    );
  }

  _searchHeader(BuildContext context, Timer? debounce, TextEditingController searchFieldController){
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  child: TextFormField(
                    controller: searchFieldController,
                    textInputAction: TextInputAction.search,
                    onTap: () {
                      setState(() {
                        activeElement = 'searchSection';
                      });
                    },
                    onChanged: (input) {
                      if (debounce?.isActive ?? false) debounce?.cancel();
                      if (input.isNotEmpty) {
                        debounce = Timer(const Duration(milliseconds: 1000), () {
                          BlocProvider.of<PlaceSearchBloc>(context).add(GetPlaceAutocomplete({
                            'input': input,
                            'language': 'fr',
                          }));
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: 'Tu es où ?',
                      suffixIcon: Icon(Icons.search, color: onSurfaceColor, size: 20),
                    )
                  ),
                ),
              ),
            ],
          ),
          if(activeElement == 'main') const SizedBox(height: 20),
          if(activeElement == 'main') Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => {
                    context.pop(
                      {
                        'address': mapAddress,
                        'latlng': mapController.camera.center,
                      }
                    ),
                  },
                  child: const Text('Confirmer l\'adresse')
                )
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _updateSearchField(String address) {
    searchFieldController.text = address;
  }
}