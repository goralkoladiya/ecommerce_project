import 'package:amazy_app/controller/order_controller.dart';
import 'package:amazy_app/model/Order/OrderData.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/NoOrderPlacedWidget.dart';
import 'widgets/OrderListDataWidget.dart';

class AllOrdersListScreen extends StatelessWidget {
  final OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    orderController.getAllOrders();

    return Obx(
      () {
        if (orderController.isAllOrderLoading.value) {
          return Center(
            child: CustomLoadingWidget(),
          );
        } else {
          if (orderController.allOrderListModel.value.orders == null ||
              orderController.allOrderListModel.value.orders.length == 0) {
            return NoOrderPlacedWidget();
          }
          return Container(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(
                  color: AppStyles.appBackgroundColor,
                  height: 5,
                  thickness: 5,
                );
              },
              itemCount: orderController.allOrderListModel.value.orders.length,
              itemBuilder: (context, index) {
                OrderData order =
                    orderController.allOrderListModel.value.orders[index];
                return OrderAllToPayListDataWidget(
                  order: order,
                );
              },
            ),
          );
        }
      },
    );
  }
}
