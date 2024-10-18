# frozen_string_literal: true

require 'grpc'
require 'logger'
require_relative '../pb/hello_services_pb'

THREADS_COUNT = 5
WAIT_QUEUE_SIZE = 32
BIND_ADDRESS = '0.0.0.0:9091'

STDOUT.sync = true

module RubyLogger
  LOGGER = Logger.new(STDOUT)
  def logger = LOGGER
end

module GRPC
  extend RubyLogger
end

class HelloImpl < ::Hello::Greeter::Service
  def say_hello(req, _rpc)
    ::Hello::HelloReply.new(message: "Hello, #{req.name}!")
  end
end

server = GRPC::RpcServer.new(
  pool_size: THREADS_COUNT,
  max_waiting_requests: WAIT_QUEUE_SIZE
)
server.add_http2_port(BIND_ADDRESS, :this_port_is_insecure)
server.handle(HelloImpl)

puts 'GRPC server is starting...'
server.run_till_terminated
