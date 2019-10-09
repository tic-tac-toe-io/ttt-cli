#
# Copyright (c) 2019 T2T Inc. All rights reserved
# https://www.t2t.io
# https://tic-tac-toe.io
# Taipei, Taiwan
#
require! <[request]>

module.exports = exports =
  command: "list"
  describe: "connect to wstty-server and list all available nodes"

  builder: (yargs) ->
    yargs
      .alias \s, \server
      .default \s, \https://wstty.tic-tac-toe.io
      .describe \s, "the url to wstty-server"

  handler: (argv) ->
    {config} = global
    {server} = argv
    (error, response, body) <- request "#{server}/api/v1/a/agents"
    return console.error "error: #{error}" if error?
    return console.error "unexpected http response: #{response.status-code}" unless response.status-code == 200
    rsp = JSON.parse "#{body}"
    {data} = rsp
    for agent in data
      {ttt, os} = agent
      {profile, id, wireless_ip_addr} = ttt
      {hostname} = os
      ip = agent?.iface?.iface?.ipv4
      ip = agent?.iface?.iface?.ipv4_address unless ip?
      console.log "#{profile}\t#{id}\t#{hostname}\t#{ip}"