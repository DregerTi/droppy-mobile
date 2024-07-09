import 'package:droppy/features/presentation/pages/drop/drop_detail.dart';
import 'package:droppy/features/presentation/pages/drop/drop_map.dart';
import 'package:droppy/features/presentation/pages/drop/feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/data/models/user.dart';
import '../../features/presentation/bloc/auth/auth_bloc.dart';
import '../../features/presentation/bloc/auth/auth_state.dart';
import '../../features/presentation/pages/account_view.dart';
import '../../features/presentation/pages/auth/language_settings.dart';
import '../../features/presentation/pages/comments/add_comment_report.dart';
import '../../features/presentation/pages/comments/add_comment_view.dart';
import '../../features/presentation/pages/animated_splash_screen_view.dart';
import '../../features/presentation/pages/auth/my_account_view.dart';
import '../../features/presentation/pages/auth/preferences_view.dart';
import '../../features/presentation/pages/auth/sign_in_view.dart';
import '../../features/presentation/pages/auth/sign_up_view.dart';
import '../../features/presentation/pages/auth/update_account_view.dart';
import '../../features/presentation/pages/drop/add_drop.dart';
import '../../features/presentation/pages/drop/add_drop_report.dart';
import '../../features/presentation/pages/drop/address_picker.dart';
import '../../features/presentation/pages/groups/groups_view.dart';
import '../../features/presentation/widgets/molecules/navigation_bar.dart';

class AppRoutes{
  AppRoutes._();

  static String initialRoute = '/animated-splash-screen';
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: initialRoute,
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: '/animated-splash-screen',
        name: 'animated-splash-screen',
        builder: (context, state) => const AnimatedSplashScreenView()
      ),
      GoRoute(
        path: '/sign-in',
        name: 'sign-in',
        builder: (context, state) => const SignInView(),
      ),
      GoRoute(
        path: '/sign-up',
        name: 'sign-up',
        builder: (context, state) => const SignUpView(),
      ),
      GoRoute(
        path: '/forget-password',
        name: 'forget-password',
        builder: (context, state) => const SignInView(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => Scaffold(
          body: child,
          bottomNavigationBar: const NavigationBarWidget(),
        ),
        routes: [
          GoRoute(
            redirect: (context, state) {
              if(BlocProvider.of<AuthBloc>(context).state is !AuthDone){
                return '/sign-in';
              }
            },
            path: '/',
            name: 'home',
            builder: (context, state) => const Feed(),
            routes: [
              GoRoute(
                path: 'add-drop',
                name: 'add-drop',
                builder: (context, state){
                  return const AddDropView();
                },
                routes: [
                  GoRoute(
                    path: 'address-picker',
                    name: 'address-picker',
                    builder: (context, state) => const AddressPicker(),
                  ),
                ]
              ),
              GoRoute(
                path: 'user-profile/:userId',
                name: 'user-profile',
                builder: (context, state) {
                  return AccountView(userId: state.pathParameters['userId']);
                },
              ),
              GoRoute(
                path: 'add-comment',
                name: 'feed-add-comment',
                builder: (context, state) => AddCommentView(toiletId: state.pathParameters['toiletId'] ?? ''),
              ),
              GoRoute(
                path: 'comment/:commentId/report',
                name: 'feed-comment-report',
                builder: (context, state) => AddCommentReportView(commentId: state.pathParameters['commentId'] ?? ''),
              ),
              GoRoute(
                path: 'drop/:dropId/report',
                name: 'feed-drop-report',
                builder: (context, state) => AddDropReportView(dropId: state.pathParameters['dropId'] ?? ''),
              ),
              GoRoute(
                  redirect: (context, state) {
                    if(BlocProvider.of<AuthBloc>(context).state is !AuthDone){
                      return '/sign-in';
                    }
                  },
                  path: 'map',
                  name: 'map',
                  builder: (context, state) => const DropMap(),
                  routes: [
                    GoRoute(
                        path: 'drop/:dropId',
                        name: 'drop',
                        builder: (context, state) {
                          return DropDetailsView(dropId: state.pathParameters['dropId'] ?? '');
                        },
                        routes:[
                          GoRoute(
                            path: 'add-comment',
                            name: 'drop-add-comment',
                            builder: (context, state) => AddCommentView(toiletId: state.pathParameters['toiletId'] ?? ''),
                          ),
                          GoRoute(
                            path: 'comment/:commentId/report',
                            name: 'drop-comment-report',
                            builder: (context, state) => AddCommentReportView(commentId: state.pathParameters['commentId'] ?? ''),
                          ),
                          GoRoute(
                            path: 'drop/:dropId/report',
                            name: 'drop-drop-report',
                            builder: (context, state) => AddDropReportView(dropId: state.pathParameters['dropId'] ?? ''),
                          ),
                        ]
                    ),
                  ]
              ),
              GoRoute(
                  redirect: (context, state) {
                    if(BlocProvider.of<AuthBloc>(context).state is !AuthDone){
                      return '/sign-in';
                    }
                  },
                  path: 'goups',
                  name: 'groups',
                  builder: (context, state) => const GroupsView(),
                  routes: [
                    GoRoute(
                      path: 'add-group',
                      name: 'add-group',
                      builder: (context, state) => const SignUpView(),
                      //builder: (context, state) => const AddGroupView(),
                    ),
                    GoRoute(
                      path: 'group/:groupId/setting',
                      name: 'group-setting',
                      builder: (context, state) => const SignUpView(),
                      //builder: (context, state) => const GroupSettingView(),
                    ),
                    GoRoute(
                        path: 'group/:groupId',
                        name: 'group',
                        builder: (context, state) => const SignUpView(),
                        /*builder: (context, state) {
                          return GroupView(groupId: state.pathParameters['groupId']);
                        },*/
                        routes: [
                          GoRoute(
                            path: 'add-comment',
                            name: 'group-add-comment',
                            builder: (context, state) => AddCommentView(toiletId: state.pathParameters['toiletId'] ?? ''),
                          ),
                          GoRoute(
                            path: 'comment/:commentId/report',
                            name: 'group-comment-report',
                            builder: (context, state) => AddCommentReportView(commentId: state.pathParameters['commentId'] ?? ''),
                          ),
                          GoRoute(
                            path: 'drop/:dropId/report',
                            name: 'group-drop-report',
                            builder: (context, state) => AddDropReportView(dropId: state.pathParameters['dropId'] ?? ''),
                          ),
                        ]
                    ),
                  ]
              ),
              GoRoute(
                  path: 'account',
                  name: 'account',
                  builder: (context, state) => const AccountView(),
                  routes: [
                    GoRoute(
                        path: 'preferences',
                        name: 'preferences',
                        builder: (context, state) {
                          final Map<String, dynamic>? extras = state.extra as Map<String, dynamic>?;
                          final UserModel user = extras?['user'];
                          return PreferencesView(user: user);
                        },
                        routes: [
                          GoRoute(
                              path: 'my-account',
                              name: 'my-account',
                              builder: (context, state) {
                                final Map<String, dynamic>? extras = state.extra as Map<String, dynamic>?;
                                final UserModel user = extras?['user'];
                                return MyAccountView(user: user);
                              },
                              routes: [
                                GoRoute(
                                  path: 'update-account',
                                  name: 'update-account',
                                  builder: (context, state) {
                                    final Map<String, dynamic>? extras = state.extra as Map<String, dynamic>?;
                                    final UserModel user = extras?['user'];
                                    return UpdateAccountView(user: user);
                                  },
                                ),
                              ]
                          ),
                          GoRoute(
                            path: 'language',
                            name: 'language',
                            builder: (context, state) {
                              final Map<String, dynamic>? extras = state.extra as Map<String, dynamic>?;
                              final UserModel user = extras?['user'];
                              return LanguageSettings(user: user);
                            },
                          ),
                          GoRoute(
                            path: 'cgus',
                            name: 'cgus',
                            builder: (context, state) => const SignInView(),
                          ),
                        ]
                    ),
                  ]
              ),
            ]
          ),
        ]
      ),
    ],
  );
}