import 'package:go_router/go_router.dart';
import 'pages/form_page.dart';
import 'pages/list_page.dart';

final GoRouter router = GoRouter(
  routes:[
    GoRoute(
      path: '/',
      builder: (context, state) => const ListPage()
    ),
    GoRoute(
      path: '/form',
      builder: (context, state) => const FormPage()
    ),
    GoRoute(
      path: '/form/:id',
      builder: (context, state){
        final id = state.pathParameters['id'];
        return FormPage(id: id,);
      }),
  ]);