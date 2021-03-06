import 'dart:convert';

import 'package:flutter_package/src/domain/packages/entities/version.dart';
import 'package:flutter_package/src/utils/util.dart';

import 'dependencie.dart';
import 'version.dart';

class Package {
  final String name;
  final String package_url;
  final String url;
  final List<Version> versions;
  final Version latest;
  final List<Dependencie> dependencies;

  const Package(
      {this.name,
      this.package_url,
      this.url,
      this.latest,
      this.versions,
      this.dependencies});

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'package_url': this.package_url,
      'url': this.url,
      'versions': this.versions,
      'latest': this.latest,
    };
  }

  factory Package.fromMap(Map<String, dynamic> map) {
    return new Package(
      name: map['name'] as String,
      package_url: map['package_url'] as String,
      url: map['url'] as String,
      latest: Version.fromMap(map['latest']),
    );
  }

  factory Package.from(Map<String, dynamic> map) {
    return new Package(
      name: map['name'] as String,
      package_url: map['package_url'] as String,
      url: map['url'] as String,
      latest: Version.fromMap(map['latest']),
      dependencies:
          Dependencie.getDependencies(map['latest']['pubspec']['dependencies']),
      versions: (!map.containsKey('versions'))
          ? []
          : List.from(map['versions']).map((e) => Version.fromMap(e)).toList(),
    );
  }
}
