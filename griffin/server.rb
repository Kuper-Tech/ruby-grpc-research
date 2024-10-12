# frozen_string_literal: true

require 'griffin'
require_relative 'hello_services_pb'

class GreeterServer < Hello::Greeter::Service
  def say_hello(request, _call)
    Hello::HelloReply.new(message: "Hello, #{request.name}!")
  end
end

Griffin::Server.configure do |c|
  c.bind '127.0.0.1'
  c.port 50_051

  c.services GreeterServer.new
end

Griffin::Server.run
