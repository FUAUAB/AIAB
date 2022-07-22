import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mavis_api_client/api.dart';
import 'package:work_order_app/cubit/work_order/work_order_cubit.dart';
import 'package:work_order_app/presentation/styles/colors_style.dart';
import 'package:work_order_app/presentation/widgets/dialogs/dialog_notification.dart';

class BuildDownloadAttachmentRow extends StatefulWidget {
  final int fileType;
  final String workorderReference;
  final int sequenceId;
  final String fileName;
  final V112WorkOrder workOrder;

  const BuildDownloadAttachmentRow({
    Key? key,
    required this.fileType,
    required this.workorderReference,
    required this.sequenceId,
    required this.fileName,
    required this.workOrder,
  }) : super(key: key);

  _BuildDownloadAttachmentRowState createState() =>
      _BuildDownloadAttachmentRowState();
}

class _BuildDownloadAttachmentRowState
    extends State<BuildDownloadAttachmentRow> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkOrderCubit, WorkOrderState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Container(
            decoration: BoxDecoration(
              color: CustomColors.evenRow,
              border: Border.all(
                color: CustomColors.greyContainerBorder,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Text(widget.fileName),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(color: CustomColors.greyContainerBorder),
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      deleteAttachmentNotification(
                        context,
                        widget.fileName,
                        () {
                          context
                              .read<WorkOrderCubit>()
                              .deleteWorkOrderAttachment(
                                widget.fileType,
                                widget.workorderReference,
                                widget.sequenceId,
                                widget.workOrder.orderId,
                                widget.workOrder.companyId,
                                widget.workOrder.branchId,
                              );
                          Navigator.of(context).pop();
                        },
                      );
                    },
                    icon: Icon(
                      FontAwesomeIcons.solidTrashCan,
                      color: CustomColors.DeleteIcon,
                      size: 30,
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(color: CustomColors.greyContainerBorder),
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      context
                          .read<WorkOrderCubit>()
                          .downloadWorkOrderAttachment(
                            widget.fileType,
                            widget.workorderReference,
                            widget.sequenceId,
                            widget.fileName,
                            widget.workOrder.orderId,
                            widget.workOrder.companyId,
                            widget.workOrder.branchId,
                          );
                    },
                    icon: Icon(
                      FontAwesomeIcons.download,
                      color: Theme.of(context).colorScheme.primary,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
