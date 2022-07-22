import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mavis_api_client/api.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:work_order_app/core/constants/constants.dart';
import 'package:work_order_app/core/helpers/helperMethods.dart';
import 'package:work_order_app/core/helpers/map_launcher.dart';
import 'package:work_order_app/core/responsive/responsive.dart';
import 'package:work_order_app/cubit/customer/customers_cubit.dart';
import 'package:work_order_app/cubit/work_order/work_order_cubit.dart';
import 'package:work_order_app/presentation/widgets/appbars/appbar_title.dart';
import 'package:work_order_app/presentation/widgets/blocks/empty_content_column_block.dart';
import 'package:work_order_app/presentation/widgets/blocks/work_counter_order_block.dart';
import 'package:work_order_app/presentation/widgets/dialogs/dialog_notification.dart';
import 'package:work_order_app/presentation/widgets/generics/build_state.dart';
import 'package:work_order_app/presentation/widgets/rows/download_attachment_row.dart';

import '../../../app_localizations.dart';
import '../../styles/colors_style.dart';
import '../../widgets/menus/navigation_drawer.dart';

class WorkOrdersDetailsPage extends StatefulWidget {
  const WorkOrdersDetailsPage({Key? key, required this.data}) : super(key: key);

  final Map data;

  @override
  _WorkOrderDetailsPageState createState() => _WorkOrderDetailsPageState();
}

class _WorkOrderDetailsPageState extends State<WorkOrdersDetailsPage> {
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  V112WorkOrder workOrder = V112WorkOrder();
  WorkOrderDetailRequest workOrderDetailRequest = WorkOrderDetailRequest();
  List<MultipartFile> _uploadedFiles = <MultipartFile>[];
  List<CostType> costTypesList = <CostType>[];

  late var address;
  late var customerCubit;
  late var workOrderCubit;
  late Customer customer = new Customer();
  String _customerName = "";

  @override
  void initState() {
    super.initState();
    workOrderCubit = context.read<WorkOrderCubit>();
    workOrder = widget.data["workOrder"];

    address = workOrder.shippingAddress!.address!.street! +
        " " +
        workOrder.shippingAddress!.address!.houseNumber! +
        " " +
        workOrder.shippingAddress!.address!.houseNumberAddition +
        workOrder.shippingAddress!.address!.city! +
        " " +
        workOrder.shippingAddress!.address!.postalCode!;

    workOrderCubit.getWorkOrderById(
        workOrder.orderId, workOrder.companyId, workOrder.branchId);

    workOrderDetailRequest.branchId = workOrder.branchId;
    workOrderDetailRequest.companyId = workOrder.companyId;
    workOrderDetailRequest.orderId = workOrder.orderId;

    customerCubit = context.read<CustomerCubit>();
    customerCubit.getCustomer(workOrder.customerId!).then(
      (value) {
        setState(
          () {
            customer = this.customerCubit.state.customer as Customer;
            _customerName = customer.name;
          },
        );
      },
    );
    // Register the port, so that flutter_downloader knows where to return when done downloading.
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  // Used for error avoidence when downloading documents from the app.
  final ReceivePort _port = ReceivePort();

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  // Function that is called by flutter_downloader to return to the app.
  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          drawer: NavigationDrawerWidget(),
          appBar: buildAppBarTitle(
              context,
              AppLocalizations.of(context)!
                  .translate('work.order.details.title')),
          bottomNavigationBar: navigationBar(),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: ClampingScrollPhysics(),
              children: [
                Container(
                  padding: EdgeInsets.only(top: 15, bottom: 5),
                  color: CustomColors.evenRow,
                  child: Column(
                    children: [
                      workOrderDetailsMainTopSection(context),
                      workOrderDetailsMainContentSection(context),
                    ],
                  ),
                ),
                //body
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        AppLocalizations.of(context)!
                            .translate('work.order.details'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Theme.of(context).colorScheme.primary,
                        )),
                  ),
                ),
                _loadWorkOrderDetailsBlocks(),
                //* temporary hide breur don't want prices yet
                // _loadPricingWorkOrderProducts(workOrder),
                _loadWorkOrderDetailsAttachments(),
                _loadUserSignature(workOrderCubit),
              ],
            ),
          ),
        ),
      ),
    );
  }

  uploadSignature(WorkOrderCubit workOrderCubit, ui.Image data) async {
    ByteData? byteData = await data.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    setState(() async {
      _uploadedFiles.add(new MultipartFile.fromBytes(
        'uploadedFile',
        pngBytes,
        filename: 'signature_' +
            DateFormat('ddMMyyyy_HHmmssSSS').format(DateTime.now()) +
            '.png',
      ));
      workOrderCubit.addWorkOrderAttachment(_uploadedFiles, workOrder.orderId,
          workOrder.companyId, workOrder.branchId);
    });
  }

  Widget _loadUserSignature(WorkOrderCubit workOrderCubit) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: 5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalizations.of(context)!.translate('Handtekening'),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            height: 200.0,
            decoration: BoxDecoration(
              // color: CustomColors.evenRow,
              border: Border.all(
                width: 1,
                color: CustomColors.greyBorder,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  5.0,
                ),
              ),
            ),
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  child: SfSignaturePad(
                    key: signatureGlobalKey,
                    backgroundColor: Colors.white,
                    strokeColor: Colors.black,
                    minimumStrokeWidth: 1.0,
                    maximumStrokeWidth: 4.0,
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final data = await signatureGlobalKey.currentState!
                              .toImage(pixelRatio: 3.0);
                          uploadSignature(workOrderCubit, data);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: CustomColors.greyBorder,
                                width: 1.5,
                              ),
                              bottom: BorderSide(
                                color: CustomColors.greyBorder,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 9),
                            child: Icon(
                              FontAwesomeIcons.solidFloppyDisk,
                              color: Theme.of(context).colorScheme.primary,
                              size: (35),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          signatureGlobalKey.currentState!.clear();
                          _uploadedFiles = [];
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: CustomColors.greyBorder,
                                width: 1.5,
                              ),
                              bottom: BorderSide(
                                color: CustomColors.greyBorder,
                                width: 1.5,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 9),
                            child: Icon(
                              FontAwesomeIcons.solidTrashCan,
                              color: CustomColors.DeleteIcon,
                              size: (35),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }

  Column workOrderDetailsMainContentSection(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Container(
            decoration: BoxDecoration(
              color: CustomColors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(
                  5.0,
                ),
              ),
            ),
            child: Responsive.isMobile(context)
                ? Column(
                    children: <Widget>[
                      buildWorkOrderDetailsMainContentSectionColumn(
                          "Gepland: " +
                              toBeginningOfSentenceCase(getWeekDay(workOrder
                                      .schedule!.startTime.weekday
                                      .toString()))
                                  .toString() +
                              " " +
                              getDateOnly(workOrder.schedule!.startTime)),
                      Row(
                        children: [
                          Expanded(
                              child:
                                  buildWorkOrderDetailsMainContentSectionColumn(
                                      AppLocalizations.of(context)!.translate(
                                              'work.order.details.total') +
                                          AppLocalizations.of(context)!
                                              .translate(
                                                  'work.order.details.hour'),
                                      CrossAxisAlignment.end)),
                        ],
                      ),
                    ],
                  )
                : Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: buildWorkOrderDetailsMainContentSectionColumn(
                            "Gepland: " +
                                toBeginningOfSentenceCase(getWeekDay(workOrder
                                        .schedule!.startTime.weekday
                                        .toString()))
                                    .toString() +
                                " " +
                                getDateOnly(workOrder.schedule!.startTime)),
                      ),
                      Expanded(
                        flex: 1,
                        child:
                            buildWorkOrderDetailsMainContentSectionColumn(""),
                      ),
                      Expanded(
                          flex: 1,
                          child: buildWorkOrderDetailsMainContentSectionColumn(
                              AppLocalizations.of(context)!
                                      .translate('work.order.details.total') +
                                  AppLocalizations.of(context)!
                                      .translate('work.order.details.hour'),
                              CrossAxisAlignment.end)),
                    ],
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
          child: Container(
            child: Responsive.isMobile(context)
                ? Column(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: CustomColors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  5.0,
                                ),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              AppLocalizations.of(context)!
                                      .translate('work.order.details.project') +
                                  (workOrder.projectId.toString() == "null"
                                      ? ""
                                      : workOrder.projectId.toString() +
                                          " - " +
                                          workOrder.projectName),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              5.0,
                            ),
                          ),
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 6,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                            customerDetailsRoute,
                                            arguments: customer,
                                          );
                                        },
                                        child: Text(
                                          _customerName,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: <Widget>[
                                    StreamBuilder<CustomerCubit>(
                                        stream: null,
                                        builder: (context, snapshot) {
                                          return Align(
                                            alignment: Alignment.topRight,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pushNamed(
                                                  customerDetailsRoute,
                                                  arguments: customer,
                                                );
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                    decoration: (BoxDecoration(
                                                      color:
                                                          CustomColors.greyIcon,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    )),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Icon(
                                                        FontAwesomeIcons.info,
                                                        color: Colors.white,
                                                        size: (24),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 15),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: CustomColors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    5.0,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Text(
                                AppLocalizations.of(context)!.translate(
                                        'work.order.details.project') +
                                    (workOrder.projectId.toString() == "null"
                                        ? " "
                                        : workOrder.projectId.toString() +
                                            " - " +
                                            workOrder.projectName),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: CustomColors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                5.0,
                              ),
                            ),
                          ),
                          child: IntrinsicHeight(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 6,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                              customerDetailsRoute,
                                              arguments: customer,
                                            );
                                          },
                                          child: Text(
                                            _customerName,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: <Widget>[
                                      StreamBuilder<CustomerCubit>(
                                        stream: null,
                                        builder: (context, snapshot) {
                                          return Align(
                                            alignment: Alignment.topRight,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pushNamed(
                                                  customerDetailsRoute,
                                                  arguments: customer,
                                                );
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                    decoration: (BoxDecoration(
                                                        color: CustomColors
                                                            .greyIcon,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5))),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Icon(
                                                        FontAwesomeIcons.info,
                                                        color: Colors.white,
                                                        size: (24),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          child: Container(
            decoration: BoxDecoration(
              color: CustomColors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(
                  5.0,
                ),
              ),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: RichText(
                        text: TextSpan(
                          text: address.toString(),
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ),
                    onTap: () async {
                      MapsLauncher.launchQuery(address);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        //* temporary hide breur don't want prices yet
        // Padding(
        //   padding: const EdgeInsets.symmetric(
        //       horizontal: 20, vertical: 5),
        //   child: Container(
        //     margin: EdgeInsets.only(bottom: 15),
        //     child: Row(
        //       children: <Widget>[
        //         Expanded(
        //           flex: 1,
        //           child: Column(
        //             mainAxisAlignment: MainAxisAlignment.start,
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: <Widget>[
        //               Container(
        //                 margin: EdgeInsets.only(right: 15),
        //                 width: double.infinity,
        //                 // decoration: BoxDecoration(
        //                 //   color: CustomColors.white,
        //                 //   borderRadius: BorderRadius.all(
        //                 //     Radius.circular(
        //                 //       5.0,
        //                 //     ),
        //                 //   ),
        //                 // ),
        //                 padding: EdgeInsets.symmetric(
        //                     horizontal: 20, vertical: 10),
        //                 child: Text(
        //                   "",
        //                   style: TextStyle(
        //                     color: Theme.of(context).colorScheme.primary,
        //                     fontSize: 18,
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //         Expanded(
        //           flex: 1,
        //           child: Container(
        //             decoration: BoxDecoration(
        //               color: CustomColors.white,
        //               borderRadius: BorderRadius.all(
        //                 Radius.circular(
        //                   5.0,
        //                 ),
        //               ),
        //             ),
        //             child: IntrinsicHeight(
        //               child: Row(
        //                 children: <Widget>[
        //                   Expanded(
        //                     flex: 2,
        //                     child: Column(
        //                       mainAxisAlignment:
        //                           MainAxisAlignment.end,
        //                       crossAxisAlignment:
        //                           CrossAxisAlignment.start,
        //                       children: <Widget>[
        //                         Padding(
        //                           padding: EdgeInsets.symmetric(
        //                               vertical: 10, horizontal: 20),
        //                           child: Text(
        //                             AppLocalizations.of(context)!
        //                                 .translate(
        //                                     'workOrder.details.total.excl'),
        //                             textAlign: TextAlign.left,
        //                             style: TextStyle(
        //                               fontSize: 18,
        //                               color: CustomColors.black,
        //                             ),
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                   Expanded(
        //                     flex: 1,
        //                     child: Column(
        //                       mainAxisAlignment:
        //                           MainAxisAlignment.end,
        //                       crossAxisAlignment:
        //                           CrossAxisAlignment.start,
        //                       children: <Widget>[
        //                         Padding(
        //                           padding: EdgeInsets.symmetric(
        //                               vertical: 10, horizontal: 20),
        //                           child: Text(
        //                             AppLocalizations.of(context)!
        //                                     .translate(
        //                                         'euro.icon') +
        //                                 workOrder.netAmount!.value
        //                                     .toString(),
        //                             textAlign: TextAlign.left,
        //                             style: TextStyle(
        //                               fontSize: 18,
        //                               color: CustomColors.black,
        //                             ),
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),

        // Container(
        //   child: Column(
        //     children: [
        //       Container(
        //         margin: EdgeInsets.only(top: 10, bottom: 10),
        //         padding:
        //             EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        //         child: Divider(
        //           height: 0,
        //           thickness: 1.5,
        //           color: CustomColors.greyBorder,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  Column buildWorkOrderDetailsMainContentSectionColumn(String text,
      [CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start]) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: crossAxisAlignment,
      children: <Widget>[
        buildWorkOrderDetailsMainContentSectionNameAndValue(text),
      ],
    );
  }

  Container buildWorkOrderDetailsMainContentSectionNameAndValue(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      alignment: Alignment.topLeft,
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 18,
        ),
      ),
    );
  }

  Column workOrderDetailsMainTopSection(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
                AppLocalizations.of(context)!
                        .translate('work.order.details.title') +
                    ': ' +
                    workOrder.orderId.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Theme.of(context).colorScheme.primary,
                )),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Text(
            workOrder.workOrderClass!.description.toString(),
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: Divider(
                  thickness: 1.5,
                  color: CustomColors.greyBorder,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _loadWorkOrderDetailsAttachments() {
    return BlocConsumer<WorkOrderCubit, WorkOrderState>(
      builder: (context, state) {
        if (state is WorkOrderLoading) {
          return buildLoading(context);
        } else if (state is WorkOrderLoaded) {
          var workOrderAttachedFiles = state.workOrder.attachedFiles;
          if (workOrderAttachedFiles.length > 0) {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 5,
                    top: 30,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('work.order.details.attachment'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (index < workOrderAttachedFiles.length) {
                      return BuildDownloadAttachmentRow(
                        fileType: workOrderAttachedFiles[index].type,
                        workorderReference:
                            workOrderAttachedFiles[index].reference,
                        sequenceId: workOrderAttachedFiles[index].sequenceId,
                        fileName: workOrderAttachedFiles[index].name,
                        workOrder: workOrder,
                      );
                    }
                    return buildLoading(context);
                  },
                  itemCount: workOrderAttachedFiles.length,
                ),
              ],
            );
          } else {
            return buildEmpty();
          }
        } else {
          return buildEmpty();
        }
      },
      listener: (context, state) {
        if (state is WorkOrderImageDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 2),
              content: Text(AppLocalizations.of(context)!
                  .translate('work.order.attachments.deleted.order.details')),
              backgroundColor: CustomColors.buttonGreen,
            ),
          );
        }
        if (state is WorkOrderAttachmentAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 2),
              content: Text(AppLocalizations.of(context)!
                  .translate('work.order.attachments.added.order.details')),
              backgroundColor: CustomColors.buttonGreen,
            ),
          );
        }
        if (state is AddWorkOrderAttachmentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 2),
              content: Text(
                AppLocalizations.of(context)!
                    .translate('work.order.attachments.order.details.error'),
              ),
              backgroundColor: CustomColors.deleteBackgroundColor,
            ),
          );
        }
      },
    );
  }

  Widget _loadWorkOrderDetailsBlocks() {
    return BlocConsumer<WorkOrderCubit, WorkOrderState>(
      listener: (context, state) {
        if (state is WorkOrderLoaded) {
          costTypesList = state.costTypes;
        }
        if (state is WorkOrderDetailsDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 2),
              content: Text(AppLocalizations.of(context)!
                  .translate('work.order.delete.order.details')),
              backgroundColor: CustomColors.buttonGreen,
            ),
          );
        }
        if (state is WorkOrderDetailsAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 2),
              content: Text(AppLocalizations.of(context)!
                  .translate('work.order.add.order.details')),
              backgroundColor: CustomColors.buttonGreen,
            ),
          );
        }
        if (state is WorkOrderDetailsEdited) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 2),
              content: Text(AppLocalizations.of(context)!
                  .translate('work.order.update.order.details')),
              backgroundColor: CustomColors.buttonGreen,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is WorkOrderLoading) {
          return buildLoading(context);
        } else if (state is WorkOrderLoaded) {
          var workOrderDetails = state.workOrder.details;

          if (workOrderDetails.length > 0) {
            return Padding(
              padding: EdgeInsets.only(right: 20, left: 20),
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  switch (getLineTypeEnum(workOrderDetails[index].lineType!)
                      .toLowerCase()) {
                    case "article":
                      return _workOrderProductArticle(workOrderDetails[index],
                          state.workOrder, workOrderCubit);
                    case "special":
                      return _workOrderProductArticle(workOrderDetails[index],
                          state.workOrder, workOrderCubit);
                    case "costs":
                      return _workOrderProductCosts(workOrderDetails[index],
                          state.workOrder, workOrderCubit, costTypesList);
                    case "text":
                      return _workOrderProductText(workOrderDetails[index],
                          state.workOrder, workOrderCubit);
                    case "hours":
                      return _workOrderProductHours(workOrderDetails[index],
                          state.workOrder, workOrderCubit);
                    default:
                      return _workOrderProductText(workOrderDetails[index],
                          state.workOrder, workOrderCubit);
                  }
                },
                separatorBuilder: (context, index) {
                  return buildEmpty();
                },
                itemCount: workOrderDetails.length,
              ),
            );
          } else if (state is WorkOrderError) {
            return buildEmpty();
          } else {
            return buildNoContentColumn(
                context,
                AppLocalizations.of(context)!
                    .translate('work.order.no.order.details.available'));
          }
        } else {
          return buildEmpty();
        }
      },
    );
  }

  Widget _workOrderProductArticle(V112WorkOrderDetail workOrderDetail,
      V112WorkOrder workOrder, WorkOrderCubit? workOrderCubit) {
    return WorkOrderBlockArticle(
        workOrderDetail: workOrderDetail,
        workOrder: workOrder,
        workOrderCubit: workOrderCubit);
  }

  Widget _workOrderProductCosts(
      V112WorkOrderDetail workOrderDetail,
      V112WorkOrder workOrder,
      WorkOrderCubit workOrderCubit,
      List<CostType> costTypesList) {
    return WorkOrderBlockCosts(
        workOrderDetail: workOrderDetail,
        workOrder: workOrder,
        costTypesList: costTypesList);
  }

  Widget _workOrderProductText(V112WorkOrderDetail workOrderDetail,
      V112WorkOrder workOrder, WorkOrderCubit? workOrderCubit) {
    return WorkOrderBlockText(
        workOrderDetail: workOrderDetail,
        workOrder: workOrder,
        workOrderCubit: workOrderCubit);
  }

  Widget _workOrderProductHours(V112WorkOrderDetail workOrderDetail,
      V112WorkOrder workOrder, WorkOrderCubit? workOrderCubit) {
    return WorkOrderBlockHours(
        workOrderDetail: workOrderDetail,
        workOrder: workOrder,
        workOrderCubit: workOrderCubit);
  }

  Widget navigationBar() {
    return Container(
      height: 100.0,
      decoration: BoxDecoration(
        color: CustomColors.evenRow,
        border: Border.all(
          width: 1,
          color: CustomColors.greyBorder,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(
            5.0,
          ),
        ),
      ),
      child: TabBar(
        isScrollable: Responsive.isMobile(context) ? true : false,
        unselectedLabelColor: Colors.white.withOpacity(0.3),
        tabs: [
          Tab(
            //photo
            child: Text(
              AppLocalizations.of(context)!
                  .translate('work.order.details.bottom.navigation.bar.foto'),
              style: TextStyle(fontSize: 15.0, color: CustomColors.black),
            ),
            icon: Icon(
              FontAwesomeIcons.camera,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Tab(
            //hours
            child: Text(
              AppLocalizations.of(context)!
                  .translate('work.order.details.bottom.navigation.bar.hours'),
              style: TextStyle(fontSize: 15.0, color: CustomColors.black),
            ),
            icon: Icon(
              FontAwesomeIcons.clock,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Tab(
            //cost
            child: Text(
              AppLocalizations.of(context)!
                  .translate('work.order.details.bottom.navigation.bar.costs'),
              style: TextStyle(fontSize: 15.0, color: CustomColors.black),
            ),
            icon: Icon(
              FontAwesomeIcons.euroSign,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Tab(
            //product
            child: Text(
              AppLocalizations.of(context)!.translate(
                  'work.order.details.bottom.navigation.bar.article'),
              style: TextStyle(fontSize: 15.0, color: CustomColors.black),
            ),
            icon: Icon(
              FontAwesomeIcons.cube,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Tab(
            //text
            child: Text(
              AppLocalizations.of(context)!
                  .translate('work.order.details.bottom.navigation.bar.text'),
              style: TextStyle(fontSize: 15.0, color: CustomColors.black),
            ),
            icon: Icon(
              FontAwesomeIcons.edit,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
        onTap: (int) async {
          switch (int) {
            case 0:
              checkForCameraPermission();
              break;
            case 1: //hours
              Navigator.of(context).pushNamed(
                workOrderAddHoursRoute,
                arguments: {
                  'workOrderCubit': context.read<WorkOrderCubit>(),
                  'workOrder': workOrder,
                  'workOrderDetailRequest': workOrderDetailRequest
                },
              );
              break;
            case 2: //cost
              addWorkOrderCostDialog(
                  context,
                  "add",
                  context.read<WorkOrderCubit>(),
                  workOrderDetailRequest,
                  "cost",
                  costTypesList,
                  null);
              break;
            case 3: //product
              Navigator.of(context).pushNamed(
                workOrderAddProductRoute,
                arguments: {
                  'workOrderCubit': context.read<WorkOrderCubit>(),
                  'workOrder': workOrder,
                  'workOrderDetailRequest': workOrderDetailRequest,
                },
              );
              break;
            case 4: //text
              addWorkOrderTextDialog(
                  context,
                  "Werkorder tekst toevoegen",
                  context.read<WorkOrderCubit>(),
                  workOrderDetailRequest,
                  "text");
              break;

            default:
            // ignore: unnecessary_statements
          }
        },
      ),
    );
  }

  checkForCameraPermission() async {
    if (await Permission.storage.request().isGranted) {
      return Navigator.of(context).pushNamed(
        workOrderPhotoRoute,
        arguments: {
          'workOrderCubit': context.read<WorkOrderCubit>(),
          'workOrder': workOrder,
          'workOrderDetailRequest': workOrderDetailRequest
        },
      );
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

  refreshpage() {
    setState(() {});
  }

  // temporary disabled
  Widget _loadPricingWorkOrderProducts(V112WorkOrder workOrder) {
    double totalExclVat = 0, totalInclVat = 0, vat = 0;
    var lines = workOrder;
    if (lines.details!.length > 0) {
      totalExclVat = totalExclVat + lines.netAmount!.value!;
      // vat = totalInclVat - totalExclVat;
      // for (var line in lines) {
      //   totalExclVat = totalExclVat + line.cost!.amount!.value1;
      //   totalInclVat = totalInclVat + line.totalIncludingVat!;
      //   vat = totalInclVat - totalExclVat;
      // }
    }

    double fontSize = 16.0;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.evenRow,
          border: Border.all(
            width: 1,
            color: CustomColors.greyBorder,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(
              5.0,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate('work.order.details.total.excl'),
                              style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              AppLocalizations.of(context)!
                                      .translate('work.order.details.euro') +
                                  totalExclVat.toStringAsFixed(2),
                              style: TextStyle(
                                fontSize: fontSize,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate('work.order.details.btw'),
                              style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              AppLocalizations.of(context)!
                                      .translate('work.order.details.euro') +
                                  vat.toStringAsFixed(2),
                              style: TextStyle(
                                fontSize: fontSize,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate('work.order.details.total.incl'),
                              style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              AppLocalizations.of(context)!
                                      .translate('work.order.details.euro') +
                                  totalInclVat.toStringAsFixed(2),
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
