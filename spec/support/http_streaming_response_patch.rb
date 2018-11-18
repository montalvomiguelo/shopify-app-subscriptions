#https://github.com/pex/rack-reverse-proxy/commit/cab77aaa1326798df5e6ad0b8c9d065b97925a65#diff-305d6fc15a6ad7575164d42fd43bcf0e

RSpec.configure do |config|
  config.before(:suite) do
    module Rack
      class HttpStreamingResponse
        def each(&block)
          response.read_body(&block)
        ensure
          session.end_request_hacked unless mocking?
        end
         protected
         def response
          if mocking?
            @response ||= session.request(@request)
          else
            super
          end
        end
         def mocking?
          defined?(WebMock) || defined?(FakeWeb)
        end
      end
    end
  end
end
