# frozen_string_literal: true

require 'griffin'
require_relative '../pb/hello_services_pb'

class GreeterServer < Hello::Greeter::Service
  def say_hello(request, _call)
    Hello::HelloReply.new(message: "Hello, #{request.name}!")
  end
end

Griffin::Server.configure do |c|
  c.bind '0.0.0.0'
  c.port 50_051

  c.workers 8
  c.pool_size 20, 20
  c.connection_size 4, 4

  c.services GreeterServer.new
end

Griffin::Server.run
