import 'package:fpdart/fpdart.dart';
import 'package:research/common/error_failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
