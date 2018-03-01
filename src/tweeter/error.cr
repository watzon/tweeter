require "json"

module Tweeter
  class Error < ::Exception
    getter :code, :rate_limit

    def initialize(message = "", rate_limit = {} of String => Array(String), @code : Int32? = nil)
      super(message)
      @rate_limit = Tweeter::RateLimit.new(rate_limit.to_h)
    end

    class ClientError < Tweeter::Error
    end

    class BadRequest < ClientError
    end

    class Unauthorized < ClientError
    end

    class Forbidden < ClientError
    end

    class RequestEntityTooLarge < Forbidden
    end

    class AlreadyFavorited < Forbidden
    end

    class AlreadyRetweeted < Forbidden
    end

    class DuplicateStatus < Forbidden
    end

    class NotFound < ClientError
    end

    class NotAcceptable < ClientError
    end

    class UnprocessableEntity < ClientError
    end

    class TooManyRequests < ClientError
    end

    class ServerError < Tweeter::Error
    end

    class InternalServerError < ServerError
    end

    class BadGateway < ServerError
    end

    class ServiceUnavailable < ServerError
    end

    class GatewayTimeout < ServerError
    end

    ERRORS = {
      400 => Tweeter::Error::BadRequest,
      401 => Tweeter::Error::Unauthorized,
      403 => Tweeter::Error::Forbidden,
      404 => Tweeter::Error::NotFound,
      406 => Tweeter::Error::NotAcceptable,
      413 => Tweeter::Error::RequestEntityTooLarge,
      422 => Tweeter::Error::UnprocessableEntity,
      429 => Tweeter::Error::TooManyRequests,
      500 => Tweeter::Error::InternalServerError,
      502 => Tweeter::Error::BadGateway,
      503 => Tweeter::Error::ServiceUnavailable,
      504 => Tweeter::Error::GatewayTimeout,
    }

    FORBIDDEN_MESSAGES = {
      "Status is a duplicate."                                                => Tweeter::Error::DuplicateStatus,
      "You have already favorited this status."                               => Tweeter::Error::AlreadyFavorited,
      "You have already retweeted this tweet."                                => Tweeter::Error::AlreadyRetweeted,
      "sharing is not permissible for this status (Share validations failed)" => Tweeter::Error::AlreadyRetweeted,
    }

    enum Code
      AUTHENTICATION_PROBLEM       =  32
      RESOURCE_NOT_FOUND           =  34
      SUSPENDED_ACCOUNT            =  64
      DEPRECATED_CALL              =  68
      RATE_LIMIT_EXCEEDED          =  88
      INVALID_OR_EXPIRED_TOKEN     =  89
      SSL_REQUIRED                 =  92
      UNABLE_TO_VERIFY_CREDENTIALS =  99
      OVER_CAPACITY                = 130
      INTERNAL_ERROR               = 131
      OAUTH_TIMESTAMP_OUT_OF_RANGE = 135
      ALREADY_FAVORITED            = 139
      FOLLOW_ALREADY_REQUESTED     = 160
      FOLLOW_LIMIT_EXCEEDED        = 161
      PROTECTED_STATUS             = 179
      OVER_UPDATE_LIMIT            = 185
      DUPLICATE_STATUS             = 187
      BAD_AUTHENTICATION_DATA      = 215
      SPAM                         = 226
      LOGIN_VERIFICATION_NEEDED    = 231
      ENDPOINT_RETIRED             = 251
      CANNOT_WRITE                 = 261
      CANNOT_MUTE                  = 271
      CANNOT_UNMUTE                = 272
    end

    def self.from_response(body, headers : HTTP::Headers)
      message, code = parse_error(body)
      new(message, headers, code)
    end

    private def self.parse_error(body) : Tuple(String, Int32?)
      if body.nil?
        {"", nil}
      elsif error = body["error"]?
        {error.as_s, nil}
      else
        errors = body["errors"].as_a
        extract_message_from_errors(errors)
      end
    end

    # TODO: Clean this up
    private def self.extract_message_from_errors(errors)
      return {"", nil} if errors.size == 0
      first = errors.first
      if first.is_a?(Hash)
        code = first["code"]?.is_a?(Int32) ? first["code"].as(Int32) : nil
        {first["message"].to_s, code}
      elsif first.is_a?(String)
        {first, nil}
      else
        {"", nil}
      end
    end
  end
end
