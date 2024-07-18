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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyAccountView extends StatelessWidget {
  final UserModel user;

  const MyAccountView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              AppBarWidget(
                leadingIcon: const Icon(Icons.arrow_back),
                title: AppLocalizations.of(context)!.myAccount,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, left: 30, right: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListItemsWidget(
                      title: AppLocalizations.of(context)!.myInformations,
                      children: [
                        TileItemWidget(
                          title: '${user.username}',
                          leadingImageUrl: user.avatar,
                          avatar: true,
                        ),
                        TileItemWidget(
                          title: AppLocalizations.of(context)!.email,
                          subtitle: user.email,
                        ),
                        TileItemWidget(
                            title: AppLocalizations.of(context)!.memberSince,
                            subtitle: DateTime.parse(
                                    BlocProvider.of<UsersBloc>(context)
                                        .state
                                        .me!
                                        .createdAt!)
                                .toLocal()
                                .toString()),
                      ],
                    ),
                    if (user.origin!.contains('Google') ||
                        user.origin!.contains('Apple'))
                      ListItemsWidget(
                        title: AppLocalizations.of(context)!.linkedAccounts,
                        children: [
                          if (user.origin!.contains('Google'))
                            TileItemWidget(
                              title: 'Google',
                              leadingIcon: Image.asset(
                                  'lib/assets/images/google.png',
                                  width: 20),
                            ),
                          if (user.origin!.contains('Apple'))
                            TileItemWidget(
                              title: 'Apple',
                              leadingIcon: SvgPicture.asset(
                                  'lib/assets/images/apple.svg',
                                  width: 20),
                            ),
                        ],
                      ),
                    const SizedBox(height: 28),
                    GestureDetector(
                      onTap: () => context
                          .pushNamed('update-account', extra: {'user': user}),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: surfaceColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .updateMyInformations,
                              style: textTheme.bodyMedium
                                  ?.copyWith(color: primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
