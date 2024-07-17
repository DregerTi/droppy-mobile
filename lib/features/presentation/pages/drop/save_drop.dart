import 'package:droppy/features/data/models/group.dart';
import 'package:droppy/features/presentation/bloc/drop/drop_bloc.dart';
import 'package:droppy/features/presentation/bloc/drop/drop_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/color.dart';
import '../../../../config/theme/widgets/button.dart';
import '../../../../config/theme/widgets/text.dart';
import '../../../../injection_container.dart';
import '../../../domain/entities/select_item.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/drop/drop_event.dart';
import '../../bloc/user/user_bloc.dart';
import '../../bloc/user/user_event.dart';
import '../../bloc/user/user_state.dart';
import '../../widgets/atoms/cached_image_widget.dart';
import '../../widgets/atoms/snack_bar.dart';
import '../../widgets/molecules/app_bar_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  List<int>? selectedItems = [];


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<UsersBloc>(
            create: (context) => sl()..add(GetMe({
              'id': BlocProvider.of<AuthBloc>(context).state.auth!.id,
            })),
          ),
          BlocProvider<DropsBloc>(
            create: (context) => sl(),
          ),
        ],
        child: Column(
          children: [
            AppBarWidget(
              leadingIcon: const Icon(Icons.arrow_back),
              title: 'Envoyer à...',
              actionWidget: BlocConsumer<DropsBloc, DropsState>(
                listener: (context, state) {
                  if(state is PostDropError) {
                    snackBarWidget(
                      message: AppLocalizations.of(context)!.loadingError,
                      context: context,
                      type: 'error',
                    );
                  }
                  if(state is PostDropDone) {
                    snackBarWidget(
                      message: 'Drop créé avec succès!',
                      context: context,
                    );
                    context.goNamed('home');
                  }
                },
                builder: (context, state) {
                  return IconButton(
                    icon: (state is PostDropLoading)
                        ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: Center(
                            child: CircularProgressIndicator()
                        )
                    )
                        : const Icon(Icons.check_rounded),
                    style: iconButtonThemeData.style?.copyWith(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    onPressed: () async {

                      if(widget.drop != null) {

                        Map<String, dynamic> data = widget.drop!;

                        if(selectedItems!.isNotEmpty) {
                          data['groups'] = selectedItems;
                        }

                        context.read<DropsBloc>().add(PostDrop(data));

                      } else {
                        snackBarWidget(
                          message: 'Erreur lors de la création du drop',
                          context: context,
                          type: 'error',
                        );
                      }
                    },
                  );
                },
              ),
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
                          if(state.me!.groups!.isNotEmpty) {

                            List<GroupModel> groups = state.me!.groups!;

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

                                Container(
                                  decoration: BoxDecoration(
                                    color: surfaceColor,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Column(
                                      children: selectItems.map((selectItem) {
                                        return ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              if(selectedItems!.contains(selectItem.value)) {
                                                selectedItems!.remove(selectItem.value);
                                              } else {
                                                selectedItems!.add(selectItem.value);
                                              }
                                            });
                                          },
                                          style: elevatedButtonThemeData.style?.copyWith(
                                            backgroundColor: MaterialStateProperty.all<Color>(
                                              selectedItems!.contains(selectItem.value) ? primaryColor : surfaceColor,
                                            ),
                                            foregroundColor: MaterialStateProperty.all<Color>(
                                              selectedItems!.contains(selectItem.value) ? backgroundColor : textColor,
                                            ),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(0),
                                              ),
                                            ),
                                            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(vertical: 20, horizontal: 20)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.only(right: 16),
                                                child: (selectItem.picture != null) ? CachedImageWidget(
                                                  borderRadius: BorderRadius.circular(12),
                                                  imageUrl: selectItem.picture ?? '',
                                                  height: 30,
                                                  width: 30,
                                                ) : ClipRRect(
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: SvgPicture.asset(
                                                    'lib/assets/images/avatar.svg',
                                                    height: 30,
                                                    width: 30,
                                                  ),
                                                ),
                                              ),
                                              if (selectItem.icon != null) Icon(
                                                selectItem.icon,
                                                color: selectedItems!.contains(selectItem.value) ? backgroundColor : textColor,
                                                size: 30,
                                              ),
                                              if (selectItem.icon != null) const SizedBox(width: 20),
                                              Text(
                                                  selectItem.label,
                                                  style: textTheme.titleSmall?.copyWith(
                                                    color: selectedItems!.contains(selectItem.value) ? backgroundColor : textColor,
                                                  )
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                )
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
    ),
    );
  }
}

void _signOut(BuildContext context) {
  BlocProvider.of<AuthBloc>(context).add(const SignOut());
  context.go('/');
}