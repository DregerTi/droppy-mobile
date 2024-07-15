import 'package:droppy/features/presentation/bloc/pin_drop/pin_drop_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../../../injection_container.dart';
import '../../bloc/drop/drop_bloc.dart';
import '../../bloc/drop/drop_event.dart';
import '../../bloc/drop/drop_state.dart';
import '../../bloc/like/like_bloc.dart';
import '../../widgets/atoms/warning_card.dart';
import '../../widgets/organisms/drop_feed.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DropDetailsView extends HookWidget {
  final String dropId;
  final String username;

  const DropDetailsView({
    super.key,
    required this.dropId,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<DropsBloc>(
            create: (context) => sl()..add(GetDrop({
                'id': int.parse(dropId)
              }),
            ),
          ),
          BlocProvider<LikesBloc>(
            create: (context) => sl(),
          ),
        ],
        child: BlocConsumer<DropsBloc, DropsState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is DropDone) {
              return DropFeedWidget(drops: [state.drop]);
            } else if (state is DropError) {
              return Center(
                child: WarningCard(
                  message: AppLocalizations.of(context)!.loadingError,
                  icon: 'error',
                  onTap: () {
                    BlocProvider.of<DropsBloc>(context).add(GetDrop({
                      'id': int.parse(dropId)
                    }));
                  }
                ),
              );
            }
            return SizedBox(
              height: MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight - 30,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator()),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

}