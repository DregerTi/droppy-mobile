import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../../../config/theme/widgets/button.dart';
import '../../../../config/theme/color.dart';
import '../../../../config/theme/widgets/text.dart';
import '../../../data/repository/media_picker_repository_impl.dart';
import '../../../domain/entities/media_picker_item.dart';
import '../atoms/cached_image_widget.dart';
import '../atoms/medias_grid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MediaPickerWidget extends StatefulWidget {
  final String activeElement;
  final List<MediaPickerItemEntity> selectedMedias;
  final int? maxMedias;
  final Function setActiveElement;
  final Function(List<MediaPickerItemEntity>) setSelectedMedias;
  final List<String>? initialMediaEntities;
  final bool lite;
  final bool? isPostDrop;

  const MediaPickerWidget({
    Key? key,
    required this.activeElement,
    required this.selectedMedias,
    this.maxMedias,
    required this.setActiveElement,
    this.initialMediaEntities,
    required this.setSelectedMedias,
    this.lite = false,
    this.isPostDrop = false,
  }) : super(key: key);

  @override
  State<MediaPickerWidget> createState() =>
      _MediaPickerWidgetState();
}

class _MediaPickerWidgetState extends State<MediaPickerWidget> {
  final MediaPickerRepositoryImpl _mediaPickerRepository = MediaPickerRepositoryImpl();
  final ScrollController _scrollController = ScrollController();
  AssetPathEntity? _currentAlbum;
  List<AssetPathEntity> _albums = [];
  final List<MediaPickerItemEntity> _medias = [];
  int _lastPage = 0;
  int _currentPage = 0;
  List<MediaPickerItemEntity> _selectedMedias = [];
  String activeElement = 'main';

  @override
  void initState() {
    super.initState();
    _loadAlbums();
    _scrollController.addListener(_loadMoreMedias);
    if(widget.selectedMedias.isNotEmpty) {
      setState(() {
        _selectedMedias = widget.selectedMedias;
      });
    } else if(widget.initialMediaEntities != null) {
      setState(() {
        _selectedMedias = _convertMediaEntitiesToPickerItems(widget.initialMediaEntities)!;
      });
    }
  }

  List<MediaPickerItemEntity>? _convertMediaEntitiesToPickerItems(List<String>? mediaEntities) {
    return mediaEntities?.map((media) {
      return MediaPickerItemEntity(
        assetEntity: AssetEntity(
          id: media,
          typeInt: 1,
          width: 100,
          height: 100,
          relativePath: media,
        ),
        widget: CachedImageWidget(
          imageUrl: media,
        )
      );
    }).toList();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_loadMoreMedias);
    _scrollController.dispose();
    super.dispose();
  }

  void _loadAlbums() async {
    List<AssetPathEntity> albums = await _mediaPickerRepository.fetchAlbums();
    if (albums.isNotEmpty) {
      setState(() {
        _currentAlbum = albums.first;
        _albums = albums;
      });
      _loadMedias();
    }
  }

  void _loadMedias() async {
    _lastPage = _currentPage;
    if (_currentAlbum != null) {
      List<MediaPickerItemEntity> medias =
      await _mediaPickerRepository.fetchMedias(album: _currentAlbum!, page: _currentPage);
      setState(() {
        _medias.addAll(medias);
      });
    }
  }

  void _loadMoreMedias() {
    if (_scrollController.position.pixels /
        _scrollController.position.maxScrollExtent >
        0.33) {
      if (_currentPage != _lastPage) {
        _loadMedias();
      }
    }
  }

  void _selectMedia(MediaPickerItemEntity media) {
    bool isSelected = _selectedMedias.any((element) =>
      element.assetEntity?.id == media.assetEntity?.id
    );
    setState(() {
      if (isSelected) {
        _selectedMedias.removeWhere(
                (element) => element.assetEntity?.id == media.assetEntity?.id);
      } else {
        if(widget.maxMedias == null || widget.maxMedias! > _selectedMedias.length) {
          _selectedMedias.add(media);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Visibility(
          visible: activeElement == 'main',
          child: _openImagePickerButton(),
        ),
        Visibility(
          visible: activeElement == 'medias',
          child: _imagePicker(),
        ),
      ]
    );

  }

  Widget _openImagePickerButton() {
    ScrollController previwScrollController = ScrollController();
    return Row(
      children: [
        Container(
          padding: EdgeInsets.only(top: !widget.lite ? 0 : 0),
          width: !widget.lite ? MediaQuery.of(context).size.width : 56,
          height: !widget.lite ? MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight - 50 : 56,
          child: ListView.builder(
            shrinkWrap: true,
            controller: previwScrollController,
            scrollDirection: Axis.horizontal,
            itemCount: _selectedMedias.length + 1,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Visibility(
                  visible: widget.maxMedias == null || _selectedMedias.length < widget.maxMedias!,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            activeElement = 'medias';
                          });
                          widget.setActiveElement('medias');
                        },
                        child: Container(
                          height: !widget.lite ? MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight - 50 : 56,
                          width: !widget.lite ? MediaQuery.of(context).size.width : 56,
                          decoration: BoxDecoration(
                            color: (widget.isPostDrop != null && widget.isPostDrop! == true) ? onBackgroundColor : surfaceColor,
                            borderRadius: BorderRadius.circular((widget.isPostDrop != null && widget.isPostDrop! == true) ? 46 : 16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                color: onSurfaceColor,
                                size: !widget.lite ? 32 : 20,
                              ),
                              if (!widget.lite) const SizedBox(height: 10),
                              if (!widget.lite) Text(
                                AppLocalizations.of(context)!.addAPhoto,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: onSurfaceColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Stack(
                  children: [
                    Positioned(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: !widget.lite ? 0 : 0,),
                        height: !widget.lite ? MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight - 50 : 56,
                        width: !widget.lite ? MediaQuery.of(context).size.width : 56,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular((widget.isPostDrop != null && widget.isPostDrop! == true) ? 46 : 16),
                          child: _selectedMedias[index - 1].widget,
                        ),
                      ),
                    ),
                    if (widget.lite) Container(
                      height: !widget.lite ? 160 : 56,
                      width: !widget.lite ? 160 : 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ),
                    Positioned.fill(
                      bottom: 4,
                      right: !widget.lite ? 12 : 4,
                      child: Column(
                        mainAxisAlignment: !widget.lite ? MainAxisAlignment.center : MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: !widget.lite ? MainAxisAlignment.center : MainAxisAlignment.end,
                            children: [
                              if (widget.maxMedias == null || widget.maxMedias! > 1) IconButton(
                                icon: Icon(
                                  Icons.star_rate_rounded,
                                  color: (index - 1 == 0) ? primaryColor : onSurfaceColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _selectedMedias.insert(0, _selectedMedias.removeAt(index - 1));
                                    previwScrollController.animateTo(
                                      0.0,
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeOut,
                                    );
                                  });
                                },
                                style: iconButtonThemeData.style?.copyWith(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  !widget.lite ? Icons.delete_rounded : Icons.edit_rounded,
                                  size: !widget.lite ? 32 : 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _selectedMedias.removeAt(index - 1);
                                  });
                                },
                                style: iconButtonThemeData.style?.copyWith(
                                  foregroundColor: MaterialStateProperty.all(!widget.lite ? onSurfaceColor : secondaryTextColor),
                                  backgroundColor: MaterialStateProperty.all(surfaceColor.withOpacity(!widget.lite ? 1 : 0)),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ]
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _imagePicker() {
    return Column(
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    widget.setActiveElement('main');
                    setState(() {
                      activeElement = 'main';
                    });
                  },
                  style: iconButtonThemeData.style?.copyWith(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: DropdownButton<AssetPathEntity>(
                    borderRadius: BorderRadius.circular(8.0),
                    underline: const SizedBox(),
                    icon: const Icon(Icons.arrow_drop_down),
                    value: _currentAlbum,
                    items: _albums
                        .map(
                          (e) => DropdownMenuItem<AssetPathEntity>(
                        value: e,
                        child: Container(
                          width: 80,
                          child: Text(
                            e.name.isEmpty ? "0" : e.name,
                            style: textTheme.titleSmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ).toList(),
                    onChanged: (AssetPathEntity? value) {
                      setState(() {
                        _currentAlbum = value;
                        _currentPage = 0;
                        _lastPage = 0;
                        _medias.clear();
                      });
                      _loadMedias();
                      _scrollController.animateTo(
                        0.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    widget.setActiveElement('main');
                    widget.setSelectedMedias(_selectedMedias);
                    setState(() {
                      activeElement = 'main';
                    });
                  },
                  style: iconButtonThemeData.style?.copyWith(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ]
            ),
          ),
        ),
        MediasGrid(
          medias: _medias,
          selectedMedias: _selectedMedias,
          selectMedia: _selectMedia,
          scrollController: _scrollController,
        ),
      ],
    );
  }
}