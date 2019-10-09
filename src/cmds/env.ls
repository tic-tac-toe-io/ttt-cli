#
# Copyright (c) 2019 T2T Inc. All rights reserved
# https://www.t2t.io
# https://tic-tac-toe.io
# Taipei, Taiwan
#
module.exports = exports =
  command: \env
  desc: 'manage multiple named context environments that store configs and credentials'
  builder: (yargs) -> return yargs.demandCommand! .commandDir 'env', {extensions: <[ls js]>}
  handler: (argv) -> return
