part of 'order_bloc.dart';

@immutable
sealed class OrderEvent {}

class PostOrderRequested extends OrderEvent {
  final List<Barang> cart;
  final String kodeOrder;
  final String idOutlet;
  final String kodeSales;
  final String namaSales;

  PostOrderRequested(
      this.cart, this.kodeOrder, this.idOutlet, this.kodeSales, this.namaSales);
}
