require 'yabeda'
require 'grpc'

DEFAULT_BUCKETS = [0.01, 0.02, 0.04, 0.1, 0.2, 0.5, 0.8, 1, 1.5, 2, 5, 15, 30, 60].freeze
Yabeda.configure do
  counter :grpc_client_requests_total,
          tags: %i[type method status],
          comment: 'A counter of the total number of gRPC requests sent'

  histogram :grpc_client_request_duration,
            unit: :seconds,
            tags: %i[type method status],
            buckets: [0.001, 0.005] + DEFAULT_BUCKETS,
            comment: 'Histogram of GRPC client request duration'
end

class GrufClientMetrics < Gruf::Interceptors::ClientInterceptor
  STATUS_CODES_MAP = ::GRPC::Core::StatusCodes.constants.each_with_object({}) do |status_name, hash|
    hash[::GRPC::Core::StatusCodes.const_get(status_name)] = status_name.to_s.downcase.camelize
  end.freeze

  def call(request_context:)
    status = STATUS_CODES_MAP[::GRPC::Core::StatusCodes::OK]

    Process.clock_gettime(Process::CLOCK_MONOTONIC)
    result = yield request_context
    Process.clock_gettime(Process::CLOCK_MONOTONIC)

    result
  rescue ::GRPC::BadStatus => e
    status = STATUS_CODES_MAP[e.code]
    raise
  rescue StandardError
    status = ::GRPC::Core::StatusCodes::INTERNAL
    raise
  ensure
    Yabeda.grpc_client_requests_total.increment({ type: request_context.type, method: request_context.method,
                                                  status: status })
    Yabeda.grpc_client_request_duration.measure(
      { type: request_context.type, method: request_context.method,
        status: status },
      value
    )
  end
end
