import 'package:book_shop/config/routs/routs_names.dart';
import 'package:book_shop/core/utils/extintions.dart';
import 'package:book_shop/core/utils/styles.dart';
import 'package:book_shop/screens/cart_screen/ui/widget/adress_widget.dart';
import 'package:book_shop/screens/payment_screen/logic/payment_cubit.dart';
import 'package:book_shop/services/services_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widget/app_buttons.dart';
import '../logic/card_screen_cubit.dart';
import 'widget/date_time_widget.dart';
import 'widget/payment_widget.dart';
import 'widget/summary_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: locator<CardScreenCubit>()..getCartDetails(),
        ),
        BlocProvider.value(
          value: locator<PaymentCubit>(),
        )
      ],
      child: const ConfirmOrderScreen(),
    );
  }
}

class ConfirmOrderScreen extends StatelessWidget {
  const ConfirmOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(
          'Confirm Order',
          style: TextStyles.font18BlackBold(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {
              // TODO: Implement edit action
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const AddressWidget(),
          const SizedBox(height: 16),
          const SummaryWidget(),
          const SizedBox(height: 16),
          const DateTimeWidget(),
          const SizedBox(height: 16),
          const PaymentWidget(),
          const SizedBox(height: 16),
          primaryButton(title: 'Ordered', borderRadius: 50, verticalHeight: 15)
              .onTap(() {
            print(context.read<PaymentCubit>().paymentName);

            if (context.read<CardScreenCubit>().dateTimeString != null &&
                //context.read<CardScreenCubit>().addresses != null &&
                context.read<PaymentCubit>().paymentName != null) {
              context.navigateTo(RouteName.STATUSORDER);
              context.read<CardScreenCubit>().addDeliveryTimeAndLocation();
            } else {
              if (context.read<CardScreenCubit>().dateTimeString == null) {
                context.read<CardScreenCubit>().changeIsTimeTaken();
              }
              // if (context.read<CardScreenCubit>().addresses == null) {
              //   context.read<CardScreenCubit>().changeIsLocated();
              // }
              if (context.read<PaymentCubit>().paymentName == null) {
                context.read<PaymentCubit>().changeIsPayment(false);
              }
            }
          })
        ],
      ),
    );
  }
}
