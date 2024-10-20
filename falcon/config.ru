# frozen_string_literal: true

require 'grpc'

def marshal_proc
  proc { |o| o }
end

def unmarshal_proc
  proc { |o| o }
end

run do |env|
  method = env['protocol.http.request'].path
  channel = GRPC::ClientStub.setup_channel(nil, 'localhost:50051', :this_channel_is_insecure)
  deadline = GRPC::Core::TimeConsts.from_relative_time(GRPC::ClientStub::INFINITE_FUTURE)
  call = channel.create_call(nil, nil, method, nil, deadline)
  active_call = GRPC::ActiveCall.new(call, marshal_proc, unmarshal_proc, deadline, started: false)
  response = active_call.request_response(env['protocol.http.request'].body.read, metadata: {})

  [200, { 'Content-Type' => 'application/grpc+proto', 'grpc-encoding' => 'gzip' }, [response]]
end
