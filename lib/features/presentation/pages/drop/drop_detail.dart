import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import '../../../../../injection_container.dart';
import '../../../../config/theme/color.dart';
import '../../../../config/theme/widgets/text.dart';
import '../../bloc/drop/drop_bloc.dart';
import '../../bloc/drop/drop_event.dart';
import '../../bloc/drop/drop_state.dart';
import '../../bloc/like/like_bloc.dart';
import '../../widgets/atoms/item_header.dart';
import '../../widgets/molecules/app_bar_widget.dart';
import '../../widgets/atoms/comment.dart';

class DropDetailsView extends HookWidget {
  final String dropId;

  const DropDetailsView({
    Key? key,
    required this.dropId,
  }) : super(key: key);

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
        child: BlocBuilder<DropsBloc, DropsState>(
          builder: (context, state) {
            if (state is DropDone) {
              return Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    top: 0,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [

                                AppBarWidget(
                                  leadingIcon: const Icon(Icons.arrow_back),
                                  secondaryActionIcon: const Icon(Icons.edit),
                                  secondaryActionOnPressed: () {
                                    context.goNamed(
                                      'proposal-form',
                                      pathParameters: {'dropId': BlocProvider.of<DropsBloc>(context).state.drop!.id.toString()},
                                    );
                                  },
                                  mainActionIcon: const Icon(Icons.flag_rounded),
                                  mainActionOnPressed: () async {
                                    final commentResult = await context.pushNamed<bool?>(
                                      'add-issue',
                                      pathParameters: {'dropId': BlocProvider.of<DropsBloc>(context).state.drop!.id.toString()},
                                    );
                                    if (commentResult != null && commentResult == true) {
                                      BlocProvider.of<DropsBloc>(context).add(GetDrop({
                                        'id': int.parse(dropId)
                                      }));
                                    }
                                  },
                                ),
                              ],
                            ),
                            _comments(context),
                            const SizedBox(height: 140),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is DropError) {
              return const Center(
                child: Text('Error'),
              );
            } else {
              return Column(
                children: [
                  const ItemHeader(
                    imageUrl: "",
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: const CircularProgressIndicator()
                    ),
                  ),
                ],
              );
            }
          },
        ),
),
    );
  }

  Widget _comments(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
          child: Container(
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Comment(
                  profilePicture: BlocProvider.of<DropsBloc>(context).state.drop!.comments!.first.user!.avatar ?? '',
                  username: '${BlocProvider.of<DropsBloc>(context).state.drop!.comments!.first.user!.firstname} ${BlocProvider.of<DropsBloc>(context).state.drop!.comments!.first.user!.lastname}',
                  message: BlocProvider.of<DropsBloc>(context).state.drop!.comments!.first.content ?? '',
                ),
              ],
            )
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Comment(
              commentId: BlocProvider.of<DropsBloc>(context).state.drop!.comments![index].id,
              onTap: () {
                if(BlocProvider.of<DropsBloc>(context).state.drop!.comments![index].user!.id != null){
                  context.goNamed(
                    'user-profile',
                    pathParameters: {
                      'userId': BlocProvider.of<DropsBloc>(context).state.drop!.comments![index].user!.id.toString(),
                      'dropId': BlocProvider.of<DropsBloc>(context).state.drop!.id.toString(),
                    }
                  );
                }
              },
              profilePicture: BlocProvider.of<DropsBloc>(context).state.drop!.comments![index].user!.avatar ?? '',
              username: '${BlocProvider.of<DropsBloc>(context).state.drop!.comments![index].user!.firstname} ${BlocProvider.of<DropsBloc>(context).state.drop!.comments![index].user!.lastname}',
              message: BlocProvider.of<DropsBloc>(context).state.drop!.comments![index].content ?? '',
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 36);
          },
          itemCount: BlocProvider.of<DropsBloc>(context).state.drop!.comments!.length,
        ),
      ],
    );
  }
}