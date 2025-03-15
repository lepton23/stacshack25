import 'dart:ffi';

typedef NativeKeyGen = Int Function(Pointer pk, Pointer sk);
typedef DartKeyGen = int Function(int pk, int sk);

