import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/theme/color.dart';
import '../../../../config/theme/widgets/text.dart';
import '../../../domain/entities/form_section_item.dart';
import '../../../domain/entities/media_picker_item.dart';
import '../../bloc/drop/drop_bloc.dart';
import '../../bloc/drop/drop_event.dart';
import '../../widgets/molecules/action_bar.dart';
import '../../widgets/molecules/app_bar_widget.dart';
import '../../widgets/molecules/form_section.dart';
import '../../widgets/molecules/media_picker.dart';

class AddDropView extends StatefulWidget {

  const AddDropView({
    super.key,
  });

  @override
  State<AddDropView> createState() => _AddDropViewState();
}

class _AddDropViewState extends State<AddDropView> {
  String activeElement = 'main';
  TextEditingController descriptionController = TextEditingController();
  List<MediaPickerItemEntity> selectedMedias = [];
  Map<String, dynamic> address = {};
  String? descriptionError;
  String? addressError;


  List<FormSectionItemEntity> formItems = [
    const FormSectionItemEntity(
      title: 'Adress',
      icon: Icons.location_on_rounded,
      index: 'address',
      onTapRoutePath: 'address-picker',
    ),
    const FormSectionItemEntity(
      title: 'Description',
      icon: Icons.description_rounded,
      index: 'description',
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    addressValidation(value) {
      if(value!.isEmpty){
        setState(() {
          addressError = 'Champ requis';
        });
      } else {
        setState(() {
          addressError = null;
        });
      }
    };
    descriptionValidation(value) {
      if((value!.length < 5 || value.length > 600) && value.isNotEmpty){
        setState(() {
          descriptionError = 'La description doit être comprise entre 5 et 600 caractères ou vide';
        });
      } else {
        setState(() {
          descriptionError = null;
        });
      }
    };

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            _buildForm(),
            Visibility(
              visible: activeElement == 'main',
              child: Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: const BoxDecoration(
                    color: backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 10,
                      ),
                    ],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(26),
                      topRight: Radius.circular(26),
                    ),
                  ),
                  child: ActionBar(
                    leadingText: 'Enregistrer',
                    leadingOnPressed: () async {
                      final mainMedia = await MultipartFile.fromFile((await selectedMedias[0].assetEntity!.originFile)!.path);

                      context.read<DropsBloc>().add(PostDrop({
                        'description': descriptionController.text,
                        'address': address,
                        'media': mainMedia,
                      }));
                    }
                  ),
                ),
              ),
            ),
            Visibility(
              visible: activeElement == 'description',
              child: FormSection(
                sectionTitle: 'Description',
                title: 'Des informations supplémentaires à ajouter ?',
                form: TextFormField(
                  controller: descriptionController,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    hintText: 'Ajouter une description...',
                  ),
                ),
                leadingOnPressed: () {
                  setState(() {
                    descriptionValidation(descriptionController.text);
                    activeElement = 'main';
                  });
                },
                mainActionIcon: const Icon(Icons.check_rounded),
                mainActionOnPressed: () {
                  setState(() {
                    descriptionValidation(descriptionController.text);
                    activeElement = 'main';
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(){
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Visibility(
        visible: activeElement == 'main' || activeElement == 'medias',
        child: Padding(
          padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight + 40),
          child: Column(
            children: [
              Visibility(
                visible: activeElement == 'main',
                child: AppBarWidget(
                  leadingIcon: const Icon(Icons.arrow_back),
                  leadingOnPressed: () {
                    context.pop();
                  },
                  title: 'Poster un drop',
                ),
              ),
              MediaPickerWidget(
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
              Visibility(
                visible: activeElement == 'main',
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(height: 12);
                      },
                      itemCount: formItems.length,
                      itemBuilder: (context, index) {
                        Widget? value;
                        String? error;
                        switch (formItems[index].index) {
                          case 'description':
                            error = descriptionError;
                            value = descriptionController.text != '' ? Text(descriptionController.text) : null;
                            break;
                          case 'address':
                            error = addressError;
                            value = address.isNotEmpty ? Text(address['address']) : null;
                            break;
                        }

                        return ListTile(
                          tileColor: surfaceColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onTap: () async {
                            if(formItems[index].onTapRoutePath != null) {
                              final result = await context.pushNamed<Map<String, dynamic>>(formItems[index].onTapRoutePath!);
                              if (result != null) {
                                setState(() {
                                  address = result;
                                });
                              }
                            }else{
                              setState(() {
                                activeElement = formItems[index].index;
                              });
                            }
                          },
                          horizontalTitleGap: 14,
                          leading: Icon(
                              formItems[index].icon, color: textColor),
                          title: Text(
                            formItems[index].title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium,
                          ),
                          subtitle: error != null ?
                            Text(
                              error,
                              style: textTheme.bodySmall!.copyWith(
                                color: Colors.red,
                              ),
                            )
                            : value,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}