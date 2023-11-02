import 'dart:io';

import 'package:dipantau_desktop_client/core/util/enum/global_variable.dart';
import 'package:dipantau_desktop_client/core/util/enum/user_role.dart';
import 'package:dipantau_desktop_client/core/util/images.dart';
import 'package:dipantau_desktop_client/core/util/shared_preferences_manager.dart';
import 'package:dipantau_desktop_client/feature/data/model/track_user/track_user_response.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewPage extends StatefulWidget {
  static const routePath = '/photo-view';
  static const routeName = 'photo-view';
  static const parameterListPhotos = 'list_photos';

  final List<ItemFileTrackUserResponse>? listPhotos;

  PhotoViewPage({
    Key? key,
    required this.listPhotos,
  }) : super(key: key);

  @override
  State<PhotoViewPage> createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  final pageController = PageController();
  final listPhotos = <ItemFileTrackUserResponse>[];

  var indexSelectedPhoto = 0;
  UserRole? userRole;
  var isBlurSettingEnabled = false;
  var isBlurPreviewEnabled = false;

  @override
  void initState() {
    final strUserRole = sharedPreferencesManager.getString(SharedPreferencesManager.keyUserRole) ?? '';
    userRole = strUserRole.fromStringUserRole;
    if (widget.listPhotos != null) {
      listPhotos.addAll(widget.listPhotos ?? []);
    }
    isBlurSettingEnabled = listPhotos.where((element) => (element.urlBlur ?? '').isNotEmpty).isNotEmpty;
    isBlurPreviewEnabled = isBlurSettingEnabled;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return listPhotos.isEmpty
        ? Center(
            child: Text('no_data_to_display'.tr()),
          )
        : Stack(
            children: [
              PhotoViewGallery.builder(
                pageController: pageController,
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  var photo = '';
                  if (isBlurPreviewEnabled) {
                    photo = listPhotos[index].urlBlur ?? '';
                  } else {
                    photo = listPhotos[index].url ?? '';
                  }
                  return photo.startsWith('http')
                      ? PhotoViewGalleryPageOptions(
                          imageProvider: NetworkImage(photo),
                          initialScale: PhotoViewComputedScale.contained,
                          heroAttributes: PhotoViewHeroAttributes(
                            tag: photo,
                          ),
                        )
                      : PhotoViewGalleryPageOptions(
                          imageProvider: FileImage(File(photo)),
                          initialScale: PhotoViewComputedScale.contained,
                          heroAttributes: PhotoViewHeroAttributes(
                            tag: photo,
                          ),
                        );
                },
                loadingBuilder: (context, loadingProgress) {
                  final cumulativeBytesLoaded = loadingProgress?.cumulativeBytesLoaded ?? 0;
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                      value: loadingProgress?.expectedTotalBytes != null
                          ? cumulativeBytesLoaded / loadingProgress!.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                itemCount: listPhotos.length,
                onPageChanged: (index) {
                  setState(() => indexSelectedPhoto = index);
                },
              ),
              buildWidgetIconClose(),
              buildWidgetIconPreviewSetting(),
              Align(
                alignment: Alignment.bottomCenter,
                child: buildWidgetSliderPreviewPhoto(),
              ),
            ],
          );
  }

  Widget buildWidgetIconPreviewSetting() {
    if (!isBlurSettingEnabled || (userRole != UserRole.superAdmin)) {
      return Container();
    }

    return Align(
      alignment: Alignment.topRight,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(.5),
        ),
        margin: const EdgeInsets.only(
          right: 8,
          top: 8,
        ),
        child: IconButton(
          onPressed: () {
            setState(() {
              isBlurPreviewEnabled = !isBlurPreviewEnabled;
            });
          },
          icon: Icon(
            isBlurPreviewEnabled ? Icons.visibility_off : Icons.visibility,
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(8),
        ),
      ),
    );
  }

  Widget buildWidgetIconClose() {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(.5),
        ),
        margin: const EdgeInsets.only(
          left: 8,
          top: 8,
        ),
        child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.clear,
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(8),
        ),
      ),
    );
  }

  Widget buildWidgetSliderPreviewPhoto() {
    if (listPhotos.length == 1) {
      return Container();
    }

    const defaultSize = 64.0;
    return SizedBox(
      height: defaultSize,
      child: Container(
        width: double.infinity,
        color: Colors.black.withOpacity(.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: listPhotos.map((element) {
            final index = listPhotos.indexOf(element);
            final elementId = element.id;
            final selectedId = listPhotos[indexSelectedPhoto].id;
            var isSelected = false;
            if (elementId != null || selectedId != null) {
              isSelected = elementId == selectedId;
            }
            var photo = '';
            if (isBlurPreviewEnabled) {
              photo = listPhotos[index].urlBlur ?? '';
            } else {
              photo = listPhotos[index].url ?? '';
            }

            final widgetImage = SizedBox(
              width: defaultSize,
              height: defaultSize,
              child: photo.startsWith('http')
                  ? Image.network(
                      photo,
                      fit: BoxFit.cover,
                      width: defaultSize,
                      height: defaultSize,
                      errorBuilder: (context, error, stacktrace) {
                        return Image.asset(
                          BaseImage.imagePlaceholder,
                          fit: BoxFit.cover,
                          width: defaultSize,
                          height: defaultSize,
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    )
                  : Image.file(
                      File(photo),
                      fit: BoxFit.cover,
                      width: defaultSize,
                      height: defaultSize,
                      errorBuilder: (context, error, stacktrace) {
                        return Image.asset(
                          BaseImage.imagePlaceholder,
                          fit: BoxFit.cover,
                          width: defaultSize,
                          height: defaultSize,
                        );
                      },
                    ),
            );
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Material(
                child: InkWell(
                  onTap: () {
                    pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: isSelected
                          ? Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2.0,
                            )
                          : Border.all(width: 2.0),
                    ),
                    child: widgetImage,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
