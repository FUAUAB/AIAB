// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mavis_api_client/api.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../app_localizations.dart';
import '../../../core/constants/constants.dart';
import '../../../cubit/work_order/work_order_cubit.dart';
import '../../Styles/colors_style.dart';

class WorkOrdersPhotoPage extends StatefulWidget {
  const WorkOrdersPhotoPage({Key? key, required this.data}) : super(key: key);

  final Map data;

  @override
  State<WorkOrdersPhotoPage> createState() => _WorkOrdersPhotoPageState();
}

class _WorkOrdersPhotoPageState extends State<WorkOrdersPhotoPage> {
  int selectId = 0;
  V112WorkOrder workOrder = new V112WorkOrder();
  final FilterOptionGroup _filterOptionGroup = FilterOptionGroup(
    imageOption: const FilterOption(
      sizeConstraint: SizeConstraint(ignoreSize: true),
    ),
  );
  final int _sizePerPage = 60;
  AssetPathEntity? _path;
  List<AssetEntity>? _entities;
  int _totalEntitiesCount = 0;
  int _page = 0;
  bool isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMoreToLoad = true;
  List<MultipartFile> _uploadedFiles = <MultipartFile>[];
  var workOrderCubit;

  Future<void> _requestAssets() async {
    PhotoManager.setIgnorePermissionCheck(true);
    // Obtain assets using the path entity.
    final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
      onlyAll: true,
      type: RequestType.image,
      filterOption: _filterOptionGroup,
    );
    if (!mounted) {
      return;
    }
    if (paths.isEmpty) {
      setState(() {});
      return;
    }
    setState(() {
      _path = paths.first;
    });
    _totalEntitiesCount = _path!.assetCount;
    final List<AssetEntity> entities = await _path!.getAssetListPaged(
      page: 0,
      size: _sizePerPage,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _entities = entities;
      _hasMoreToLoad = _entities!.length < _totalEntitiesCount;
      isLoading = true;
    });
  }

  Future<void> _loadMoreAsset() async {
    final List<AssetEntity> entities = await _path!.getAssetListPaged(
      page: _page + 1,
      size: _sizePerPage,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _entities!.addAll(entities);
      _page++;
      _hasMoreToLoad = _entities!.length < _totalEntitiesCount;
      _isLoadingMore = false;
    });
  }

  @override
  void initState() {
    super.initState();
    workOrder = widget.data["workOrder"];
    workOrderCubit = widget.data['workOrderCubit'];
    context.read<WorkOrderCubit>().getWorkOrderById(
        workOrder.orderId, workOrder.companyId, workOrder.branchId);
    _requestAssets();

    WorkOrderDetailType.selectedImage = [];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        workOrderCubit.getWorkOrderById(
            workOrder.orderId, workOrder.companyId, workOrder.branchId);
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            centerTitle: true,
            title: Text(AppLocalizations.of(context)!
                .translate('work.order.photo.page.add.photo')),
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(45.0),
                child: Container(
                  color: CustomColors.textWhite,
                  padding: const EdgeInsets.all(5.0),
                  width: double.maxFinite,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      // is this the right route?!
                      onPressed: () async {
                        checkForCameraPermission(workOrderCubit);
                      },
                      icon: Icon(FontAwesomeIcons.camera,
                          size: 15.0, color: CustomColors.textWhite),
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).colorScheme.primary,
                      ),
                      label: Text(
                        AppLocalizations.of(context)!
                            .translate('work.order.photo.page.take.photo'),
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ))),
        bottomNavigationBar: bottomSectionPhoto(workOrderCubit),
        body: _entities?.isNotEmpty == true
            ? SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.all(5.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppLocalizations.of(context)!
                              .translate('work.order.photo.page.galery'),
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 5.0, right: 5.0, bottom: 5.0),
                      child: GridView.custom(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 5),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: getexixcount(context),
                          mainAxisSpacing: 1,
                          crossAxisSpacing: 1,
                        ),
                        childrenDelegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            if (index == _entities!.length - 8 &&
                                !_isLoadingMore &&
                                _hasMoreToLoad) {
                              _loadMoreAsset();
                            }
                            final AssetEntity entity = _entities![index];
                            return GestureDetector(
                              onTap: () async {
                                var file = await entity.loadFile();
                                if (WorkOrderDetailType.selectedImage
                                    .contains(entity.title)) {
                                  WorkOrderDetailType.selectedImage
                                      .remove(entity.title);
                                  removeFileURL(file!, entity);
                                } else {
                                  WorkOrderDetailType.selectedImage
                                      .add(entity.title.toString());
                                  getFileURL(file!);
                                }
                                setState(() {});
                              },
                              child: Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      color: CustomColors.greyContainerBorder,
                                      border: WorkOrderDetailType.selectedImage
                                              .contains(entity.title)
                                          ? Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              width: 5.0)
                                          : null),
                                  child: AssetEntityImage(
                                    entity,
                                    isOriginal: false,
                                    thumbnailSize: const ThumbnailOption(
                                            size: ThumbnailSize.square(150))
                                        .size,
                                    thumbnailFormat: const ThumbnailOption(
                                            size: ThumbnailSize.square(150))
                                        .format,
                                    fit: BoxFit.cover,
                                  )),
                            );
                          },
                          childCount: _entities!.length,
                          findChildIndexCallback: (Key key) {
                            // Re-use elements.
                            if (key is ValueKey<int>) {
                              return key.value;
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }

  getFileURL(File sfile) async {
    setState(
      () async {
        _uploadedFiles.add(
          new MultipartFile.fromBytes(
            'uploadedFile',
            await File(sfile.path).readAsBytes(),
            filename: sfile.path.split("/").last,
            contentType: new MediaType('image', 'jpg'),
          ),
        );
      },
    );
  }

  removeFileURL(File sfile, AssetEntity entity) async {
    setState(() async {
      _uploadedFiles.removeWhere((x) => x.filename == entity.title);
    });
  }

  takePhoto(WorkOrderCubit workOrderCubit) {
    try {
      ImagePicker().pickImage(source: ImageSource.camera).then((recordedImage) {
        if (recordedImage != null) {
          WorkOrderDetailType.selectedImage.add(recordedImage.name.toString());
          _uploadedFiles.add(MultipartFile(
              'uploadedFile',
              File(recordedImage.path).readAsBytes().asStream(),
              File(recordedImage.path).lengthSync(),
              filename: recordedImage.path.split("/").last));
          workOrderCubit.addWorkOrderAttachment(_uploadedFiles,
              workOrder.orderId, workOrder.companyId, workOrder.branchId);
        }
      });
      Navigator.pop(context);
    } catch (e) {
      print(e.toString());
    }
  }

  checkForCameraPermission(WorkOrderCubit workOrderCubit) async {
    if (await Permission.camera.request().isGranted &&
        await Permission.storage.request().isGranted) {
      takePhoto(workOrderCubit);
      return;
    }
    if (await Permission.storage.request().isPermanentlyDenied) {
      return showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(
            'Camera permission',
            style: TextStyle(fontSize: 15.0, color: CustomColors.black),
          ),
          content: Text('This app required camera permission',
              style: TextStyle(fontSize: 15.0, color: CustomColors.black)),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Deny',
                  style: TextStyle(fontSize: 15.0, color: CustomColors.black)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            CupertinoDialogAction(
              child: Text('Settings',
                  style: TextStyle(fontSize: 15.0, color: CustomColors.black)),
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
            ),
          ],
        ),
      );
    } else if (await Permission.storage.request().isDenied) {
      return;
    }
    if (await Permission.storage.request().isPermanentlyDenied) {
      return showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(
            'Storage permission',
            style: TextStyle(fontSize: 15.0, color: CustomColors.black),
          ),
          content: Text('This app required storage permission',
              style: TextStyle(fontSize: 15.0, color: CustomColors.black)),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Deny',
                  style: TextStyle(fontSize: 15.0, color: CustomColors.black)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            CupertinoDialogAction(
              child: Text('Settings',
                  style: TextStyle(fontSize: 15.0, color: CustomColors.black)),
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
            ),
          ],
        ),
      );
    } else if (await Permission.storage.request().isDenied) {
      return;
    }
  }

  Widget bottomSectionPhoto(WorkOrderCubit workOrderCubit) {
    return Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: CustomColors.greyContainerBorder, width: 1),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 20.0, top: 6.0, right: 20.0, bottom: 6.0),
          child: Row(children: <Widget>[
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: () {
                  workOrderCubit.getWorkOrderById(workOrder.orderId,
                      workOrder.companyId, workOrder.branchId);
                  Navigator.pop(context);
                },
                child: Text(
                  AppLocalizations.of(context)!.translate('cancel.message'),
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: CustomColors.buttonDisabled,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: () {
                  workOrderCubit.addWorkOrderAttachment(
                      _uploadedFiles,
                      workOrder.orderId,
                      workOrder.companyId,
                      workOrder.branchId);
                  Navigator.pop(context);
                },
                child: Text(
                  AppLocalizations.of(context)!.translate('add.message'),
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: CustomColors.buttonGreen,
                ),
              ),
            ),
          ]),
        ));
  }
}
