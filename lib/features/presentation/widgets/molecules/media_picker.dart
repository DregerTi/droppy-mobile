import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../../../config/theme/widgets/button.dart';
import '../../../../config/theme/color.dart';
import '../../../../config/theme/widgets/text.dart';
import '../../../data/repository/media_picker_repository_impl.dart';
import '../../../domain/entities/media_picker_item.dart';
import '../atoms/cached_image_widget.dart';
import '../atoms/medias_grid.dart';

class MediaPickerWidget extends StatefulWidget {
  final String activeElement;
  final List<MediaPickerItemEntity> selectedMedias;
  final int? maxMedias;
  final Function setActiveElement;
  final Function(List<MediaPickerItemEntity>) setSelectedMedias;
  final List<String>? initialMediaEntities;

  const MediaPickerWidget({
    Key? key,
    required this.activeElement,
    required this.selectedMedias,
    this.maxMedias,
    required this.setActiveElement,
    this.initialMediaEntities,
    required this.setSelectedMedias,
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
          padding: const EdgeInsets.only(top: 20),
          width: MediaQuery.of(context).size.width,
          height: 180,
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
                  child: Container(
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(
                      children: [
                        const SizedBox(width: 30),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              activeElement = 'medias';
                            });
                            widget.setActiveElement('medias');
                          },
                          child: Container(
                            height: 160,
                            width: 160,
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.camera_alt,
                                  color: onSurfaceColor,
                                  size: 32,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Ajouter une photo',
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
                  ),
                );
              } else {
                return Stack(
                  children: [
                    Positioned(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0,),
                        height: 160,
                        width: 160,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: _selectedMedias[index - 1].widget,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      bottom: 4,
                      right: 12,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
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
                                      borderRadius: BorderRadius.circular(80),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_rounded,

                                ),
                                onPressed: () {
                                  setState(() {
                                    _selectedMedias.removeAt(index - 1);
                                  });
                                },
                                style: iconButtonThemeData.style?.copyWith(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(80),
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
                        borderRadius: BorderRadius.circular(80),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(80),
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
                        child: Text(
                            e.name.isEmpty ? "0" : e.name,
                            style: textTheme.titleSmall
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
                        borderRadius: BorderRadius.circular(80),
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