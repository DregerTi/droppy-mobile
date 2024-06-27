import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/color.dart';
import '../../../../config/theme/widgets/text.dart';
import '../../../data/models/user.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/user/user_bloc.dart';
import '../../bloc/user/user_state.dart';
import '../../widgets/atoms/list_items_widget.dart';
import '../../widgets/atoms/tile_item_widget.dart';
import '../../widgets/molecules/app_bar_widget.dart';

class PreferencesView extends StatelessWidget {
  final UserModel user;

  const PreferencesView({
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
            title: 'Réglages',
          ),
          SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(top: 12, left: 30, right: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<UsersBloc , UsersState>(
                      builder: (context, state) {
                        return ListItemsWidget(
                          title: 'Préférences',
                          children: [
                            TileItemWidget(
                              title: 'Mon compte',
                              leadingImageUrl: user.avatar! ?? '',
                              onTap: () {
                                context.goNamed(
                                  'my-account',
                                  extra: {
                                    'user': user
                                  }
                                );
                              },
                            ),
                            TileItemWidget(
                              title: 'Partager mon profil',
                              leadingIcon: const Icon(Icons.share_rounded),
                              onTap: () {

                              },
                            ),
                          ],
                        );
                      },
                    ),
                    ListItemsWidget(
                      title: 'À propos',
                      children: [
                        TileItemWidget(
                          title: 'Partager Droppy',
                          leadingIcon: const Icon(Icons.share_rounded),
                          onTap: () {

                          },
                        ),
                        TileItemWidget(
                          title: 'Noter Droppy',
                          leadingIcon: const Icon(Icons.star_rate_rounded),
                          onTap: () {

                          },
                        ),
                        TileItemWidget(
                          title: 'Conditions Générales d\'Utilisation',
                          leadingIcon: const Icon(Icons.document_scanner),
                          onTap: () {

                          },
                        ),
                      ],
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
                              'Se déconnecter',
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

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 12, left: 30, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(BlocProvider.of<UsersBloc>(context).state.me?.avatar ?? 'jkjjkj'),
            BlocBuilder<UsersBloc , UsersState>(
              builder: (context, state) {
                return ListItemsWidget(
                  title: 'Préférences',
                  children: [
                    TileItemWidget(
                      title: 'Mon compte ${state is MeDone ? BlocProvider.of<UsersBloc>(context).state.me?.firstname : 'fdp'}',
                      leadingImageUrl: BlocProvider.of<UsersBloc>(context).state.me?.avatar,
                      onTap: () {

                          context.goNamed('my-account');
                      },
                    ),
                    TileItemWidget(
                      title: 'Partager mon profil',
                      leadingIcon: const Icon(Icons.share_rounded),
                      onTap: () {

                      },
                    ),
                  ],
                );
              },
            ),
            ListItemsWidget(
              title: 'À propos',
              children: [
                TileItemWidget(
                  title: 'Partager Droppy',
                  leadingIcon: const Icon(Icons.share_rounded),
                  onTap: () {

                  },
                ),
                TileItemWidget(
                  title: 'Noter Droppy',
                  leadingIcon: const Icon(Icons.star_rate_rounded),
                  onTap: () {

                  },
                ),
                TileItemWidget(
                  title: 'Conditions Générales d\'Utilisation',
                  leadingIcon: const Icon(Icons.document_scanner),
                  onTap: () {

                  },
                ),
              ],
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
                        'Se déconnecter',
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
    );
  }
}

void _signOut(BuildContext context) {
  BlocProvider.of<AuthBloc>(context).add(const SignOut());
  context.go('/');
}