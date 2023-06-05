import 'package:amazy_app/controller/settings_controller.dart';
import 'package:amazy_app/model/Order/OrderData.dart';
import 'package:amazy_app/model/Order/Package.dart';
import 'package:amazy_app/model/Order/Process.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/widgets/CustomSliverAppBarWidget.dart';
import 'package:amazy_app/widgets/PinkButtonWidget.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';
import 'package:amazy_app/model/DeliveryProcess.dart';

class OrderTrack extends StatefulWidget {
  final List<DeliveryProcess> processes;
  final Package package;
  final OrderData order;

  OrderTrack({this.processes, this.package, this.order});

  @override
  _OrderTrackState createState() => _OrderTrackState();
}

class _OrderTrackState extends State<OrderTrack> {
  final GeneralSettingsController _settingsController =
      Get.put(GeneralSettingsController());
  @override
  void initState() {
    super.initState();
  }

  String getDeliveryDate(Package package) {
    var deliveryStateName = "";
    package.processes.forEach((element) {
      if (element.id == package.deliveryStatus) {
        deliveryStateName = element.name +
            " on ${DateFormat.yMMMd().add_jm().format(package.updatedAt)}";
      }
    });
    return deliveryStateName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        slivers: [
          CustomSliverAppBarWidget(true, true),
          SliverFillRemaining(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Track Order",
                  style: AppStyles.appFontBold.copyWith(fontSize: 18),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PinkButtonWidget(
                      btnText:
                          "${widget.package.shippingDate.replaceAll("Est. Arrival Date: ", "")}",
                      height: 40,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Amount".tr + ":",
                          style: AppStyles.appFontBook.copyWith(
                            fontSize: 14,
                            color: AppStyles.pinkColor,
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "${widget.order.grandTotal * _settingsController.conversionRate.value} ${_settingsController.appCurrency.value}",
                          style: AppStyles.appFontBold.copyWith(
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "${DateFormat.yMMMd().format(widget.package.createdAt)}",
                  style: AppStyles.appFontBook.copyWith(
                    fontSize: 14,
                    color: AppStyles.greyColorAlt,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: 'Order ID:',
                              style: AppStyles.appFontMedium
                                  .copyWith(fontSize: 16)),
                          TextSpan(
                            text: ' ${widget.order.orderNumber}',
                            style: AppStyles.appFontMedium.copyWith(
                              fontSize: 16,
                              color: AppStyles.pinkColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        FlutterClipboard.copy('${widget.package.packageCode}')
                            .then((value) =>
                                print('copied: ${widget.package.packageCode}'));
                      },
                      child: Image.asset(
                        "assets/images/copy.png",
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                // ** Shipping Address //
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Shipping Address".tr,
                      style: AppStyles.appFontMedium.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${widget.order.shippingAddress.name ?? ""}',
                      style: AppStyles.appFontBook.copyWith(
                        fontSize: 14,
                        color: AppStyles.greyColorAlt,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      '${widget.order.shippingAddress.email ?? ""}',
                      style: AppStyles.appFontBook.copyWith(
                        fontSize: 14,
                        color: AppStyles.greyColorAlt,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      '${widget.order.shippingAddress.phone ?? ""}',
                      style: AppStyles.appFontBook.copyWith(
                        fontSize: 14,
                        color: AppStyles.greyColorAlt,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      '${widget.order.shippingAddress.address ?? ""}',
                      style: AppStyles.appFontBook.copyWith(
                        fontSize: 14,
                        color: AppStyles.greyColorAlt,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),

                // ** Billing Address //
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Billing Address".tr,
                      style: AppStyles.appFontMedium.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${widget.order.billingAddress.name ?? ""}',
                      style: AppStyles.appFontBook.copyWith(
                        fontSize: 14,
                        color: AppStyles.greyColorAlt,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      '${widget.order.billingAddress.email ?? ""}',
                      style: AppStyles.appFontBook.copyWith(
                        fontSize: 14,
                        color: AppStyles.greyColorAlt,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      '${widget.order.billingAddress.phone ?? ""}',
                      style: AppStyles.appFontBook.copyWith(
                        fontSize: 14,
                        color: AppStyles.greyColorAlt,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      '${widget.order.billingAddress.address ?? ""}',
                      style: AppStyles.appFontBook.copyWith(
                        fontSize: 14,
                        color: AppStyles.greyColorAlt,
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 10,
                ),

                widget.package.deliveryStates.length != 0
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: FixedTimeline.tileBuilder(
                          verticalDirection: VerticalDirection.down,
                          theme: TimelineThemeData(
                            color: Color(0xffF5F1FE),
                            nodePosition: 0.3,
                            connectorTheme:
                                ConnectorThemeData(thickness: 1.5, indent: 0.1),
                          ),
                          builder: TimelineTileBuilder.connected(
                            connectionDirection: ConnectionDirection.after,
                            itemCount: widget.package.deliveryStates.length,
                            contentsBuilder: (_, index) {
                              String getDeliveryStateName(
                                  List<Process> process) {
                                var stateName = "";
                                process.forEach((element) {
                                  if (widget.package.deliveryStates[index]
                                          .deliveryStatus ==
                                      element.id) {
                                    stateName = element.name;
                                  }
                                });
                                return stateName;
                              }

                              return Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      getDeliveryStateName(
                                          widget.package.processes),
                                      style: AppStyles.appFontMedium.copyWith(
                                        color: Color(0xff5C7185),
                                      ),
                                    ),
                                    Text(
                                      widget.package.deliveryStates[index]
                                              .note ??
                                          getDeliveryStateName(
                                              widget.package.processes),
                                      style: AppStyles.appFontBook.copyWith(
                                        fontSize: 12,
                                        color: Color(0xff969599),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            oppositeContentsBuilder: (_, index) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "${DateFormat.yMMMd().format(widget.package.deliveryStates[index].createdAt)}",
                                          style:
                                              AppStyles.appFontMedium.copyWith(
                                            color: Color(0xff5C7185),
                                            fontSize: 13,
                                          ),
                                        ),
                                        Text(
                                          "${DateFormat.jm().format(widget.package.deliveryStates[index].createdAt)}",
                                          style:
                                              AppStyles.appFontMedium.copyWith(
                                            color: Color(0xff969599),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ],
                              );
                            },
                            indicatorBuilder: (_, index) {
                              if (widget.package.deliveryStates.last ==
                                  widget.package.deliveryStates[index]) {
                                return Container(
                                  height: 24,
                                  width: 24,
                                  decoration: BoxDecoration(
                                    color: AppStyles.pinkColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 12.0,
                                  ),
                                );
                              } else if (widget.package.deliveryStates.last !=
                                  widget.package.deliveryStates[index]) {
                                return Container(
                                  height: 24,
                                  width: 24,
                                  decoration: BoxDecoration(
                                    color: Color(0xffE1E1E2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 12.0,
                                  ),
                                );
                              } else {
                                return OutlinedDotIndicator(
                                  borderWidth: 2.5,
                                );
                              }
                            },
                            connectorBuilder: (_, index, ___) =>
                                SolidLineConnector(
                              color: widget.package.deliveryStates.last !=
                                      widget.package.deliveryStates[index]
                                  ? AppStyles.pinkColor
                                  : Colors.red,
                            ),
                          ),
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
