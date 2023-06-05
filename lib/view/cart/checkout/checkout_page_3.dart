import 'package:amazy_app/AppConfig/app_config.dart';
import 'package:amazy_app/controller/checkout_controller.dart';
import 'package:amazy_app/controller/payment_gateway_controller.dart';
import 'package:amazy_app/model/PaymentGatewayModel.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/view/cart/checkout/checkout_page_4.dart';
import 'package:amazy_app/view/cart/checkout/checkout_widgets.dart';
import 'package:amazy_app/widgets/CustomSliverAppBarWidget.dart';
import 'package:amazy_app/widgets/PinkButtonWidget.dart';
import 'package:amazy_app/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pay/pay.dart';

class CheckoutPageThree extends StatefulWidget {
  @override
  State<CheckoutPageThree> createState() => _CheckoutPageThreeState();
}

class _CheckoutPageThreeState extends State<CheckoutPageThree> {
  final PaymentGatewayController controller =
      Get.put(PaymentGatewayController());

  final CheckoutController _checkoutController = Get.put(CheckoutController());

  int radioSelector = 0;

  @override
  void initState() {
    // print(widget.data);
    super.initState();
  }

  bool selected = false;

  setSelectedMethod(Gateway gateWay) {
    setState(() {
      controller.selectedGateway.value = gateWay;
      selected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        slivers: [
          CustomSliverAppBarWidget(true, false),
          SliverToBoxAdapter(
            child: LinearProgressIndicator(
              value: 0.75,
              color: AppStyles.pinkColor,
              backgroundColor: Colors.white,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CheckoutTimelineWidget(
                    isActive: true,
                    text: "Address",
                  ),
                  CheckoutTimelineLineWidget(),
                  CheckoutTimelineWidget(
                    isActive: true,
                    text: "Shipping",
                  ),
                  CheckoutTimelineLineWidget(),
                  CheckoutTimelineWidget(
                    isActive: true,
                    text: "Payment",
                  ),
                  CheckoutTimelineLineWidget(),
                  CheckoutTimelineWidget(
                    isActive: false,
                    text: "Summary",
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: Obx(() {
              if (controller.isPaymentGatewayLoading.value) {
                return Center(child: Center(child: CustomLoadingWidget()));
              } else {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                          scrollDirection: Axis.vertical,
                          itemCount: controller.gatewayList.length,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 8,
                            );
                          },
                          itemBuilder: (BuildContext context, int position) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: controller.gatewayList[position] ==
                                            controller
                                                .gatewayList[radioSelector]
                                        ? Color.fromARGB(45, 253, 73, 73)
                                        : Colors.transparent,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                  ),
                                  child: RadioListTile<Gateway>(
                                    enableFeedback: false,
                                    value: controller.gatewayList[position],
                                    activeColor: AppStyles.pinkColor,
                                    groupValue:
                                        controller.selectedGateway.value,
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                    onChanged: (value) {
                                      setState(() {
                                        radioSelector = position;
                                      });
                                      setSelectedMethod(value);
                                      print('${value.id} = ${value.method}');
                                    },
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(controller
                                            .gatewayList[position].method),
                                        Expanded(child: Container()),
                                        Container(
                                          height: 35,
                                          width: 50,
                                          child: FadeInImage(
                                            image: NetworkImage(
                                                AppConfig.assetPath +
                                                    '/' +
                                                    controller
                                                        .gatewayList[position]
                                                        .logo),
                                            placeholder: AssetImage(
                                                "${AppConfig.appBanner}"),
                                            fit: BoxFit.fitWidth,
                                            imageErrorBuilder:
                                                (BuildContext context,
                                                    Object exception,
                                                    StackTrace stackTrace) {
                                              return Image.asset(
                                                  '${AppConfig.appBanner}');
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: Get.width,
                                height: 45,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppStyles.pinkColor,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 10,
                                  ),
                                  child: Text(
                                    "Back",
                                    textAlign: TextAlign.center,
                                    style: AppStyles.appFontBook.copyWith(
                                      color: AppStyles.pinkColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: PinkButtonWidget(
                              btnOnTap: () {
                                _checkoutController.orderData.addAll({
                                  'payment_method':
                                      controller.selectedGateway.value.id,
                                  'payment_method_name':
                                      controller.selectedGateway.value.method,
                                  'payment_method_logo':
                                      controller.selectedGateway.value.logo,
                                });

                                final _paymentItems = <PaymentItem>[];
                                if (controller.selectedGateway.value.id == 13) {
                                  _paymentItems.add(PaymentItem(
                                    amount: _checkoutController
                                        .orderData['grand_total']
                                        .toString(),
                                    label: "${AppConfig.appName}" + "Order",
                                    status: PaymentItemStatus.final_price,
                                  ));
                                }

                                Get.to(() => CheckoutPageFour(
                                      gpayItems: _paymentItems,
                                    ));
                              },
                              height: 45,
                              width: Get.width,
                              btnText: "Next",
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
