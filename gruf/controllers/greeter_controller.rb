# frozen_string_literal: true

require 'gruf'
require_relative '../../pb/hello_services_pb'

class GreeterController < ::Gruf::Controllers::Base
  bind Hello::Greeter::Service

  def say_hello
    Hello::HelloReply.new(message: "Hello, #{request.message.name}!")
  end
end
