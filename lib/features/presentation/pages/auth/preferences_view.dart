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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PreferencesView extends StatelessWidget {
  final UserModel user;

  const PreferencesView({
    super.key,
    required this.user
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBarWidget(
            leadingIcon: const Icon(Icons.arrow_back),
            title: AppLocalizations.of(context)!.settings,
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
                          title: AppLocalizations.of(context)!.preferences,
                          children: [
                            TileItemWidget(
                              title: AppLocalizations.of(context)!.myAccount,
                              leadingImageUrl: user.avatar,
                              avatar: true,
                              onTap: () {
                                context.pushNamed(
                                    'my-account',
                                    extra: {
                                      'user': user
                                    }
                                );
                              },
                            ),
                            TileItemWidget(
                              title: AppLocalizations.of(context)!.preferredLanguages,
                              leadingIcon: const Icon(
                                Icons.language_rounded,
                                color: textColor
                              ),
                              onTap: () {
                                context.pushNamed(
                                    'language',
                                    extra: {
                                      'user': user
                                    }
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    ListItemsWidget(
                      title: AppLocalizations.of(context)!.about,
                      children: [
                        TileItemWidget(
                          title: 'CGU',
                          leadingIcon: const Icon(
                            Icons.document_scanner,
                            color: textColor,
                          ),
                          onTap: () {
                            context.pushNamed(
                                'cgu',
                                extra: {
                                  'user': user
                                }
                            );
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
                          borderRadius: BorderRadius.circular(16),
                          color: surfaceColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.logout,
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
  BlocProvider.of<AuthBloc>(context).add(const SignOut());
  context.go('/');
}