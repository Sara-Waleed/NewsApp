//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:newsapp/layout/cubit/states.dart';
import 'package:newsapp/layout/news_app/cubit/states.dart';
import 'package:newsapp/modules/modules.bussiness/businessscreen.dart';
import 'package:newsapp/modules/modules.science/sciencescreen.dart';
import 'package:newsapp/modules/modules.sports/sportscreen.dart';
import 'package:newsapp/shared/network/remote/cacheHelper.dart';
import 'package:newsapp/shared/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates> {

  NewsCubit() :super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<BottomNavigationBarItem> bottomItems = [
     BottomNavigationBarItem(
      icon: Icon(Icons.business,),
      label: 'Business',
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.sports,
      ),
      label: 'Sports',
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.science,
      ),
      label: 'Science',
    ),

  ];
  List<Widget> screens = [
    BusinessScreen(),
    SportScreen(),
    ScienceScreen(),

  ];
  List< dynamic> business=[];

void getBusiness(){
  emit(NewsLoadingState());
  DioHelper.getData(
      url: 'v2/top-headlines',
      queryParameters:{
        "country":'eg',
        'category':'business',
        'apiKey':'65f7f556ec76449fa7dc7c0069f040ca'},
  ).then((value) {
   // print(value.data['articles'][0]['title']);
business=value.data['articles'];
print(business[0]['title']);
emit(NewsGetBusinessSuccessState());
  }).catchError((error){
    print(error.toString());
    emit(NewsGetBusinessErrorState(error.toString()));
  });
}

  List< dynamic> sports=[];

  void getSports(){
    emit(NewsSportsLoadingState());
    if(sports.length==0){
      DioHelper.getData(
          url: 'v2/top-headlines',
          queryParameters:{
            "country":'eg',
            'category':'Sports',
            'apiKey':'65f7f556ec76449fa7dc7c0069f040ca'}
      ).then((value) {
        // print(value.data['articles'][0]['title']);
        sports=value.data['articles'];
        print(sports[0]['title']);
        emit(NewsGetSportsSuccessState());
      }).catchError((error){
        print(error.toString());
        emit(NewsGetSportsErrorState(error.toString()));
      });
    }else{
      emit(NewsGetSportsSuccessState());
    }

  }

  List< dynamic> science=[];

  void getScience(){
    emit(NewsScienceLoadingState());
    if(science.length==0){
      DioHelper.getData(
          url: 'v2/top-headlines',
          queryParameters:{
            "country":'eg',
            'category':'science',
            'apiKey':'65f7f556ec76449fa7dc7c0069f040ca'}
      ).then((value) {
        // print(value.data['articles'][0]['title']);
        science=value.data['articles'];
        print(science[0]['title']);
        emit(NewsGetScienceSuccessState());
      }).catchError((error){
        print(error.toString());
        emit(NewsGetScienceErrorState(error.toString()));
      });
    }else{
      emit(NewsGetScienceSuccessState());
    }

  }

  void changeBottomNavBar(int index) {
    currentIndex = index;
    if(index == 1)
      getSports();
    if(index == 2)
      getScience();
    emit(NewsBottomNavState());
  }

bool isDark=false;
  ThemeMode appMode=ThemeMode.dark;
  void changeMode( {bool? fromShared}){
    if(fromShared !=null){
      isDark=fromShared;

    }
    else{
    isDark =  !isDark;}
    cacheHelper.putData(key: 'isDark', value: isDark).then((value)
    {
      emit(NewsChangeModeState());
    });
  }





  List<dynamic> search = [];

  void getSearch(String value)
  {
    emit(NewsGetSearchLoadingState());

    DioHelper.getData(
      url: 'v2/everything',
      queryParameters:
      {
        'q':'$value',
        'apiKey':'65f7f556ec76449fa7dc7c0069f040ca',
      },
    ).then((value)
    {
      //print(value.data['articles'][0]['title']);
      search = value.data['articles'];
      print(search[0]['title']);

      emit(NewsGetSearchSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(NewsGetSearchErrorState(error.toString()));
    });
  }
}


