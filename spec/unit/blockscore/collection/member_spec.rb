module BlockScore
  class Collection
    RSpec.describe Member do
      describe '#save' do
        let(:person)        { BlockScore::Person.new(attributes_for(:person)) }
        let(:question_set)  { QuestionSet.new }
        subject(:member)    { described_class.new(person, question_set) }

        before { member.save }

        it { expect(person).to be_persisted }
        its(:class) { should be described_class }
      end
    end
  end
end
