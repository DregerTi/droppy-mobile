import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:droppy/features/presentation/widgets/atoms/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/theme/color.dart';
import '../../../../config/theme/widgets/text.dart';
import '../../../../injection_container.dart';
import '../../../data/models/content.dart';
import '../../../domain/entities/form_section_item.dart';
import '../../../domain/entities/media_picker_item.dart';
import '../../bloc/content/content_bloc.dart';
import '../../bloc/group/goup_bloc.dart';
import '../../widgets/atoms/cached_image_widget.dart';
import '../../widgets/molecules/app_bar_widget.dart';
import '../../widgets/molecules/content_sheet.dart';
import '../../widgets/molecules/media_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class AddDropView extends StatefulWidget {

  const AddDropView({
    super.key,
  });

  @override
  State<AddDropView> createState() => _AddDropViewState();
}

class _AddDropViewState extends State<AddDropView> {
  String activeElement = 'main';
  String? description;
  List<MediaPickerItemEntity> selectedMedias = [];
  Map<String, dynamic> address = {};
  ContentModel? content;
  bool isValide = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          _buildForm(),
        ],
      ),
    );
  }

  Widget _buildForm(){

    return MultiBlocProvider(
      providers: [
        BlocProvider<GroupsBloc>(
          create: (context) => sl(),
        ),
      ],
      child: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 76,
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 76,
                decoration: BoxDecoration(
                  color: (activeElement == 'main') ? onBackgroundColor : backgroundColor,
                  borderRadius: BorderRadius.circular(46),
                ),
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height - 76,
                      width: MediaQuery.of(context).size.width,
                      child: MediaPickerWidget(
                        isPostDrop: true,
                        maxMedias: 1,
                        activeElement: activeElement,
                        setActiveElement: (value) {
                          setState(() {
                            activeElement = value;
                          });
                        },
                        setSelectedMedias: (value) {
                          setState(() {
                            selectedMedias = value;
                          });
                        },
                        selectedMedias: [],
                      ),
                    ),
                    if(activeElement == 'main') Positioned(
                      bottom: 0,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 26),
                          decoration: BoxDecoration(
                            color: onSurfaceColor,
                            borderRadius: BorderRadius.circular(46),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              final result = await context.pushNamed<Map<String, dynamic>>(
                                                'address-picker',
                                                extra: {
                                                  'address': address,
                                                },
                                              );
                                              if (result != null) {
                                                setState(() {
                                                  address = result;
                                                });
                                              }
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: surfaceColor,
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                      Icons.location_on,
                                                      color: onPrimaryColor,
                                                      size: 16
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    (address['city'] != null) ? '${address['city'] ?? ''}, ${address['country'] ?? ''}' : AppLocalizations.of(context)!.location,
                                                    style: textTheme.labelSmall?.copyWith(color: onPrimaryColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              _openDescriptionSheet(context, (value) {
                                                setState(() {
                                                  description = value;
                                                });
                                              }, description);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: surfaceColor,
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                      Icons.text_fields_rounded,
                                                      color: onPrimaryColor,
                                                      size: 16
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    AppLocalizations.of(context)!.description,
                                                    style: textTheme.labelSmall?.copyWith(color: onPrimaryColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context).size.width - 56,
                                            child: Text(
                                              description ?? '',
                                              maxLines : 2,
                                              overflow : TextOverflow.ellipsis,
                                              style: textTheme.bodySmall,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  GestureDetector(
                                    onTap: () {
                                      print('open content sheet');
                                      _openContentSheet(context, (value) {
                                        setState(() {
                                          content = value;
                                        });
                                      });
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width - 56,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          if(content?.picturePath != null) CachedImageWidget(
                                            width: 56,
                                            height: 56,
                                            borderRadius: BorderRadius.circular(16),
                                            imageUrl: content?.picturePath ?? '',
                                          ) else Container(
                                            width: 56,
                                            height: 56,
                                            decoration: BoxDecoration(
                                              color: surfaceColor,
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.add_rounded,
                                                color: onPrimaryColor,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                content?.title ?? AppLocalizations.of(context)!.content,
                                                style: textTheme.titleMedium,
                                                maxLines : 2,
                                                overflow : TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                content?.subtitle ?? '',
                                                style: textTheme.bodySmall,
                                                maxLines : 2,
                                                overflow : TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if(activeElement == 'main') Container(
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
              if(activeElement == 'main') Padding(
                padding: const EdgeInsets.only(top: 24),
                child: AppBarWidget(
                  leadingIcon: const Icon(Icons.arrow_back_rounded),
                  leadingOnPressed: () => {
                    context.pop()
                  },
                  mainActionIcon: const Icon(Icons.arrow_forward_rounded),
                  isMainActionActive: true,
                  mainActionOnPressed: () async {
                    if(description != null && (description!.length < 5 || description!.length > 120)){
                      setState(() {
                        isValide = false;
                      });

                      snackBarWidget(
                        message: AppLocalizations.of(context)!.descriptionBetween5And120CharactersOrEmpty,
                        context: context,
                        type: 'error',
                      );

                      setState(() {
                        isValide = false;
                      });
                    }

                    if(content == null) {
                      snackBarWidget(
                        message: AppLocalizations.of(context)!.pleaseSelectContent,
                        context: context,
                        type: 'error',
                      );

                      setState(() {
                        isValide = false;
                      });
                    }

                    if(selectedMedias.isEmpty){
                      snackBarWidget(
                        message: AppLocalizations.of(context)!.pleaseSelectAnImage,
                        context: context,
                        type: 'error',
                      );

                      setState(() {
                        isValide = false;
                      });
                    }

                    if(isValide){

                      Object picture = await MultipartFile.fromFile((await selectedMedias[0].assetEntity!.file!)!.path);

                      Map<String, dynamic> data = {
                        'picture': picture,
                        'contentPicturePath': content?.picturePath,
                        'contentTitle': content?.title,
                        'contentSubtitle': content?.subtitle,
                        'content': content?.content,
                      };

                      if(description != null) data['description'] = description;

                      if(address.isNotEmpty) {
                        data['lat'] = address['lat'];
                        data['lng'] = address['lng'];
                        data['location'] = '${address['city']}, ${address['country']}';
                      }

                      context.pushNamed<Map<String, dynamic>>(
                        'save-drop',
                        extra: {
                          'drop': data,
                        },
                      );
                    }


                    setState(() {
                      isValide = true;
                    });

                  },
                ),
              ),
              if(activeElement == 'main') Positioned(
                child: Padding(
                  padding: const EdgeInsets.only(top: 34),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 230,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Poster un Drop',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }

  void _openContentSheet(context, setContent){
    print('open content sddheet');
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(46),
          topRight: Radius.circular(46),
        ),
      ),
      context: context,
      //isScrollControlled: true,
      builder: (context) => ContentSheet(setContent: setContent),
    );
  }

  void _openDescriptionSheet(context, setDescription, description){
    print('open description sheet');

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(46),
          topRight: Radius.circular(46),
        ),
      ),
      context: context,
      //isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 26),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(46),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
                AppLocalizations.of(context)!.description,
                style: textTheme.labelMedium
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TextFormField(
                onChanged: (value) {
                  setDescription(value);
                },
                initialValue: description,
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: '${AppLocalizations.of(context)!.description}...',
                  hintStyle: textTheme.bodySmall,
                  errorStyle: textTheme.bodySmall?.copyWith(color: errorColor),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}