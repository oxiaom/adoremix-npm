'use strict';

module.exports = Object.assign(
  require('./spawn'),
  { pid: require('./pid'), signals: require('./signals') }
);
