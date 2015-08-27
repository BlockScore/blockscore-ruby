require File.expand_path(File.join('spec/blockscore/person_test.rb', '../../spec_helper'))
require File.expand_path(File.join(File.dirname('spec/blockscore/person_test.rb'), '../../spec/support/resource_behavior'))

module BlockScore
  RSpec.describe Person do
    it_behaves_like 'a resource'

    it 'test_details_does_not_request' do
      create(:person).details
      assert_requested(@api_stub, times: 0)
    end

    it 'test_collections_do_not_request' do
      create(:person).question_sets
      assert_requested(@api_stub, times: 0)
    end

    it 'test_valid_predicate' do
      person = create(:person, status: 'valid')
      expect(person.valid?).to eq(true)
      expect(person.invalid?).to eq(false)
    end

    it 'test_invalid_predicate' do
      person = create(:person, status: 'invalid')
      expect(person.invalid?).to eq(true)
      expect(person.valid?).to eq(false)
    end
  end
end
