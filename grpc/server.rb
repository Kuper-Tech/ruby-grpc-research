# frozen_string_literal: true

require 'grpc'
require_relative '../pb/hello_services_pb'

class HelloImpl < ::Hello::Greeter::Service
  def say_hello(req, _rpc)
    ::Hello::HelloReply.new(message: "Hello, #{req.name}!")
  end
end

s = GRPC::RpcServer.new(
  pool_size: 5,
  poll_period: 1,
  pool_keep_alive: 1,
  max_waiting_requests: 32
)
s.add_http2_port('localhost:50051', :this_port_is_insecure)
s.handle(HelloImpl.new)

puts 'GRPC server is starting...'
s.run_till_terminated
