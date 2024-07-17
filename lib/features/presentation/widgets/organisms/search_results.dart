import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../config/theme/color.dart';
import '../../../../../config/theme/widgets/button.dart';
import '../../bloc/place_search/place_search_bloc.dart';
import '../../bloc/place_search/place_search_event.dart';
import '../../bloc/place_search/place_search_state.dart';
import '../atoms/location_list_tile.dart';

class SearchResults extends StatelessWidget {
  final String activeElement;
  final Function setActiveElement;
  final Function? setCoordinates;
  final Function setAddress;
  final Function getMyPosition;


  const SearchResults({
    Key ? key,
    required this.activeElement,
    required this.setActiveElement,
    this.setCoordinates,
    required this.setAddress,
    required this.getMyPosition,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            getMyPosition();
          },
          style: elevatedButtonThemeData.style?.copyWith(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(horizontal: 20, vertical: 20)),
            backgroundColor: MaterialStateProperty.all<Color>(surfaceColor),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.my_location,
                color: onSurfaceColor,
              ),
              SizedBox(width: 10),
              Text(
                'Utiliser ma position actuelle',
                style: TextStyle(
                  color: onSurfaceColor,
                ),
              ),
            ],
          ),
        ),
        BlocBuilder<PlaceSearchBloc, PlaceSearchState>(
          builder: (_,state){

            if(state is PlaceAutocompleteDone){
              return Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.placeSearchs!.length,
                    itemBuilder: (context, index) {
                      return LocationListTile(
                        press: () {
                          BlocProvider.of<PlaceSearchBloc>(context).add(GetPlaceDetails({
                            'fields': 'geometry,formatted_address,place_id,address_components',
                            'placeId': state.placeSearchs![index].placeId
                          }));
                          setAddress(state.placeSearchs![index].description ?? '');
                          setActiveElement('main');
                        },
                        location: state.placeSearchs![index].description ?? '',
                      );
                    },
                  )
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ]
    );
  }
}