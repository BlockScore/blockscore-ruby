RSpec.shared_context 'included class methods' do
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
