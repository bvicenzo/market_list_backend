# frozen_string_literal: true

module LoadFixtureHelper
  def load_json(path)
    json_content = load_fixture_file(path)

    JSON.parse(json_content)
  end

  def load_json_symbolized(path)
    json_content = load_fixture_file(path)

    JSON.parse(json_content, symbolize_names: true)
  end

  def load_fixture_file(path)
    full_path = File.join(Rails.root, "spec/fixtures/#{path}")

    File.read(full_path)
  end

  def load_template_fixture(path, locals = {})
    content = load_fixture_file(path)

    erb = FixtureTemplate.new(locals)
    erb.render(content)
  end

  def load_dynamic_json_symbolized(path, locals = {})
    json_content = load_template_fixture(path, locals)

    JSON.parse(json_content, symbolize_names: true)
  end

  class FixtureTemplate < OpenStruct
    def render(template)
      ERB.new(template).result(binding)
    end
  end

  RSpec.configure do |config|
    config.include LoadFixtureHelper
  end
end
