import 'package:dinereserve/feature/advertisement/presentation/view/widgets/add_advertisement_body_widget.dart';
import 'package:dinereserve/feature/advertisement/presentation/view_model/add_advertisement_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAdvertisementView extends StatelessWidget {
  const AddAdvertisementView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddAdvertisementCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "New Advertisement",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: AddAdvertisementBodyWidget(),
      ),
    );
  }
}
