'use strict';

const logger = require('../logger');

function installGlobalHandlers(context) {
  const forward = (sig) => {
    if (context && context.child && !context.child.killed) {
      try { process.kill(context.child.pid, sig); } catch (e) {}
    }
  };
  process.on('SIGINT', () => { logger.info('SIGINT 收到，转发'); forward('SIGINT'); });
  process.on('SIGTERM', () => { logger.info('SIGTERM 收到，转发'); forward('SIGTERM'); });
}

module.exports = { installGlobalHandlers };
