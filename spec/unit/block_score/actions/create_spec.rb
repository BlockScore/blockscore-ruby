require 'faker'

RSpec.describe BlockScore::Actions::Create, vcr: true do
  describe '.create' do
    subject(:candidate) do
      BlockScore::Candidate.create(attributes_for(:candidate))
    end

    it { is_expected.to be_persisted }
    it { is_expected.to be_an_instance_of BlockScore::Candidate }
  end

  describe '.included' do
    subject { object }
    let(:object) { described_class }
    let(:klass) { Class.new }

    it 'extends the klass' do
      expect(klass.singleton_class)
        .not_to include(described_class::ClassMethods)
      klass.send(:include, subject)
      expect(klass.singleton_class)
        .to include(described_class::ClassMethods)
    end
  end
end
