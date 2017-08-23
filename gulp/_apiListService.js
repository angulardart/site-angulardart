'use strict';

const assert = require('assert-plus');
const fs = require('fs-extra');
const path = require('canonical-path');

module.exports = function apiListService(log) {

  function arrayFromIterable(iterable) {
    const arr = [];
    for (let e of iterable) arr.push(e);
    return arr;
  };

  const _self = {

    libToEntryMap: null,
    containerToEntryMap: null,
    // numExcludedEntries: 0,

    createApiListMap: function (dartDocDataWithExtraProps) {
      const libToEntryMap = _self.libToEntryMap = new Map();
      const containerToEntryMap = _self.containerToEntryMap = new Map();

      // Populate the two maps from dartDocDataWithExtraProps.
      dartDocDataWithExtraProps.forEach((e) => {
        // Skip non-preprocessed entries.
        if (!e.kind) return true;

        // Exclude non-public APIs.
        // if (e.libName.match(excludeLibRegExp)) { _self.numExcludedEntries++; return true; }

        let key;
        if (e.kind.startsWith('entry')) {
          // Store library entry info in lib map.
          key = e.libName;
          assert.equal(key, e.enclosedByQualifiedName, `${key} != ${e.enclosedByQualifiedName}`);
          _set(libToEntryMap, key, e);
        } else if (e.enclosedBy) {
          assert.notEqual(e.type, 'library');
          key = e.enclosedByQualifiedName;
        } else {
          assert.equal(e.type, 'library');
          // Add library "index" page to the library's entries in the general container map,
          // but not the lib map which is used to create the main API page index.
          key = e.libName;
          _set(containerToEntryMap, key, e);
          // Add the library as an entry to the package container:
          key = '';
        }
        _set(containerToEntryMap, key, e);
      });
      // log.info('Excluded', _self.numExcludedEntries, 'library entries (regexp match).');

      // The data file needs to be a map of lib names to an array of entries
      const fileData = Object.create(null);
      for (let name of arrayFromIterable(libToEntryMap.keys()).sort()) {
        fileData[name] = arrayFromIterable(libToEntryMap.get(name).values());
      }
      return fileData;
    },

  }
  return _self;
};

// Adds e to the map of m[key].
function _set(m, key, e) {
  if (!m.has(key)) m.set(key, new Map());
  const entryMap = m.get(key);
  entryMap.set(e.name, e);
}
