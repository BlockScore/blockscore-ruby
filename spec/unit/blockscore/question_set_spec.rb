module BlockScore
  RSpec.describe QuestionSet do
    let(:person) { create(:person_params) }

    describe "api requests" do
      let(:api_stub) { @api_stub }

      context "when creating" do
        it 'create' do
          person.question_sets.count
          person.question_sets.create
          assert_requested(api_stub, times: 2)
        end

        it 'create question_set count' do
          count = person.question_sets.count
          person.question_sets.create
          expect(count + 1).to be_truthy
          assert_requested(api_stub, times: 2)
        end
      end

      context 'when scoring' do
        let(:answers) do
            [
              { question_id: 1, answer_id: 1 },
              { question_id: 2, answer_id: 1 },
              { question_id: 3, answer_id: 1 },
              { question_id: 4, answer_id: 1 },
              { question_id: 5, answer_id: 1 }
            ]
        end

        it 'score call does request' do
          qs = person.question_sets.create
          qs.score(answers)
          assert_requested(api_stub, times: 3)
        end
      end
    end

    describe "#retrieve" do

      context "when in person#attributes" do
        let(:qs) { person.question_sets.create }
        subject { person.question_sets.retrieve(qs.id) }

        it 'loads from collection' do
          expect(subject).to eql(qs)
        end

        it "retrieves and checks included person data" do
          data = [resource_id]
          allow(person.question_sets).to receive(:data) {data}
          aggregate_failures("retrieves from data") do
            expect(data).to receive(:include?).and_call_original
            expect(data).to receive(:[]).and_call_original
          end
          person.question_sets.retrieve(data[0])
        end
      end

      context "when not in person#attributes" do

        let(:qs) { QuestionSet.new({person_id: person.id, id: resource_id}) }
        let(:data) { person.question_sets.data }
        subject { person.question_sets.retrieve(qs.id) }
        before(:each) do
          person.question_sets.data.clear
          allow(QuestionSet).to receive(:retrieve).with(qs.id) { qs }
        end


        it "question_sets uses QuestionSet.retrieve" do
          expect(QuestionSet).to receive(:retrieve).with(qs.id) { qs }
          expect(subject).to be(qs)
        end

        it "registers new question set" do
          aggregate_failures("for person and collection") do
            expect(qs).to receive(:id).at_least(:once).and_call_original
            expect(person.question_sets).to receive(:<<).with(qs).and_call_original
            expect(data).to receive(:<<).with(qs.id).and_call_original
          end
          person.question_sets.retrieve(qs.id)
        end

        it "errors if not belonging" do
          qs.person_id = "some_not_associated_id"
          expect { subject }.to raise_error(Error, "None belonging")
        end

      end
    end


    context "when id is invalid" do
      pending "should raise not found if not a resource style id" do
        expect { person.question_sets.retrieve("bad_id") }.to raise_error(NotFoundError)
      end

      it "should raise ArgumentError if empty" do
        expect { person.question_sets.retrieve("") }.to raise_error(ArgumentError)
      end
    end


    describe "#new" do

      subject { person.question_sets }

      it "should delegate to QuestionSet" do
        expect(QuestionSet).to receive(:new).with(subject.default_params).and_call_original
        result = person.question_sets.new
        expect(result).to be_an_instance_of(QuestionSet)
      end

      it "should save person if not save" do
        person = Person.new
        qs = person.question_sets.new
        expect(person).to receive(:save).and_call_original
        qs.save
      end

      it "should have person#id" do
        qs = person.question_sets.new
        qs.person_id = "some_id"
        qs.save
        expect(qs.person_id).to eq(person.id)
        expect(qs.id).not_to be(nil)
      end

      it "should add to question_sets" do
        count = subject.size
        qs = subject.new
        expect(subject.size).to eq(count + 1)
        expect(subject).to include(qs)
      end

    end

    describe "#all" do
      subject { person.question_sets.all }
      it "should return self" do
        is_expected.to be(person.question_sets)
      end
    end

    describe "#create" do

      let (:person) { create(:person) }
      let (:data) { person.attributes[:question_sets] }
      let (:qs) { QuestionSet.create({person_id: person.id}) }
      subject { person.question_sets.create }

      it "should pass the Person#id" do
        expect(QuestionSet).to receive(:create).with({person_id: person.id}).and_call_original
        subject
      end

      it "should update Person#attributes" do
        expect(data).to include(subject.id)
      end

      it "should update question_sets collection" do
        expect(person.question_sets).to include(subject)
      end

      it "should return question set" do
        is_expected.to be_an_instance_of(QuestionSet)
      end

      it "should error if parent not created" do
        person = Person.new
        expect { person.question_sets.create }.to raise_error(Error, "Create parent first")
      end

      it "should retrieve from registered" do
        found_qs = person.question_sets.retrieve(subject.id)
        expect(subject).to be (found_qs)
      end

    end


    describe "#refresh" do

      subject { person.question_sets }
      let(:qs) { QuestionSet.create }
      before(:each) { person.attributes[:question_sets] << qs.id }

      it "should register new data from parent" do
        person.attributes[:question_sets].clear
        person.attributes[:question_sets].push(qs.id)
        expect(QuestionSet).to receive(:retrieve).with(qs.id).and_call_original
        subject.refresh
      end

      it "should clear and reload" do
        expect(subject).to receive(:clear).and_call_original
        expect(QuestionSet).to receive(:retrieve).and_call_original
        expect(QuestionSet).to receive(:retrieve).with(qs.id) { qs.clone }
        result = subject.refresh
        expect(subject.count).to be(2)
        expect(subject).to be(result)
      end

    end
  end
end
