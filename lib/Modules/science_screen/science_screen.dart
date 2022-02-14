import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_application/Shared/components/components.dart';
import 'package:news_application/Shared/cubit/news_cubit.dart';
import 'package:news_application/Shared/cubit/news_states.dart';


class ScienceScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (context, state){},
      builder: (context, state)
      {
        var list = NewsCubit.get(context).science;

        return articleBuilder(list, context);
      },
    );
  }
}