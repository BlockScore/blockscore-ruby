module BlockScore
  RSpec.describe Collection do
    let(:parent) { create(:fake_resource) }
    let(:member_class) { FakeResource }
    let(:collection) { Collection.new(parent, member_class) }

    before do
      Util::PLURAL_LOOKUP['fake_resource'] = 'fake_resources'
      allow(member_class).to receive(:create) { create(:fake_member, parent_id: parent.id) }
    end

    describe '#all' do
      subject { collection.all  }

      it 'should return self' do
        is_expected.to be(collection)
      end
    end

    describe '#create' do
      let(:created) { create(:fake_member, parent_id: parent.id) }
      subject { collection.create }
      before(:each) do
        allow(member_class).to receive(:create) { created }
      end

      it 'should send merged default and arg params' do
        foriegn_key = :"#{parent.class.resource}_id"
        expect(member_class).to receive(:create).with(foriegn_key => parent.id, foo_param: 'bar_attr')
        collection.create(foo_param: 'bar_attr')
      end

      it 'should update ids in Parent#attributes' do
        expect(parent.attributes[:fake_resources]).to include(subject.id)
      end

      it 'should add to collection' do
        expect(collection).to include(subject)
      end

      it 'should error if parent not created' do
        parent = FakeResource.new
        collection = Collection.new(parent, member_class)
        expect { collection.create }.to raise_error(Error, 'Create parent first')
      end

      it 'should retrieve item from registered' do
        found_qs = collection.retrieve(subject.id)
        expect(subject).to eq(found_qs)
      end
    end

    describe '#new' do
      subject { collection.new }

      it 'should add to collection' do
        count = collection.size
        result = collection.new
        expect(collection.size).to eq(count + 1)
        expect(collection).to include(result)
      end

      context 'when saving' do
        it 'should have parent#id after saving' do
          subject.fake_resource_id = 'some_id'
          subject.save
          expect(subject.fake_resource_id).to eq(parent.id)
        end

        it 'should be retrievable after' do
          collection.create
          subject.save
          collection.create
          expect(collection.retrieve(subject.id)).to be(subject)
        end
      end
    end

    describe '#retrieve' do
      context 'when in person#attributes' do
        let(:parent) { create(:fake_resource) }
        let(:existing_id) { parent.attributes[:fake_resources].last }
        subject { collection.retrieve(existing_id) }

        it 'should retrieve correctly' do
          last = collection.last
          expect(subject).to eq(last)
          expect(subject.id).to eq(existing_id)
        end

        it 'checks collect' do
          expect(collection).to receive(:each).and_call_original
          collection.retrieve(existing_id)
        end
      end

      context 'when not in person#attributes' do
        let(:parent) { create(:fake_resource, members_count: 0) }
        let(:collection) { Collection.new(parent, member_class) }
        let(:item) { create(:fake_member, parent_id: parent.id) }
        let(:data) { parent.attributes.fetch(:fake_resources) }
        subject { collection.retrieve(item.id) }

        before(:each) do
          allow(member_class).to receive(:retrieve).with(item.id) { item }
        end

        it 'uses member_class.retrieve' do
          expect(member_class).to receive(:retrieve).with(item.id).and_return(item)
          expect(collection.retrieve(item.id)).to eq(item)
        end

        it 'registers new question set' do
          aggregate_failures('for person and collection') do
            expect(collection).to receive(:<<).and_call_original
            expect(data).to receive(:<<).with(item.id).and_call_original
          end
          collection.retrieve(item.id)
        end

        it 'errors if not belonging' do
          item.fake_resource_id = 'some_not_associated_id'
          expect { subject }.to raise_error(Error, 'None belonging')
        end
      end
    end

    describe '#refresh' do
      subject { collection }
      let(:item) { member_class.create }
      before(:each) { parent.attributes[:fake_resources] << item.id }

      # refactor
      it 'should register new data from parent' do
        parent.attributes[:fake_resources].clear
        parent.attributes[:fake_resources].push(item.id)
        expect(member_class).to receive(:retrieve).with(item.id).at_least(:twice).and_call_original
        subject.refresh
      end

      it 'should clear and reload' do
        expect(subject).to receive(:clear).and_call_original
        expect(subject).to receive(:register_parent_data).and_call_original
        result = subject.refresh
        expect(subject).to be(result)
      end

      context 'when creating' do
        it 'should be included in refresh' do
          result = subject.create
          subject.refresh
          expect(subject.map(&:id)).to include(result.id)
        end

        it 'should include saved in refresh' do
          item = FakeResource.new(fake_resource_id: parent.id)
          allow(member_class).to receive(:new) { item }
          allow(item).to receive(:save) { create(:fake_member, parent_id: parent.id) }
          result = subject.new
          result.save
          subject.refresh
          expect(subject.map(&:id)).to include(result.id)
        end
      end

      context 'when retrieving belonging' do
        it 'should be included in refresh' do
          item = create(:fake_resource)
          item.parent_id = parent.id
          allow(member_class).to receive(:retrieve) { item }
          result = subject.retrieve(item.id)
          subject.refresh
          expect(subject.map(&:id)).to include(result.id)
        end
      end
    end
  end
end
