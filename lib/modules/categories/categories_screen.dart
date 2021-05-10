import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/cubit.dart';
import 'package:shop_app/shared/states.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView.separated(
          itemBuilder: (context, index) => buildCategoryItem(context, AppCubit.get(context).categoriesModel.data.data[index]),
          separatorBuilder: (context, index) => myDivider(),
          itemCount: AppCubit.get(context).categoriesModel.data.data.length,
        );
      },
    );
  }

  Widget buildCategoryItem(context, DataModel model) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Image(
              image: NetworkImage(
                  model.image,),
              width: MediaQuery.of(context).size.width * 0.22,
              height: MediaQuery.of(context).size.height * 0.15,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              model.name,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      );
}