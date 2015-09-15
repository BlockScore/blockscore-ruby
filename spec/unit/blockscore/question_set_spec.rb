module BlockScore
  RSpec.describe QuestionSet do
    describe '.new' do
      subject(:person) do
        BlockScore::QuestionSet.new
      end

      it { is_expected.not_to be_persisted }
      it { expect(person.class).to be BlockScore::QuestionSet }
    end

    describe '.create' do
      context 'vaild person' do
        let(:person_id) { create(:valid_person).id }
        subject(:question_set) { BlockScore::QuestionSet.create(person_id: person_id) }

        it { is_expected.to be_persisted }
        it { expect(question_set.class).to be BlockScore::QuestionSet }
      end

      context 'invaild person' do
        let (:person_id) { create(:invalid_person).id }

        it { expect { BlockScore::QuestionSet.create(person_id: person_id) }.to raise_error BlockScore::InvalidRequestError }
      end
    end

    pending '.find' do
      context 'valid question set id' do
        let(:question_set_id)  { create(:question_set).id }
        subject(:question_set) { BlockScore::QuestionSet.find(question_set_id) }

        it { is_expected.to be_persisted }
        it { expect(question_set.questions).not_to be_empty }
      end

      context 'invalid person id' do
        let(:question_set_id) { 'f3a243ddc8075a6acd603b7758d05b3c' }

        it { expect { BlockScore::QuestionSet.find(question_set_id) }.to raise_error BlockScore::RecordNotFound }
      end
    end

    describe '.retrieve' do
      let(:question_set_id)  { create(:question_set).id }
      subject(:question_set) { BlockScore::QuestionSet.retrieve(question_set_id) }

      it { is_expected.to be_persisted }
      it { expect(question_set.questions).not_to be_empty }
      it { expect(question_set.class).to be BlockScore::QuestionSet }
    end

    describe '#score' do
      context 'correct answers' do
        subject(:question_set) { create(:question_set) }
        before do
          answers = []

          question_set.questions.each do |question|
            question.answers.each do |answer|
              if ['309 Colver Rd', '812', 'Jasper', '49230', 'None Of The Above'].include? answer.answer
                answers << { question_id: question.id, answer_id: answer.id }
                break
              end
            end
          end

          question_set.score(answers)
        end

        it { expect(question_set.score).to eq 100.0 }
      end

      context 'incorrect answers' do
        subject(:question_set) { create(:question_set) }
        before do
          answers = []

          question_set.questions.each do |question|
            question.answers.each do |answer|
              if ['309 Colver Rd', '812', 'Jasper', '49230', 'None Of The Above'].include? answer.answer
                answers << { question_id: question.id, answer_id: (answer.id + 1) % 5 }
                break
              end
            end
          end

          question_set.score(answers)
        end

        it { expect(question_set.score).to eq 0.0 }
      end
    end

    describe '#refresh' do
      subject(:question_set) { create(:question_set) }
      before do
        question_set.questions = nil
        question_set.refresh
      end

      it { expect(question_set.questions).not_to be_empty }
    end

    describe '#inspect' do
      subject(:question_set_inspection) { create(:question_set).inspect }
      it { expect(question_set_inspection.class).to be String }
    end

    describe '#update' do
      subject(:question_set) { create(:question_set) }
      it { expect { question_set.delete }.to raise_error NoMethodError }
    end

    describe '#delete' do
      subject(:question_set) { create(:question_set) }
      it { expect { question_set.delete }.to raise_error NoMethodError }
    end

    describe '#save' do
      subject(:question_set) { build(:question_set) }
      before { question_set.save }

      it { is_expected.to be_persisted }
      it { expect(question_set.class).to be BlockScore::QuestionSet }
    end
  end
end
