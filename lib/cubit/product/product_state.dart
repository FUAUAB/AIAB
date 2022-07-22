part of 'product_cubit.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoading extends ProductState {
  const ProductLoading();
}

class ProductLoaded extends ProductState {
  final Product product;

  const ProductLoaded(this.product);

  @override
  List<Object> get props => [this.product];
}

class ProductListLoading extends ProductState {
  const ProductListLoading();
}

class ProductListLoaded extends ProductState {
  final List<V13ShopProduct> products;

  const ProductListLoaded(this.products);

  @override
  List<Object> get props => [this.products];
}

class ProductUpdateLoading extends ProductState {
  const ProductUpdateLoading();
}

class ProductError extends ProductState {
  final String errorMessage;

  const ProductError(this.errorMessage);

  @override
  List<Object> get props => [this.errorMessage];
}
