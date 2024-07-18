import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../injection_container.dart';
import '../../../../config/theme/color.dart';
import '../../../data/models/place_search_details.dart';
import '../../bloc/place_search/place_search_bloc.dart';
import '../../bloc/place_search/place_search_event.dart';
import '../../bloc/place_search/place_search_state.dart';
import '../../widgets/molecules/app_bar_widget.dart';
import '../../widgets/organisms/map_widget.dart';
import '../../widgets/organisms/search_results.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddressPicker extends StatefulWidget {

  final Map<String, dynamic>? address;

  const AddressPicker({
    Key? key,
    this.address,
  }) : super(key: key);

  @override
  State<AddressPicker> createState() => _AddressPickerState();

}

class _AddressPickerState extends State<AddressPicker> {
  late final MapController mapController;
  final DraggableScrollableController draggableScrollableController = DraggableScrollableController();
  PlaceSearchDetailsModel? mapAddress;
  String? placeId;

  String activeElement = 'main';
  TextEditingController searchFieldController = TextEditingController();
  late AlignOnUpdate alignPositionOnUpdate;
  late final StreamController<double?> alignPositionStreamController;
  Timer? debounce;
  LatLng? initialCenter;

  void _checkInitPosition() async {
    if(widget.address!.isNotEmpty) {
      initialCenter = LatLng(widget.address!['lat'], widget.address!['lng']);
    }
  }

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    alignPositionOnUpdate = AlignOnUpdate.never;
    alignPositionStreamController = StreamController<double?>();
    if(widget.address!.isNotEmpty){
      searchFieldController.text = '${widget.address!['address']} ${widget.address!['city']} ${widget.address!['zipCode']} ${widget.address!['country']}';
      _checkInitPosition();
      mapAddress = PlaceSearchDetailsModel(
        lat: widget.address!['lat'],
        lng: widget.address!['lng'],
        formattedAddress: widget.address!['address'],
        country: widget.address!['country'],
        zipCode: widget.address!['zipCode'],
        city: widget.address!['city'],
        placeId: '',
      );
    }
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
          initialCenter: initialCenter,
          mapController: mapController,
          userLocation: true,
          hasSearchBar: true,
          alignPositionStreamController: alignPositionStreamController.stream,
          alignPositionOnUpdate: alignPositionOnUpdate,
          onMapReady: (evt){
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
                placeId = state.placeSearch!.placeId;
                mapAddress = state.placeSearch!;
                _updateSearchField('${mapAddress?.formattedAddress} ${mapAddress?.city ?? ''} ${mapAddress?.zipCode ?? ''} ${mapAddress?.country ?? ''}');
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
        ),

        AnimatedPositioned(
          duration: const Duration(milliseconds: 460),
          top: activeElement == 'main' || activeElement == 'searchSection' ? 0 : MediaQuery.of(context).size.height - kBottomNavigationBarHeight,
          left: 0,
          right: 0,
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: devicePadding,
            child:DraggableScrollableSheet(
              minChildSize: 0.36,
              initialChildSize: 0.36,
              snapAnimationDuration: const Duration(milliseconds: 9000),
              controller: draggableScrollableController,
              builder: (context, scrollController) => Container(
                decoration: const BoxDecoration(
                  color: backgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      spreadRadius: 1,
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(46),
                    topRight: Radius.circular(46),
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
                          topLeft: Radius.circular(46),
                          topRight: Radius.circular(46),
                        ),
                      ),
                      floating: false,
                      pinned: true,
                      expandedHeight: activeElement == 'main' ? 200 : 100,
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
                        draggableScrollableController.animateTo(
                            1,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease
                        );
                        setState(() {
                          activeElement = 'searchSection';
                        });
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
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.whereAreYou,
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
                        'address': mapAddress?.formattedAddress ?? '',
                        'city': mapAddress?.city ?? '',
                        'country': mapAddress?.country ?? '',
                        'zipCode': mapAddress?.zipCode ?? '',
                        'lat': mapController.camera.center.latitude,
                        'lng': mapController.camera.center.longitude,
                      }
                    ),
                  },
                  child: Text(AppLocalizations.of(context)!.confirmAddress)
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