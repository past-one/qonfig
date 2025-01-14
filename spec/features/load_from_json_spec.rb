# frozen_string_literal: true

describe 'Load from JSON' do
  specify 'defines config object by json instructions' do
    class JSONBasedConfig < Qonfig::DataSet
      load_from_json SpecSupport.fixture_path('json_object_sample.json')

      setting :nested do
        load_from_json SpecSupport.fixture_path('json_object_sample.json')
      end

      setting :with_empty_objects do
        load_from_json SpecSupport.fixture_path('json_with_empty_object.json')
      end
    end

    JSONBasedConfig.new.settings.tap do |conf|
      expect(conf.user).to eq('D@iVeR')
      expect(conf.maxAuthCount).to eq(55)
      expect(conf.rubySettings.allowedVersions).to eq(['2.3', '2.4.2', '1.9.8'])
      expect(conf.rubySettings.gitLink).to eq(nil)
      expect(conf.rubySettings.withAdditionals).to eq(false)

      expect(conf.nested.user).to eq('D@iVeR')
      expect(conf.nested.maxAuthCount).to eq(55)
      expect(conf.nested.rubySettings.allowedVersions).to eq(['2.3', '2.4.2', '1.9.8'])
      expect(conf.nested.rubySettings.gitLink).to eq(nil)
      expect(conf.nested.rubySettings.withAdditionals).to eq(false)

      expect(conf.with_empty_objects.requirements).to eq({})
      expect(conf.with_empty_objects.credentials.excluded).to eq({})
    end
  end

  specify 'fails when json object has non-hash-like structure' do
    class IncompatibleJSONConfig < Qonfig::DataSet
      load_from_json SpecSupport.fixture_path('json_array_sample.json')
    end

    expect { IncompatibleJSONConfig.new }.to raise_error(Qonfig::IncompatibleJSONStructureError)
  end

  describe ':strict mode option (when file doesnt exist)' do
    context 'when :strict => true (by default)' do
      specify 'fails with corresponding error' do
        # check default behaviour (strict: true)
        class FailingJSONConfig < Qonfig::DataSet
          load_from_json 'no_file.json'
        end

        expect { FailingJSONConfig.new }.to raise_error(Qonfig::FileNotFoundError)

        class ExplicitlyStrictedJSONCOnfig < Qonfig::DataSet
          load_from_json 'no_file.json', strict: true
        end

        expect { ExplicitlyStrictedJSONCOnfig.new }.to raise_error(Qonfig::FileNotFoundError)
      end
    end

    context 'when :strict => false' do
      specify 'does not fail - empty config' do
        class NonFailingJSONConfig < Qonfig::DataSet
          load_from_json 'no_file.json', strict: false

          setting :nested do
            load_from_json 'no_file.json', strict: false
          end
        end

        expect { NonFailingJSONConfig.new }.not_to raise_error
        expect(NonFailingJSONConfig.new.to_h).to eq('nested' => {})
      end
    end
  end
end
