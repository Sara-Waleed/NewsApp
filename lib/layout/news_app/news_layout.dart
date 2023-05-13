import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/layout/news_app/cubit/cubit.dart';
import 'package:newsapp/layout/news_app/cubit/states.dart';

class NewsLayout extends StatelessWidget {
   NewsLayout({super.key});


  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<NewsCubit,NewsStates>(
        listener: (context, state){},
        builder: (context, state) {
          var cubit =NewsCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('News App'),
              centerTitle: false,
              actions: [
                IconButton(onPressed: (){}, icon: Icon(Icons.search,) ),
                IconButton(onPressed: (){
                  NewsCubit.get(context).changeMode();
                  }, icon:Icon(Icons.brightness_4_outlined,) ),
              ],
            ),
            body: cubit.screens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              items: cubit.bottomItems,
              currentIndex: cubit.currentIndex,
              onTap: (index){
                cubit.changeBottomNavBar(index);
              },
            ),

          );
        },


    );
  }
}
