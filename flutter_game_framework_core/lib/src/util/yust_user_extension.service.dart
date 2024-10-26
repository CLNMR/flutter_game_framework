// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ServiceGenerator
// **************************************************************************

// ignore_for_file: directives_ordering, prefer_relative_imports, empty_statements, lines_longer_than_80_chars
import 'package:yust/yust.dart';

/// A service to get elements of [YustUser].
class YustUserService {
  /// Returns a stream of a [YustUser].
  ///
  ///
  /// Whenever another user makes a change, a new version of the document is returned.
  ///
  static Stream<YustUser?> getStream(String id) =>
      Yust.databaseService.getStream<YustUser>(
        YustUser.setup(),
        id,
      );

  /// Returns a stream of the first [YustUser].
  ///
  ///
  /// Whenever another user makes a change, a new version of the document is returned.
  /// The result is null if no document was found.
  static Stream<YustUser?> getFirstStream({
    List<YustFilter>? filters,
    List<YustOrderBy>? orderBy,
  }) =>
      Yust.databaseService.getFirstStream<YustUser>(
        YustUser.setup(),
        filters: filters,
        orderBy: orderBy,
      );

  /// Returns a stream of [YustUser]s.
  ///
  ///
  /// Whenever another user makes a change, a new version of the document is returned.
  ///
  /// [filters] each entry represents a condition that has to be met.
  /// All of those conditions must be true for each returned entry.
  ///
  /// [orderBy] orders the returned records.
  /// Multiple of those entries can be repeated.
  ///
  /// [limit] can be passed to only get at most n documents.
  static Stream<List<YustUser>> getListStream({
    List<YustFilter>? filters,
    List<YustOrderBy>? orderBy,
    int? limit,
  }) =>
      Yust.databaseService.getListStream<YustUser>(
        YustUser.setup(),
        filters: filters,
        orderBy: orderBy,
        limit: limit,
      );

  /// Returns a [YustUser] directly from the server, if available, otherwise from the cache.
  ///
  ///
  /// Be careful with offline functionality.
  ///
  static Future<YustUser?> getFromDB(String id) async =>
      Yust.databaseService.getFromDB<YustUser>(
        YustUser.setup(),
        id,
      );

  /// Returns the first [YustUser] directly from the server, if available, otherwise from the cache.
  ///
  ///
  /// Be careful with offline functionality.
  /// The result is null if no document was found.
  static Future<YustUser?> getFirstFromDB({
    List<YustFilter>? filters,
    List<YustOrderBy>? orderBy,
  }) async =>
      Yust.databaseService.getFirstFromDB<YustUser>(
        YustUser.setup(),
        filters: filters,
        orderBy: orderBy,
      );

  /// Returns [YustUser]s directly from the server, if available, otherwise from the cache.
  ///
  ///
  /// Be careful with offline functionality.
  ///
  /// [filters] each entry represents a condition that has to be met.
  /// All of those conditions must be true for each returned entry.
  ///
  /// [orderBy] orders the returned records.
  /// Multiple of those entries can be repeated.
  ///
  /// [limit] can be passed to only get at most n documents.
  static Future<List<YustUser>> getListFromDB({
    List<YustFilter>? filters,
    List<YustOrderBy>? orderBy,
    int? limit,
  }) async =>
      Yust.databaseService.getListFromDB<YustUser>(
        YustUser.setup(),
        filters: filters,
        orderBy: orderBy,
        limit: limit,
      );

  /// Returns a [YustUser] from the cache, if available, otherwise from the server.
  /// The cached documents may not be up to date!
  ///
  /// Be careful with offline functionality.
  ///
  static Future<YustUser?> getFromCache(String id) async =>
      Yust.databaseService.getFromCache<YustUser>(
        YustUser.setup(),
        id,
      );

  /// Returns the first [YustUser] from the cache, if available, otherwise from the server.
  /// The cached documents may not be up to date!
  ///
  /// Be careful with offline functionality.
  /// The result is null if no document was found.
  static Future<YustUser?> getFirstFromCache({
    List<YustFilter>? filters,
    List<YustOrderBy>? orderBy,
  }) async =>
      Yust.databaseService.getFirstFromCache<YustUser>(
        YustUser.setup(),
        filters: filters,
        orderBy: orderBy,
      );

  /// Returns [YustUser]s from the cache, if available, otherwise from the server.
  /// The cached documents may not be up to date!
  ///
  /// Be careful with offline functionality.
  ///
  /// [filters] each entry represents a condition that has to be met.
  /// All of those conditions must be true for each returned entry.
  ///
  /// [orderBy] orders the returned records.
  /// Multiple of those entries can be repeated.
  ///
  /// [limit] can be passed to only get at most n documents.
  static Future<List<YustUser>> getListFromCache({
    List<YustFilter>? filters,
    List<YustOrderBy>? orderBy,
    int? limit,
  }) async =>
      Yust.databaseService.getListFromCache<YustUser>(
        YustUser.setup(),
        filters: filters,
        orderBy: orderBy,
        limit: limit,
      );

  /// Returns a [YustUser] from the server, if available, otherwise from the cache.
  /// The cached documents may not be up to date!
  ///
  /// Be careful with offline functionality.
  ///
  static Future<YustUser?> get(String id) async =>
      Yust.databaseService.get<YustUser>(
        YustUser.setup(),
        id,
      );

  /// Returns the first [YustUser] from the server, if available, otherwise from the cache.
  /// The cached documents may not be up to date!
  ///
  /// Be careful with offline functionality.
  /// The result is null if no document was found.
  static Future<YustUser?> getFirst({
    List<YustFilter>? filters,
    List<YustOrderBy>? orderBy,
  }) async =>
      Yust.databaseService.getFirst<YustUser>(
        YustUser.setup(),
        filters: filters,
        orderBy: orderBy,
      );

  /// Returns [YustUser]s from the server, if available, otherwise from the cache.
  /// The cached documents may not be up to date!
  ///
  /// Be careful with offline functionality.
  ///
  /// [filters] each entry represents a condition that has to be met.
  /// All of those conditions must be true for each returned entry.
  ///
  /// [orderBy] orders the returned records.
  /// Multiple of those entries can be repeated.
  ///
  /// [limit] can be passed to only get at most n documents.
  static Future<List<YustUser>> getList({
    List<YustFilter>? filters,
    List<YustOrderBy>? orderBy,
    int? limit,
  }) async =>
      Yust.databaseService.getList<YustUser>(
        YustUser.setup(),
        filters: filters,
        orderBy: orderBy,
        limit: limit,
      );

  /// Returns [YustUser]s as a lazy, chunked Stream from the database.
  ///
  /// This is much more memory efficient in comparison to other methods,
  /// because of three reasons:
  /// 1. It gets the data in multiple requests ([pageSize] each); the raw json
  ///    strings and raw maps are only in memory while one chunk is processed.
  /// 2. It loads the records *lazily*, meaning only one chunk is in memory while
  ///    the records worked with (e.g. via a `await for(...)`)
  /// 3. It doesn't use the google_apis package for the request, because that
  ///    has a huge memory leak
  ///
  /// NOTE: Because this is a Stream you may only iterate over it once,
  /// listening to it multiple times will result in a runtime-exception!
  ///
  /// [filters] each entry represents a condition that has to be met.
  /// All of those conditions must be true for each returned entry.
  ///
  /// [orderBy] orders the returned records.
  /// Multiple of those entries can be repeated.
  ///
  static Stream<YustUser> getListChunked({
    List<YustFilter>? filters,
    List<YustOrderBy>? orderBy,
    int pageSize = 5000,
  }) =>
      Yust.databaseService.getListChunked<YustUser>(
        YustUser.setup(),
        filters: filters,
        orderBy: orderBy,
        pageSize: pageSize,
      );

  /// Returns the count of [YustUser]s in the database.
  ///
  /// Please note, that this is still priced per item, therefore don't overuse it
  /// on large collections.
  ///
  /// [filters] each entry represents a condition that has to be met.
  /// All of those conditions must be true for each returned entry.
  ///
  ///
  static Future<int?> count({List<YustFilter>? filters}) =>
      Yust.databaseService.count<YustUser>(
        YustUser.setup(),
        filters: filters,
      );

  /// Initializes a [YustUser] with an id and the time it was created.
  ///
  /// Optionally an existing [YustUser] can be given, which will still be
  /// assigned a new id becoming a new [YustUser] if it had an id previously.
  static YustUser init([YustUser? doc]) =>
      Yust.databaseService.initDoc<YustUser>(
        YustUser.setup(),
        doc,
      );

  /// Delete all [YustUser]s in the filter.
  static Future<void> deleteAll({List<YustFilter>? filters}) =>
      Yust.databaseService.deleteDocs<YustUser>(
        YustUser.setup(),
        filters: filters,
      );

  /// Delete a [YustUser].
  static Future<void> deleteById(String id) =>
      Yust.databaseService.deleteDocById<YustUser>(
        YustUser.setup(),
        id,
      );
}

/// An extension to save and delete elements of [YustUser].
extension YustUserSave on YustUser {
  /// Saves the document.
  Future<void> save({
    bool merge = true,
    bool? trackModification,
    bool skipOnSave = false,
    bool? removeNullValues,
    bool doNotCreate = false,
  }) async {
    await Yust.databaseService.saveDoc<YustUser>(
      YustUser.setup(),
      this,
      trackModification: trackModification ?? false,
      skipOnSave: skipOnSave,
      doNotCreate: doNotCreate,
      merge: merge,
      removeNullValues: removeNullValues,
    );
  }

  /// Transforms (e.g. increment, decrement) a documents fields.
  Future<void> updateByTransform(
    List<YustFieldTransform> fieldTransforms, {
    bool? removeNullValues,
    bool skipOnSave = false,
  }) async =>
      Yust.databaseService.updateDocByTransform<YustUser>(
        YustUser.setup(),
        id,
        fieldTransforms,
        removeNullValues: removeNullValues,
        skipOnSave: skipOnSave,
      );

  /// Deletes the document.
  Future<void> delete() async => Yust.databaseService.deleteDoc<YustUser>(
        YustUser.setup(),
        this,
      );
}
