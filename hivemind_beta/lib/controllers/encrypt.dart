import 'dart:ffi' as ffi;
import 'dart:io' show Platform;

typedef KeyGen = ffi.Int Function(ffi.Pointer<ffi.Uint8> pk, ffi.Pointer<ffi.Uint8> sk);
typedef DartKeyGen = int Function(ffi.Pointer<ffi.Uint8> pk, ffi.Pointer<ffi.Uint8> sk);

typedef Enc = ffi.Int Function(ffi.Pointer<ffi.Uint8> ct, ffi.Pointer<ffi.Uint8> ss, ffi.Pointer<ffi.Uint8> pk);
typedef DartEnc = int Function(ffi.Pointer<ffi.Uint8> ct, ffi.Pointer<ffi.Uint8> ss, ffi.Pointer<ffi.Uint8> pk);

typedef Dec = ffi.Int Function(ffi.Pointer<ffi.Uint8> ss, ffi.Pointer<ffi.Uint8> ct, ffi.Pointer<ffi.Uint8> sk);
typedef DartDec = int Function(ffi.Pointer<ffi.Uint8> ss, ffi.Pointer<ffi.Uint8> ct, ffi.Pointer<ffi.Uint8> sk);


class NativeLibrary {
  late final ffi.DynamicLibrary _library;
  late final DartKeyGen keyGen;
  late final DartEnc enc;
  late final DartDec dec;

  NativeLibrary() {
    String libPath;

    if (Platform.isLinux) {
      libPath = 'libml-kem-512_clean.so';
    } else if (Platform.isWindows) {
      libPath = 'libml-kem-512_clean.dll';
    } else {
      print("INVALID OS");
      return;
    }

    _library = ffi.DynamicLibrary.open(libPath);

    keyGen = _library
                .lookup<ffi.NativeFunction<KeyGen>>('PQCLEAN_MLKEM512_CLEAN_crypto_kem_keypair')
                .asFunction();
    enc = _library
              .lookup<ffi.NativeFunction<Enc>>('PQCLEAN_MLKEM512_CLEAN_crypto_kem_enc')
              .asFunction();
    dec = _library
              .lookup<ffi.NativeFunction<Dec>>('PQCLEAN_MLKEM512_CLEAN_crypto_kem_dec')
              .asFunction();
  } 
  
}
