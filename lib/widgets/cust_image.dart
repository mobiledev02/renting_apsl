import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '/widgets/spinner.dart';
import '../../widgets/custom_text.dart';
import '../constants/img_font_color_string.dart';

class CustImage extends StatelessWidget {
  final String imgURL;
  final double? height;
  final double? width;
  final double? spinnerHeight;
  final double? spinnerWidth;
  final double? cornerRadius;
  final String errorImage;
  final bool zoomablePhoto;
  final Color? backgroundColor;
  final Color? imgColor;
  final BoxFit? boxfit;
  final String? name;
  final Color? textColor;
  final EdgeInsets letterPadding;
  final bool defaultImageWithDottedBorder;
  final Function? closeButton;

  CustImage({
    this.imgURL = "",
    this.cornerRadius = 0,
    this.height,
    this.width,
    this.spinnerHeight,
    this.spinnerWidth,
    this.boxfit,
    this.errorImage = ImgName.imagePlacheHolderImage,
    this.zoomablePhoto = false,
    this.backgroundColor,
    this.imgColor,
    this.textColor,
    this.name = "",
    this.closeButton,
    this.defaultImageWithDottedBorder = false,
    this.letterPadding = const EdgeInsets.only(
      top: 2.0,
      left: 2.0,
      right: 2.0,
    ),
  });

  Widget get defaultImg => errorImage.contains(".svg")
      ? errorImage == ImgName.imagePlacheHolderImage
          ? _buildDottedBorderImage()
          : SvgPicture.asset(
              errorImage,
              fit: boxfit ?? BoxFit.cover,
              height: height,
              width: width,
            )
      : errorImage == ImgName.imagePlacheHolderImage
          ? _buildDottedBorderImage()
          : Image.asset(
              errorImage,
              fit: boxfit ?? BoxFit.cover,
              height: height,
              width: width,
            );

  @override
  Widget build(BuildContext context) {
    Widget _image = defaultImg;

    if (imgURL.isNotEmpty && (name?.isEmpty ?? true)) {
      // Check if Network image...
      if (isNetworkImage(imgURL)) {
        _image =
            zoomablePhoto ? _buildZoomablePhoto(context) : _cacheImage(context);

        // Check if Asset image...
      } else if (isAssetImage(imgURL)) {
        _image = imgURL.contains(".svg")
            ? SvgPicture.asset(
                imgURL,
                color: imgColor,
                fit: boxfit ?? BoxFit.cover,
                height: height,
                width: width,
                placeholderBuilder: (BuildContext context) =>
                    errorImage.contains(".svg")
                        ? errorImage == ImgName.imagePlacheHolderImage
                            ? _buildDottedBorderImage()
                            : SvgPicture.asset(
                                errorImage,
                                height: height,
                                width: width,
                              )
                        : errorImage == ImgName.imagePlacheHolderImage
                            ? _buildDottedBorderImage()
                            : Image.asset(
                                errorImage,
                                height: height,
                                width: width,
                              ),
              )
            : Image.asset(
                imgURL,
                height: height,
                width: width,
                color: imgColor,
                fit: boxfit ?? BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return errorImage.contains(".svg")
                      ? errorImage == ImgName.imagePlacheHolderImage
                          ? _buildDottedBorderImage()
                          : SvgPicture.asset(
                              errorImage,
                              height: height,
                              width: width,
                            )
                      : errorImage == ImgName.imagePlacheHolderImage
                          ? _buildDottedBorderImage()
                          : Image.asset(
                              errorImage,
                              height: height,
                              width: width,
                            );
                },
              );

        // Check if File image...
      } else if (isFileImage(imgURL)) {
        // print(imgURL);
        _image = Image.file(
          File(imgURL),
          height: height,
          width: width,
          color: imgColor,
          fit: boxfit ?? BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return errorImage.contains(".svg")
                ? errorImage == ImgName.imagePlacheHolderImage
                    ? _buildDottedBorderImage()
                    : SvgPicture.asset(
                        errorImage,
                        height: height,
                        width: width,
                      )
                : errorImage == ImgName.imagePlacheHolderImage
                    ? _buildDottedBorderImage()
                    : Image.asset(
                        errorImage,
                        height: height,
                        width: width,
                      );
          },
        );
      }
    } else if (name?.isNotEmpty ?? false) {
      _image = Padding(
        padding: letterPadding,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: CustomText(
            txtTitle: name ?? "",
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: textColor),
          ),
        ),
      );
    } else {
      _image = defaultImageWithDottedBorder
          ? _buildDottedBorderImage()
          : errorImage.contains(".svg")
              ? errorImage == ImgName.imagePlacheHolderImage
                  ? _buildDottedBorderImage()
                  : SvgPicture.asset(
                      errorImage,
                      height: height,
                      width: width,
                    )
              : errorImage == ImgName.imagePlacheHolderImage
                  ? _buildDottedBorderImage()
                  : Image.asset(
                      errorImage,
                      height: height,
                      width: width,
                    );
    }




      if (closeButton != null) {
        return   Stack(
          children: [

            Container(
              alignment: Alignment.center,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: backgroundColor ?? Colors.transparent,
                borderRadius: BorderRadius.all(
                  Radius.circular(cornerRadius ?? 0.0),
                ),
              ),
              height: height,
              width: width,
              child: _image,
            ),
            Positioned(
                top: 4,
                right: 8,
                child: GestureDetector(
                    onTap: () {
                      closeButton!();
                    }, child: const Icon(Icons.cancel, size: 28,))),
          ],
        );
      } else {
        return Container(
        alignment: Alignment.center,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(cornerRadius ?? 0.0),
          ),
        ),
        height: height,
        width: width,
        child: _image,
      );
      }
  }

  Widget _cacheImage(BuildContext context) {
    return CachedNetworkImage(
      fadeInDuration: Duration(milliseconds: 1000),
      fit: boxfit ?? BoxFit.cover,
      height: height,
      width: width,
      progressIndicatorBuilder: (context, _, progress) {
        double? value;
        var expectedBytes = progress.totalSize;
        if (progress != null && expectedBytes != null) {
          value = progress.downloaded / expectedBytes;
        }

        return Container(
          height: height,
          width: width,
          color: Colors.grey.withOpacity(0.5),
          child: Spinner(
            height: spinnerHeight ?? 50,
            width: spinnerWidth ?? 50,
            progressColor: Theme.of(context).primaryColor,
            value: value,
          ),
        );
      },
      errorWidget: (ctx, url, obj) => defaultImg,
      imageUrl: imgURL,
    );
  }

  /// Dotted Border image
  Widget _buildDottedBorderImage() {
    return true
        ? SvgPicture.asset(
            ImgName.dottendBorder,
          )
        : DottedBorder(
            strokeWidth: 2,
            borderType: BorderType.RRect,
            color: cust87919C,
            radius: Radius.circular(cornerRadius ?? 0.0),
            child: SizedBox(
              height: height,
              width: width ?? double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  SvgPicture.asset(
                    ImgName.hill,
                    height: 30,
                    width: 34,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildZoomablePhoto(BuildContext context) {
    return PhotoViewGallery(
      pageOptions: [
        PhotoViewGalleryPageOptions(
          heroAttributes: null,
          imageProvider: CachedNetworkImageProvider(
            imgURL,
          ),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2,
        )
      ],
      loadingBuilder: (context, url) => Spinner(progressColor: Colors.black),
      enableRotation: false,
    );
  }

  bool isAssetImage(String url) => url.toLowerCase().contains(ImgName.imgPath);

  bool isFileImage(String url) => !isAssetImage(url);

  bool isNetworkImage(String url) =>
      url.toLowerCase().startsWith("http://") ||
      url.toLowerCase().startsWith("https://");
}
