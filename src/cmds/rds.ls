#
# Copyright (c) 2019 T2T Inc. All rights reserved
# https://www.t2t.io
# https://tic-tac-toe.io
# Taipei, Taiwan
#
module.exports = exports =
  command: \rds
  desc: 'client library for rds service'
  builder: (yargs) -> return yargs.demandCommand! .commandDir 'rds', {extensions: <[ls js]>}
  handler: (argv) -> return

