import 'package:droppy/features/presentation/widgets/organisms/search_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/theme/color.dart';
import '../../../injection_container.dart';
import '../bloc/user/user_bloc.dart';
import '../widgets/molecules/app_bar_widget.dart';

class UsersView extends StatelessWidget {

  const UsersView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UsersBloc>(
      create: (context) => sl(),
      child: Scaffold(
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
                const AppBarWidget(
                  leadingIcon: Icon(Icons.arrow_back),
                ),
              ],
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: SearchUsers(),
              ),
            )
          ],
        ),
      ),
    );
  }
}