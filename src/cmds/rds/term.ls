#
# Copyright (c) 2019 T2T Inc. All rights reserved
# https://www.t2t.io
# https://tic-tac-toe.io
# Taipei, Taiwan
#
require! <[request]>
io = require \socket.io-client

REQ_TTY =
  type: \req-tty
  params:
    type: \pty
    options:
      cols: process.stdout.columns
      rows: process.stdout.rows
      cwd: \/tmp
      env: process.env


START_WS = (server, user, password, id) ->
  url = "#{server}/terminal"
  console.error "connecting to #{url.yellow}, with #{user.green}"

  s = io.connect url
  s.on \connect, ->
    console.error "websocket is connected"
    return s.emit \authentication, username: user, password: password

  s.on \tty, (chunk) -> process.stdout.write chunk

  s.on \authenticated, ->
    # process.stdin.pause!
    process.stdin.setRawMode yes
    process.stdin.resume!
    process.stdin.on \data, (chunk) -> s.emit \tty, chunk
    process.stdin.on \close, -> s.disconnect!
    # cmd = type: \req-tty, id: id, params: {cols: process.stdout.columns, rows: process.stdout.rows}
    REQ_TTY.id = id
    s.emit \command, JSON.stringify REQ_TTY

  s.on \err, (err) ->
    console.error "unexpected error: #{err}"
    s.disconnect!
    module.delay-ms = 20000ms
    module.delay-destroy = yes

  s.on \unauthorized, (err) ->
    console.error "invalid user or password"
    process.exit 1

  s.on \disconnect, ->
    {delay-destroy, delay-ms} = module
    f = -> process.exit 1
    if delay-destroy then setInterval f, delay-ms else f!




module.exports = exports =
  command: "term"
  describe: "connect to the selected node via wstty-server as terminal"

  builder: (yargs) ->
    yargs
      .alias \s, \server
      .default \s, \https://wstty.tic-tac-toe.io
      .describe \s, "the url to wstty-server"
      .alias \u, \user
      .describe \u, "user name to login the selected node"
      .alias \p, \password
      .describe \p, "password to login the selected node"
      .alias \n, \node
      .describe \n, "the unique identity for the selected node, e.g. BBG216101796"
      .demand <[u p n]>

  handler: (argv) ->
    {server, user, password} = argv
    node = argv.node.toString!
    console.error "check #{node.yellow} ..."
    (error, response, body) <- request "#{server}/api/v1/a/agents"
    return console.error "error: #{error}" if error?
    return console.error "unexpected http response: #{response.status-code}" unless response.status-code == 200
    rsp = JSON.parse "#{body}"
    {data} = rsp
    found = no
    id = ""
    for agent in data
      if not found
        {ttt, os} = agent
        if ttt.id is node or os.hostname is node
          id := agent.id
          found := yes
    return console.error "no such node: #{node}\n#{JSON.stringify data, null, ' '}" unless found
    return START_WS server, user, password, id
