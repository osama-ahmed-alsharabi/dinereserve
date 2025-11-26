import 'package:dinereserve/core/helpers/service_locator.dart';
import 'package:dinereserve/core/model/restaurant_model.dart';
import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/feature/profile_restaurant/data/profile_restaurant_repo.dart';
import 'package:dinereserve/feature/profile_restaurant/presentation/view/widgets/edit_restaurant_form_widget.dart';
import 'package:dinereserve/feature/profile_restaurant/presentation/view/widgets/edit_restaurant_images_widget.dart';
import 'package:dinereserve/feature/profile_restaurant/presentation/view_model/EditRestaurant/edit_restaurant_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileRestaurantView extends StatefulWidget {
  final RestaurantModel restaurant;

  const EditProfileRestaurantView({super.key, required this.restaurant});

  @override
  State<EditProfileRestaurantView> createState() =>
      _EditProfileRestaurantViewState();
}

class _EditProfileRestaurantViewState extends State<EditProfileRestaurantView> {
  String? _newLogoPath;
  List<String> _newImagePaths = [];
  late RestaurantModel _currentRestaurant;

  @override
  void initState() {
    super.initState();
    _currentRestaurant = widget.restaurant;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          EditRestaurantCubit(GetRestaurantRepo(getIt.get<SupabaseClient>())),
      child: BlocConsumer<EditRestaurantCubit, EditRestaurantState>(
        listener: (context, state) {
          if (state is EditRestaurantSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Profile updated successfully")),
            );
            context.pop();
          } else if (state is EditRestaurantFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Edit Restaurant"),
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  EditRestaurantImagesWidget(
                    initialLogo: _currentRestaurant.logo,
                    initialImages: _currentRestaurant.images,
                    onLogoChanged: (path) {
                      _newLogoPath = path;
                    },
                    onImagesChanged: (paths) {
                      _newImagePaths = paths;
                    },
                    onDeleteImage: (url) {
                      setState(() {
                        final updatedImages = List<String>.from(
                          _currentRestaurant.images,
                        );
                        updatedImages.remove(url);
                        _currentRestaurant = _currentRestaurant.copyWith(
                          images: updatedImages,
                        );
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  EditRestaurantFormWidget(
                    restaurant: _currentRestaurant,
                    onUpdate: (updatedModel) {
                      // We only update the fields that the form manages.
                      // Images are managed by EditRestaurantImagesWidget and _newImagePaths.
                      setState(() {
                        _currentRestaurant = updatedModel;
                      });
                    },
                    onSave: () {
                      context.read<EditRestaurantCubit>().updateRestaurant(
                        restaurant: _currentRestaurant,
                        newLogoPath: _newLogoPath,
                        newImagePaths: _newImagePaths,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
