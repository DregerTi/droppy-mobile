import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/theme/color.dart';
import '../../../../config/theme/widgets/text.dart';
import '../../../data/models/user.dart';
import '../../bloc/user/user_bloc.dart';
import '../../widgets/atoms/list_items_widget.dart';
import '../../widgets/atoms/tile_item_widget.dart';
import '../../widgets/molecules/app_bar_widget.dart';

class MyAccountView extends StatelessWidget {
  final UserModel user;

  const MyAccountView({
    Key? key,
    required this.user
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppBarWidget(
            leadingIcon: Icon(Icons.arrow_back),
            title: 'Mon compte',
          ),
          SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(top: 12, left: 30, right: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListItemsWidget(
                      title: 'Mes informations',
                      children: [
                        TileItemWidget(
                          title: '${user.username}',
                          leadingImageUrl: user.avatar ?? '',
                        ),
                        TileItemWidget(
                          title: 'Email',
                          subtitle: user.email,
                        ),
                        TileItemWidget(
                          title: 'Membre depuis le',
                          subtitle: BlocProvider.of<UsersBloc>(context).state.me?.email ?? '12/12/2021',
                        ),
                      ],
                    ),
                    ListItemsWidget(
                      title: 'Compte lié',
                      children: [
                        TileItemWidget(
                          title: 'Google',
                          leadingIcon: Image.asset(
                              'lib/assets/images/google.png',
                              width: 20
                          ),
                        ),
                        TileItemWidget(
                          title: 'Apple',
                          leadingIcon: SvgPicture.asset(
                              'lib/assets/images/apple.svg',
                              width: 20
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    GestureDetector(
                      onTap: () => context.goNamed(
                          'update-account',
                          extra: {
                            'user': user
                          }
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: surfaceColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Modifier mes informations',
                              style: textTheme.bodyMedium?.copyWith(
                                  color: primaryColor
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    GestureDetector(
                      onTap: () => _signOut(context),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: surfaceColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Supprimer mon compte',
                              style: textTheme.bodyMedium?.copyWith(
                                  color: errorColor
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }
}


void _signOut(BuildContext context) {

  context.go('/');
}