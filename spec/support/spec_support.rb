# frozen_string_literal: true

module SpecSupport
  # @return [String]
  ARTIFACTS_PATH = File.expand_path(File.join('..', 'artifacts'), __dir__).freeze
  # @return [String]
  FIXTURES_PATH = File.expand_path(File.join('..', 'fixtures'), __dir__).freeze

  class << self
    # @param parts [Array<String>]
    # @return [String]
    def fixture_path(*parts)
      File.join(FIXTURES_PATH, *parts)
    end

    # @params [Array<String>]
    # @return [String]
    def artifact_path(*parts)
      File.join(ARTIFACTS_PATH, *parts)
    end
  end
end
