// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/component/widgets.dart';
import 'package:shop_app/home_layout/screens/search/cubit/search_cubit.dart';

import '../../cubit/home_cubit.dart';

class Search extends StatelessWidget {
  var formKey = GlobalKey<FormState>();

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
             
              appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.blue),
               
                elevation: 0.0,
                title: Text(
                  'MarKet',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
              body: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      defaultFormField(
                        controller: searchController,
                        type: TextInputType.text,
                        label: 'Search',
                        suffix: Icons.search,
                        suffixPressed: () => SearchCubit.get(context)
                            .search(searchController.text),
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'please enter text to search';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      if (state is LoadingSearchState)
                        LinearProgressIndicator(),
                      SizedBox(
                        height: 10.0,
                      ),
                      // Container(
                      //   width: 110,
                      //   height: 55,
                      //   decoration: BoxDecoration(
                      //       color: Colors.blue,
                      //       borderRadius: BorderRadius.circular(8)),
                      //   child: MaterialButton(
                      //     onPressed: () {
                      //       if (formKey.currentState!.validate()) {
                      //         SearchCubit.get(context)
                      //             .search(searchController.text);
                      //       }
                      //     },
                      //     child: Text(
                      //       "Search",
                      //       style: TextStyle(
                      //         color: Colors.white,
                      //         fontSize: 20,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      if (state is SuccessSearchState)
                        Expanded(
                          child: ListView.separated(
                              itemBuilder: (context, index) => buildListProduct(
                                  isOldPrice: false,
                                  SearchCubit.get(context)
                                      .model!
                                      .data!
                                      .data![index],
                                  context),
                              separatorBuilder: (context, index) => myDivider(),
                              itemCount: SearchCubit.get(context)
                                  .model!
                                  .data!
                                  .data!
                                  .length),
                        ),
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }

  Widget buildListProduct(
    model,
    context, {
    bool isOldPrice = true,
  }) =>
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 120.0,
          child: Row(
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Image(
                    image: NetworkImage(model.image),
                    width: 120.0,
                    height: 120.0,
                  ),
                  if (model.discount != 0 && isOldPrice)
                    Container(
                      color: Colors.red,
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.0,
                      ),
                      child: Text(
                        'DISCOUNT',
                        style: TextStyle(
                          fontSize: 8.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(
                width: 20.0,
              ),
              Expanded(
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
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          model.price.toString(),
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        if (model.discount != 0 && isOldPrice)
                          Text(
                            model.oldPrice.toString(),
                            style: TextStyle(
                              fontSize: 10.0,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            HomeCubit.get(context).changeFavorites(model.id!);
                          },
                          icon: CircleAvatar(
                            backgroundColor:
                                HomeCubit.get(context).favorites[model.id]
                                    ? Colors.blue
                                    : Colors.grey,
                            radius: 15.0,
                            child: Icon(
                              Icons.favorite_border,
                              size: 14.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
