# frozen_string_literal: true

require 'gruf'
require_relative '../../shared/pb/hello_services_pb'
require_relative '../../shared/fetch_data'

class GreeterController < ::Gruf::Controllers::Base
  bind Hello::Greeter::Service

  def say_hello
    FetchData.call
    Hello::HelloReply.new(message: "Hello, #{request.message.name}!")
  end
end
