require 'faker'

RSpec.describe BlockScore::Actions::Create, vcr: true do
  describe '.create' do
    subject(:candidate) do
      BlockScore::Candidate.create(attributes_for(:candidate))
    end

    it { is_expected.to be_persisted }
    it { is_expected.to be_an_instance_of BlockScore::Candidate }
  end

  it_behaves_like 'included class methods'
end
