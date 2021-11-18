class StandardError
  attr_reader *%i[title detail status source config]
end

module Errors
  class StandardError < ::StandardError
    def initialize(title: nil, detail: nil, status: nil, source: {})
      @title = title || "Something went wrong"
      @detail = detail || "We encountered unexpected error, but our developers had been already notified about it"
      @status = status || 500
      @source = source.deep_stringify_keys
      @config = { http_code: @status }
    end

    def to_h
      {
        status: status,
        title: title,
        detail: detail,
        source: source,
        config: config
      }
    end

    def serializable_hash
      to_h
    end

    def to_s
      to_h.to_s
    end

    # attr_reader *%i[title detail status source config]
  end

  class ModelNotFound < StandardError
    def initialize
      super(
        status: 404,
        detail: 'Not Found',
        detail: 'Unable to find this model'
      )
    end
  end

  class ModelEmpty < StandardError
    def initialize
      super(
        status: 404,
        detail: 'Empty Model',
        detail: 'Model does not have any records'
      )
    end
  end
end
