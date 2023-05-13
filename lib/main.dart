import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:newsapp/layout/news_app/cubit/cubit.dart';
import 'package:newsapp/layout/news_app/cubit/states.dart';
import 'package:newsapp/layout/news_app/news_layout.dart';
import 'package:newsapp/shared/network/remote/cacheHelper.dart';
import 'package:newsapp/shared/network/remote/dio_helper.dart';

void main() async{
WidgetsFlutterBinding.ensureInitialized();
  //  Bloc.observer = MyBlocObserver();
    DioHelper.init();
    await cacheHelper.init();
    bool? isDark=cacheHelper.getData(key: 'isDark');
  runApp( MyApp( isDark: isDark!,));
}

class MyApp extends StatelessWidget {
  MyApp( {super.key, required this.isDark});
  final bool isDark;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers:
        [
          BlocProvider(
            create: (context) => NewsCubit()
              ..getBusiness()
              ..getSports()
              ..getScience(),
          ),
          BlocProvider(
            create: (BuildContext context) => NewsCubit()
              ..changeMode(fromShared: isDark),
          ),
        ],
      child:BlocConsumer<NewsCubit,NewsStates>(
        listener:(context,state){} ,
        builder: (context,state){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primarySwatch:Colors.deepOrange ,
                scaffoldBackgroundColor: Colors.white,
                appBarTheme:const  AppBarTheme(
                    backwardsCompatibility: false,
                    systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: Colors.white,
                      statusBarIconBrightness:Brightness.dark,
                    ),
                    backgroundColor: Colors.white,
                    elevation: 0.0,
                    titleTextStyle: TextStyle(

                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    )

                ),
                iconTheme:IconThemeData(
                  color: Colors.black,
                ),
                floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  backgroundColor: Colors.deepOrange,
                ),
                bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Colors.deepOrange,
                  unselectedItemColor: Colors.grey,
                  elevation: 20.0,
                  backgroundColor: Colors.white,
                ),
                textTheme: TextTheme(
                    bodyLarge: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    )
                )
            ), //the light system theme
            darkTheme: ThemeData( //the dark system theme
                primarySwatch:Colors.deepOrange ,
                scaffoldBackgroundColor:HexColor('333739'),
                appBarTheme: AppBarTheme(
                  titleSpacing: 20.0,
                    backwardsCompatibility: false,
                    systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: HexColor('333739'),
                      statusBarIconBrightness:Brightness.light,
                    ),
                    backgroundColor: HexColor('333739'),
                    elevation: 0.0,
                    titleTextStyle:TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    iconTheme:IconThemeData(
                      color: Colors.white,
                    )
                ),

                floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  backgroundColor: Colors.deepOrange,
                ),
                bottomNavigationBarTheme:  BottomNavigationBarThemeData(
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Colors.deepOrange,
                  unselectedItemColor: Colors.grey,
                  elevation: 20.0,
                  backgroundColor: HexColor('333739'),
                ),

                textTheme: TextTheme(
                    bodyLarge: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    )
                )
            ),
            themeMode: NewsCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,  //the switch themeMode


            home: NewsLayout(),
          );
        },
      )
    );
  }
}
