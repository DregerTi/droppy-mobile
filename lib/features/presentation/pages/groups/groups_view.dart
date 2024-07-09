import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/color.dart';
import '../../widgets/atoms/cached_image_widget.dart';
import '../../widgets/molecules/app_bar_widget.dart';

class GroupsView extends StatefulWidget {

  const GroupsView({
    super.key,
  });

  @override
  State<GroupsView> createState() => _GroupsViewState();
}

class _GroupsViewState extends State<GroupsView> {
  TextEditingController searchFieldController = TextEditingController();
  Timer? debounce;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    debounce?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
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
              AppBarWidget(
                leadingIcon: const Icon(Icons.group_add),
                mainActionIcon: const Icon(Icons.notifications),
                mainActionOnPressed: () {
                  context.goNamed('notifications');
                },
              ),
              Positioned(
                child: Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Groups',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 26, right: 26, top: 20, bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    controller: searchFieldController,
                    textInputAction: TextInputAction.search,
                    onChanged: (input) {
                      if (debounce?.isActive ?? false) debounce?.cancel();
                      if (input.isNotEmpty) {
                        /*debounce = Timer(const Duration(milliseconds: 1000), () {
                            BlocProvider.of<PlaceSearchBloc>(context).add(GetPlaceAutocomplete({
                              'input': input,
                              'language': 'fr',
                            }));
                          });*/
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: 'Recherche',
                      suffixIcon: Icon(Icons.search, color: onSurfaceColor, size: 20),
                    )
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 6, right: 6),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 16,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CachedImageWidget(
                          borderRadius: BorderRadius.circular(16),
                          imageUrl: "https://pbs.twimg.com/media/F7_vMxKWAAAf9CV?format=jpg&name=4096x4096",
                          height: 50,
                          width: 50,
                        ),
                        title: Text(
                          'Les booss',
                          style: Theme.of(context).textTheme.titleMedium
                        ),
                        subtitle: const Text('Groupe de travail'),
                      );
                    },
                  )
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
}