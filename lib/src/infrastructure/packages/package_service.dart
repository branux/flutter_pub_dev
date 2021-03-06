import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_package/src/domain/packages/entities/package.dart';
import 'package:flutter_package/src/domain/core/api_service.dart';
import 'package:flutter_package/src/domain/core/request_failure.dart';
import 'package:flutter_package/src/domain/packages/entities/score.dart';
import 'package:flutter_package/src/domain/packages/i_package_service.dart';

class PackageService extends IPackageService {
  PackageService(Dio dio) : super(dio);

  @override
  Future<Either<RequestFailure, List<Package>>> getPackages(
      {@required int page}) async {
    try {
      final response = await dio.get('${path}?page=${page}',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ));

      if (response.statusCode != 200) return Left(RequestFailure.serverError());

      var packages = List.from(response.data['packages']).map<Package>((data) {
        return Package.fromMap(data);
      }).toList();

      return (packages.isEmpty)
          ? Left(RequestFailure.empty())
          : Right(packages);
    } on DioError catch (e) {
      if (e.error is OSError || e.error is SocketException) {
        return left(RequestFailure.networkError());
      }

      if (e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RECEIVE_TIMEOUT ||
          e.type == DioErrorType.SEND_TIMEOUT) {
        return left(RequestFailure.serverError());
      }

      if (e.response.statusCode == 500) {
        return Left(RequestFailure.serverError());
      }

      return Left(RequestFailure.serverError());
    } catch (error) {
      return left(RequestFailure.serverError());
    }
  }

  @override
  Future<Either<RequestFailure, Package>> getPackageName(
      {String namePackage}) async {
    try {
      print('namePackage: ${namePackage}');
      final response = await dio.get('$path/$namePackage',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ));
      print('${response.statusCode}');

      if (response.statusCode != 200) return Left(RequestFailure.serverError());

      var package = Package.from(response.data);

      return Right(package);
    } on DioError catch (e) {
      if (e.error is OSError || e.error is SocketException) {
        return left(RequestFailure.networkError());
      }

      if (e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RECEIVE_TIMEOUT ||
          e.type == DioErrorType.SEND_TIMEOUT) {
        return left(RequestFailure.serverError());
      }

      if (e.response.statusCode == 500) {
        return Left(RequestFailure.serverError());
      }

      return Left(RequestFailure.serverError());
    } catch (error) {
      print('$error');
      return left(RequestFailure.serverError());
    }
  }

  @override
  Future<Either<RequestFailure, Score>> getScorePackage(
      {String namePackage}) async {
    try {
      final response = await dio.get('$path/$namePackage/score',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ));

      if (response.statusCode != 200) return Left(RequestFailure.serverError());

      var score = Score.fromMap(response.data);

      return Right(score);
    } on DioError catch (e) {
      if (e.error is OSError || e.error is SocketException) {
        return left(RequestFailure.networkError());
      }

      if (e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RECEIVE_TIMEOUT ||
          e.type == DioErrorType.SEND_TIMEOUT) {
        return left(RequestFailure.serverError());
      }

      if (e.response.statusCode == 500) {
        return Left(RequestFailure.serverError());
      }

      return Left(RequestFailure.serverError());
    } catch (error) {
      print('$error');
      return left(RequestFailure.serverError());
    }
  }
}
