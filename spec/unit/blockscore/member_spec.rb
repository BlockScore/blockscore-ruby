module BlockScore
  RSpec.describe Collection::Member do
    let(:parent) { create(:fake_resource) }
    let(:member_class) { FakeResource }
    let(:collection) { Collection.new(parent, member_class) }
    before do
      Util::PLURAL_LOOKUP['fake_resource'] = 'fake_resources'
      allow(member_class).to receive(:create) { create(:fake_member, parent_id: parent.id) }
    end

    context 'when created' do
      let(:created) { create(:fake_member, parent_id: parent.id) }
      subject { collection.create }
      before(:each) do
        allow(member_class).to receive(:create) { created }
      end

      it 'should have the Parent#id' do
        expect(member_class).to receive(:create).with(fake_resource_id: parent.id).and_call_original
        subject
      end
    end

    context 'when instantiating a new' do
      subject { collection.new }

      it 'should delegate to member_class' do
        # odd bug... test fails when replaced with parent.id
        args = { fake_resource_id: collection.parent.id }
        expect(member_class).to receive(:new).with(args).and_call_original
        collection.new
      end

      it 'should save parent if not persisted' do
        parent = create(:fake_resource)
        parent.id = nil
        collection = Collection.new(parent, member_class)
        item = collection.new
        expect(parent).to receive(:save).and_call_original
        item.save
      end

      it 'should have Parent#id' do
        subject.person_id = 'some_id'
        subject.save
        expect(subject.fake_resource_id).to eq(collection.parent.id)
      end
    end
  end
end
