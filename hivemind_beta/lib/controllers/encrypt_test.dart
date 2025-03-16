import 'dart:ffi';
import 'package:ffi/ffi.dart';

import 'encrypt.dart';

NativeLibrary _lib = NativeLibrary();

int main() {

  final res = using((arena) {
    final pk_ptr = arena.allocate<Uint8>(sizeOf<Uint8>());
    final sk_ptr = arena.allocate<Uint8>(sizeOf<Uint8>());
    _lib.keyGen(pk_ptr, sk_ptr);

    final pk = pk_ptr.value;
    final sk = sk_ptr.value;

    print(pk);
    print(sk);

    Pointer<Uint8> ss_ptr = "Yabbadabbadoo".toNativeUtf8(allocator: arena).cast<Uint8>();
    Pointer<Uint8> ct_ptr = arena.allocate<Uint8>(sizeOf<Uint8>());

    _lib.enc(ss_ptr, ct_ptr, pk_ptr);

    final ct = ct_ptr.value;
    print(ct);
    
    final ss_recv = arena.allocate<Uint8>(sizeOf<Uint8>());

    _lib.dec(ct_ptr, ss_ptr, sk_ptr);

    final ss = ss_recv.value;
    print(ss);

    return ct;

  });

  print(res);

  return 0;
}