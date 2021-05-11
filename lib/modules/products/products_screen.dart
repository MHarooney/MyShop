import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/shared/cubit.dart';
import 'package:shop_app/shared/states.dart';
import 'package:shop_app/styles/colors.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: AppCubit
              .get(context)
              .homeModel != null && AppCubit
              .get(context)
              .categoriesModel != null,
          builder: (context) =>
              builderWidget(AppCubit
                  .get(context)
                  .homeModel, context, AppCubit
                  .get(context)
                  .categoriesModel),
          fallback: (context) =>
              Center(
                child: CircularProgressIndicator(),
              ),
        );
      },
    );
  }

  Widget builderWidget(HomeModel homeModel, context,
      CategoriesModel categoriesModel) =>
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: homeModel.data.banners
                  .map(
                    (e) =>
                    Image(
                      image: NetworkImage('${e.image}'),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              )
                  .toList(),
              options: CarouselOptions(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.25,
                initialPage: 0,
                viewportFraction: 1.0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(seconds: 1),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.15,
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) =>
                          buildCategoryItems(
                              context, categoriesModel.data.data[index]),
                      separatorBuilder: (context, index) =>
                          SizedBox(
                            width: 10.0,
                          ),
                      itemCount: categoriesModel.data.data.length,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'New Products',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.grey[300],
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0,
                childAspectRatio: 1 / 1.72,
                children: List.generate(
                  homeModel.data.products.length,
                      (index) =>
                      buildGridProduct(
                        homeModel.data.products[index], context,),
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildCategoryItems(context, DataModel model) =>
      Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Image(
            image: NetworkImage(
                model.image),
            width: MediaQuery
                .of(context)
                .size
                .width * 0.26,
            height: MediaQuery
                .of(context)
                .size
                .height * 0.15,
            fit: BoxFit.cover,
          ),
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.26,
            color: Colors.black.withOpacity(
              .8,
            ),
            child: Text(
              model.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      );

  Widget buildGridProduct(ProductModel model, context) =>
      Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              // alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage(model.image),
                  width: double.infinity,
                  height: 200.0,
                  // fit: BoxFit.cover,
                ),
                if (model.discount != 0)
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Image.asset(
                      'assets/images/discount.png',
                      width: 30.0,
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.0,
                      height: 1.3,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${model.price.round()}',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: defaultColor,
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      if (model.discount != 0)
                        Text(
                          '${model.oldPrice.round()}',
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.red,
                            decorationThickness: 2.0,
                          ),
                        ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          AppCubit.get(context).changeFavorites(model.id);
                          print(model.id);
                        },
                        icon: Icon(
                          Icons.favorite,
                          color: AppCubit
                              .get(context)
                              .favorites[model.id] ? Colors.red : Colors.grey,
                          size: 22.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}