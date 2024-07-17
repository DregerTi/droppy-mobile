import 'package:droppy/features/data/models/group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/color.dart';
import '../../../../config/theme/widgets/text.dart';
import '../../../data/models/user.dart';
import '../../../domain/entities/select_item.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/user/user_bloc.dart';
import '../../bloc/user/user_event.dart';
import '../../bloc/user/user_state.dart';
import '../../widgets/atoms/cached_image_widget.dart';
import '../../widgets/atoms/list_items_widget.dart';
import '../../widgets/atoms/tile_item_widget.dart';
import '../../widgets/molecules/app_bar_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widgets/molecules/select.dart';

class SaveDrop extends StatefulWidget {
  final Map<String, dynamic>? drop;

  const SaveDrop({
    super.key,
    this.drop
  });

  @override
  State<SaveDrop> createState() => _SaveDropState();
}

class _SaveDropState extends State<SaveDrop> {
  var selectedItem;


  @override
  Widget build(BuildContext context) {
    BlocProvider.of<UsersBloc>(context).add(GetMe({
      'id': BlocProvider.of<AuthBloc>(context).state.auth!.id,
    }));

    return Scaffold(
      body: Column(
        children: [
          AppBarWidget(
            leadingIcon: const Icon(Icons.arrow_back),
            title: 'Envoyer à...',
          ),
          Expanded(
            child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Mes amis',
                              style: textTheme.labelMedium?.copyWith(
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      BlocConsumer<UsersBloc, UsersState>(
                        listener: (BuildContext context, UsersState state) {},
                        builder: (_, state) {
                          if(state is MeDone){
                            if(BlocProvider.of<UsersBloc>(context).state.me!.groups!.isNotEmpty) {

                              List<GroupModel> groups = BlocProvider.of<UsersBloc>(context).state.me!.groups!;

                              List<SelectItemEntity> selectItems = groups.map((group) {
                                return SelectItemEntity(
                                  label : group.name ?? '',
                                  value : group.id ?? 0,
                                  picture: group.picturePath,
                                );
                              }).toList();

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Groupes',
                                    style: textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 20),
                                  Select(
                                    picture: true,
                                    isColumn: true,
                                    selectItems: selectItems,
                                    selectedItem: selectedItem,
                                    setSelectedItem: (value) {
                                      setState(() {
                                        selectedItem = value;
                                      });
                                    },
                                  ),
                                ],
                              );
                            }
                            return const SizedBox();

                          }
                          return const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }
}

void _signOut(BuildContext context) {
  BlocProvider.of<AuthBloc>(context).add(const SignOut());
  context.go('/');
}