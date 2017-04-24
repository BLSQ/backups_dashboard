require 'webmock/rspec'

def fixture_content(type, name)
  File.read(File.join('spec', 'fixtures', type.to_s, name))
end

RSpec.configure do |config|

end
