import 'dart:io';
import 'dart:convert';

class KeyPair<T1, T2> {
  final String pk;
  final String sk;

  KeyPair(this.pk, this.sk);

  String getPk() {return this.pk;}
  String getSk() {return this.sk;}
}

class Pair<T1, T2> {
  final String ss;
  final String ct;

  Pair(this.ss, this.ct);

  String getSs() {return this.ss;}
  String getCt() {return this.ct;}
}

Future<KeyPair> keyGen() async {
  var process = await Process.start('./mlkem512', ['keygen']);

  final List<String> output = []; 

  process.stdout
        .transform(Utf8Decoder())
        .forEach(output.add);

  final outputCat = output.join("\n");

  final String pk = outputCat.split(' ')[0];
  final String sk = outputCat.split(' ')[1];

  return (KeyPair(pk, sk));
}

Future<Pair> encrypt(String pk) async {
  var process = await Process.start('./mlkem512', ['enc', 'pk']);

  final List<String> output = [];

 process.stdout
        .transform(Utf8Decoder())
        .forEach(output.add);

  final outputCat = output.join("\n");

  final String ss = outputCat.split(' ')[0];
  final String ct = outputCat.split(' ')[1];

  return (Pair(ss, ct)); 
}

Future<String> decrypt(String ct, String sk) async {
var process = await Process.start('./mlkem512', ['dec', 'ct', 'sk']);

  final List<String> output = [];

 process.stdout
        .transform(Utf8Decoder())
        .forEach(output.add);

  final outputCat = output.join("\n");

  final String ss = outputCat.split(' ')[0];

  return (ss); 
}