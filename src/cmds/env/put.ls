#
# Copyright (c) 2019 T2T Inc. All rights reserved
# https://www.t2t.io
# https://tic-tac-toe.io
# Taipei, Taiwan
#
module.exports = exports =
  command: 'put <name> <key> <value>'
  desc: 'Add environment context named <name> with specified key and value'
  builder: {}
  handler: (argv) ->
    console.log "Add environment context named #{argv.name} with specified key #{argv.key} and value #{argv.value}"
