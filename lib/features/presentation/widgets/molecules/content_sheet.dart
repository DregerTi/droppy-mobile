import 'dart:async';
import 'package:droppy/features/presentation/bloc/content/content_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../config/theme/color.dart';
import '../../../data/models/content.dart';
import '../../bloc/content/content_bloc.dart';
import '../../bloc/content/content_state.dart';
import '../atoms/cached_image_widget.dart';
import '../atoms/warning_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContentSheet extends StatefulWidget {
  final List<ContentModel>? contents;
  final Function? setContent;

  const ContentSheet({
    super.key,
    this.contents,
    this.setContent,
  });

  @override
  State<ContentSheet> createState() => _ContentSheetState();
}

class _ContentSheetState extends State<ContentSheet> {
  TextEditingController contentController = TextEditingController();
  bool isContentResponse = false;
  TextEditingController searchFieldController = TextEditingController();
  String? searchFieldValue;
  Timer? debounce;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    debounce?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(46)),
      ),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
            width: MediaQuery.of(context).size.width,
            child: BlocConsumer<ContentBloc, ContentState>(
              listener: (BuildContext context, ContentState state) {  },
              builder: (_,state) {
                if(state is SearchContentLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if(state is SearchContentError) {
                  return WarningCard(
                    icon: 'error',
                    message: AppLocalizations.of(context)!.anErrorOccurred,
                  );
                }
                if(state is SearchContentDone) {
                  if (state.contents?.isEmpty ?? true) {
                    return WarningCard(
                      icon: 'empty',
                      message: AppLocalizations.of(context)!.noResults,
                    );
                  } else {
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 0, bottom: 65, left: 6, right: 6),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.contents?.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              if(widget.setContent != null) {
                                setState(() {
                                  widget.setContent!(state.contents?[index]);
                                });
                                //close the sheet
                                Navigator.pop(context);
                              }
                            },
                            leading: state.contents?[index]?.picturePath != null ? CachedImageWidget(
                              borderRadius: BorderRadius.circular(16),
                              imageUrl: state.contents?[index]?.picturePath ?? '',
                              height: 50,
                              width: 50,
                            ) : ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: SvgPicture.asset(
                                'lib/assets/images/avatar.svg',
                                height: 50,
                                width: 50,
                              ),
                            ),
                            title: Text(
                                state.contents?[index]?.title ?? '',
                                style: Theme.of(context).textTheme.titleMedium
                            ),
                            subtitle: Text(
                              state.contents?[index]?.subtitle ?? '',
                            ),
                          );
                        },
                      )
                    );
                  }
                }
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 1.6,
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 10,
                top: 20,
              ),
              decoration: const BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(46),
                  topRight: Radius.circular(46)
                )
              ),
              child: Container(
                child: TextFormField(
                  controller: contentController,
                  onChanged: (input){
                    setState(() {
                      searchFieldValue = input;
                    });
                    if (debounce?.isActive ?? false) debounce?.cancel();
                    if (input.isNotEmpty) {
                      debounce = Timer(const Duration(milliseconds: 1000), () {
                        BlocProvider.of<ContentBloc>(context).add(SearchContent({
                          'search': input,
                        }));
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.searchContent,
                    suffixIcon: const Icon(Icons.search, color: onSurfaceColor, size: 20),
                  )
                ),
              )
            ),
          )
        ],
      ),
    );
  }
}