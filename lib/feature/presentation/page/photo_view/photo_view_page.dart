import 'dart:io';

import 'package:dipantau_desktop_client/core/util/images.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewPage extends StatefulWidget {
  static const routePath = '/photo-view';
  static const routeName = 'photo-view';
  static const parameterListPhotos = 'list_photos';

  final List<String>? listPhotos;

  PhotoViewPage({
    Key? key,
    required this.listPhotos,
  }) : super(key: key);

  @override
  State<PhotoViewPage> createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  final pageController = PageController();
  final listPhotos = <String>[];

  var indexSelectedPhoto = 0;

  @override
  void initState() {
    if (widget.listPhotos != null) {
      listPhotos.addAll(widget.listPhotos ?? []);
    }
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
                  final photo = listPhotos[index];
                  return PhotoViewGalleryPageOptions(
                    imageProvider: FileImage(File(photo)),
                    initialScale: PhotoViewComputedScale.contained,
                    heroAttributes: PhotoViewHeroAttributes(
                      tag: photo,
                    ),
                  );
                },
                itemCount: listPhotos.length,
                onPageChanged: (index) {
                  setState(() => indexSelectedPhoto = index);
                },
              ),
              Align(
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
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: buildWidgetSliderPreviewPhoto(),
              ),
            ],
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
          children: listPhotos.map((photo) {
            final index = listPhotos.indexOf(photo);
            final isSelected = photo == listPhotos[indexSelectedPhoto];

            final widgetImage = SizedBox(
              width: defaultSize,
              height: defaultSize,
              child: Image.file(
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
/*      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final photo = listPhotos![index];
          final isSelected = index == indexSelectedPhoto;

          final widgetImage = SizedBox(
            width: defaultSize,
            height: defaultSize,
            child: Image.file(
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
        },
        itemCount: listPhotos?.length,
      ),*/
    );
  }
}
