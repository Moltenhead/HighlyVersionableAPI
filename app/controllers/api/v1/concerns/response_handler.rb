module Api
  module V1
    module Concerns
      module ResponseHandler
        extend ActiveSupport::Concern

        included do
          rescue_from ::StandardError do | ex |
            response_handler(ex)
          end
        end
        
        def response_handler(res)
          if res.kind_of? ::StandardError
            error_handler(res)
          else
            success_handler(res)
          end
        end
        
        def error_handler(e)
          code = (e.status if e.respond_to?(:status)) || 500
          message = (e.detail if e.respond_to?(:detail)) || 'Internal Server Error'
          render status: code, json: { success: false, error: message, code: code }
        end
        
        def success_handler(e, code = 200)
          render status: code, json: { success: true, data: e }
        end
      end
    end
  end
end
