import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../injection_container.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../bloc/user/user_event.dart';
import '../bloc/user/user_state.dart';
import '../widgets/atoms/item_header.dart';
import '../widgets/molecules/app_bar_widget.dart';

class AccountView extends StatefulWidget {
  final String? userId;

  const AccountView({
    Key? key,
    this.userId
  }) : super(key: key);

  @override
  State<AccountView> createState() => _AccountViewState();

}

class _AccountViewState extends State<AccountView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<UsersBloc>(
          create: (context) => sl()..add(
              widget.userId != null ? GetUser({
                'id':int.parse(widget.userId ?? '')
              })
              : GetMe({
                'id': BlocProvider.of<AuthBloc>(context).state.auth?.id
              }
            )
          ),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                Stack(
                  children: [
                    BlocBuilder<UsersBloc , UsersState>(
                      builder: (context, state) {
                        if (state is UserDone || state is MeDone) {
                          return
                            ItemHeader(
                              imageUrl: widget.userId != null ? state.user!.avatar : state.me?.avatar,
                              title: widget.userId != null ? '${state.user?.firstname} ${state.user?.lastname}' : '${state.me?.firstname} ${state.me?.lastname}',
                            );
                        }
                        return Column(
                          children: [
                            const ItemHeader(
                              imageUrl: '',
                            ),
                            Container(
                              padding: const EdgeInsets.all(60),
                              child: const CircularProgressIndicator(),
                            ),
                          ],
                        );
                      },
                    ),
                    BlocBuilder<UsersBloc, UsersState>(
                      builder: (context, state) {
                        return AppBarWidget(
                          leadingIcon: widget.userId != null ? const Icon(Icons.arrow_back) : null,
                          leadingOnPressed: () {
                            context.pop();
                          },
                          mainActionIcon: widget.userId == null ? const Icon(Icons.settings) : null,
                          mainActionOnPressed: () {
                            if(state is MeDone) {
                              context.goNamed(
                                'preferences',
                                extra: {
                                  'user': state.me,
                                },
                              );
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
                BlocBuilder<UsersBloc , UsersState>(
                  builder: (context, state) {
                    if (state is UserDone || state is MeDone) {
                      return _buildBody(context);
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          )
      ),
    );
  }

   Widget _buildBody(context) {
    return const SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        children: [

        ],
      ),
    );
  }

}