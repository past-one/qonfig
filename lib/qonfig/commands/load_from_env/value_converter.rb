# frozen_string_literal: true

module Qonfig
  # @api private
  # @since 0.2.0
  module Commands::LoadFromENV::ValueConverter
    # @return [Regexp]
    #
    # @api private
    # @since 0.2.0
    INTEGER_PATTERN = /\A\d+\z/.freeze

    # @return [Regexp]
    #
    # @api private
    # @since 0.2.0
    FLOAT_PATTERN = /\A\d+\.\d+\z/.freeze

    # @return [Regexp]
    #
    # @api private
    # @since 0.2.0
    TRUE_PATTERN = /\A(t|true)\z/i.freeze

    # @return [Regexp]
    #
    # @api private
    # @since 0.2.0
    FALSE_PATTERN = /\A(f|false)\z/i.freeze

    # @return [Regexp]
    #
    # @api private
    # @since 0.2.0
    ARRAY_PATTERN = /\A[^'"].*\s*,\s*.*[^'"]\z/.freeze

    # @return [Regexp]
    #
    # @api private
    # @since 0.2.0
    QUOTED_STRING_PATTERN = /\A['"].*['"]\z/.freeze

    class << self
      # @param env_data [Hash]
      # @return [void]
      #
      # @api private
      # @since 0.2.0
      def convert_values!(env_data)
        env_data.each_pair do |key, value|
          env_data[key] = convert_value(value)
        end
      end

      private

      # @param value [Object]
      # @return [Object]
      #
      # @api private
      # @since 0.2.0
      def convert_value(value)
        return value unless value.is_a?(String)

        case value
        when INTEGER_PATTERN
          Integer(value)
        when FLOAT_PATTERN
          Float(value)
        when TRUE_PATTERN
          true
        when FALSE_PATTERN
          false
        when ARRAY_PATTERN
          value.split(/\s*,\s*/).map(&method(:convert_value))
        when QUOTED_STRING_PATTERN
          value.gsub(/(\A['"]|['"]\z)/, '')
        else
          value
        end
      end
    end
  end
end
