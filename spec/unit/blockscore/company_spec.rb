require File.expand_path(File.join('spec/blockscore/company_test.rb', '../../spec_helper'))
require File.expand_path(File.join(File.dirname('spec/blockscore/company_test.rb'), '../../spec/support/resource_behavior'))

module BlockScore
  RSpec.describe Company do
    it_behaves_like 'a resource'
  end
end
