import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountDeleteDialogue extends StatelessWidget {
  final Function() onYesTap;

  const AccountDeleteDialogue({
    @required this.onYesTap,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return CupertinoAlertDialog(
      title: const Text('Confirmation'),
      content: Text('Are you sure want to delete account?'),
      actions: [
        TextButton(
            onPressed: ()=> Get.back(),
            child: Text('CANCEL')
        ),
        TextButton(
            onPressed: () async {
              Get.back();
              await 500.milliseconds.delay();
              onYesTap.call();
            },
            child: Text('DELETE')
        ),
      ],
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 32,
          ),
          Text(
            'Are you really want to delete your account?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(
            height: 32,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onYesTap,
                child: Text('Yes', style: TextStyle(color: Colors.red),),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('No'),
              ),
            ],
          ),
          SizedBox(
            height: 36,
          ),
        ],
      ),
    );
  }
}


