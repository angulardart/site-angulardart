'use strict';

module.exports = function () {
  function noop() {}
  function log(m) { console.log(m) }

  // TODO: make log levels configurable again.
  return {
    level: 'info',
    silly: noop,
    debug: noop,
    info: noop,
    warn: log,
  }
};
