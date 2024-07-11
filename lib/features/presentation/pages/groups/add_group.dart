import 'package:dio/dio.dart';
import 'package:droppy/features/presentation/widgets/organisms/search_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/theme/color.dart';
import '../../../../config/theme/widgets/text.dart';
import '../../../../injection_container.dart';
import '../../../domain/entities/form_section_item.dart';
import '../../../domain/entities/media_picker_item.dart';
import '../../bloc/drop/drop_bloc.dart';
import '../../bloc/drop/drop_event.dart';
import '../../bloc/group/goup_bloc.dart';
import '../../bloc/user/user_bloc.dart';
import '../../widgets/molecules/action_bar.dart';
import '../../widgets/molecules/app_bar_widget.dart';
import '../../widgets/molecules/form_section.dart';
import '../../widgets/molecules/media_picker.dart';

class AddGroupView extends StatefulWidget {

  const AddGroupView({
    super.key,
  });

  @override
  State<AddGroupView> createState() => _AddGroupViewState();
}

class _AddGroupViewState extends State<AddGroupView> {
  String activeElement = 'main';
  TextEditingController titleController = TextEditingController();
  List<MediaPickerItemEntity> selectedMedias = [];
  String? titleError;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    titleValidation(value) {
      if((value!.length < 5 || value.length > 600) && value.isNotEmpty){
        setState(() {
          titleError = 'Le titre doit être comprise entre 5 et 600 caractères ou vide';
        });
      } else {
        setState(() {
          titleError = null;
        });
      }
    };

    return MultiBlocProvider(
    providers: [
      BlocProvider<UsersBloc>(
        create: (context) => sl(),
      ),
      BlocProvider<GroupsBloc>(
        create: (context) => sl(),
      ),
    ],
    child: Scaffold(
        backgroundColor: backgroundColor,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              _buildForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(){
    return Visibility(
      visible: activeElement == 'main' || activeElement == 'medias',
      child: Column(
        children: [
          Visibility(
            visible: activeElement == 'main',
            child: AppBarWidget(
              leadingIcon: const Icon(Icons.arrow_back),
              leadingOnPressed: () {
                context.pop();
              },
              mainActionIcon: const Icon(Icons.check_rounded),
              mainActionOnPressed: () async {
                final mainMedia = await MultipartFile.fromFile((await selectedMedias[0].assetEntity!.originFile)!.path);
                context.read<DropsBloc>().add(PostDrop({
                  'media': mainMedia,
                }));
              },
              title: 'Nouveau group',
            ),
          ),
          Padding(
            padding: activeElement == 'main' ? const EdgeInsets.only(top: 20, bottom: 0, left: 24, right: 24) : const EdgeInsets.all(0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: activeElement == 'main' ? 56 : MediaQuery.of(context).size.width,
                  height: activeElement == 'main' ? 56 : MediaQuery.of(context).size.height,
                  child: MediaPickerWidget(
                    lite: true,
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
                if (activeElement == 'main') const SizedBox(width: 10),
                if (activeElement == 'main') Flexible(
                  child: TextFormField(
                    controller: titleController,
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                      hintText: 'Titre',
                      helperText: '',
                    )
                  ),
                ),
              ],
            ),
          ),
          if (activeElement == 'main') Expanded(child: SearchUsers()),
        ],
      ),
    );
  }
}