module BlockScore
  RSpec.describe Collection::Member do
    let(:parent) { create(:fake_resource) }
    let(:member_class) { FakeResource }
    let(:collection) { Collection.new(parent, member_class) }

    before do
      Util::PLURAL_LOOKUP['fake_resource'] = 'fake_resources'
      allow(member_class).to receive(:create) { create(:fake_member, parent_id: parent.id) }
    end

    context 'when saving' do
      let(:member_class) { FakeResource                         }
      let(:parent)       { FakeResource.new                     }
      let(:collection)   { Collection.new(parent, member_class) }
      subject(:member)   { collection.new                       }

      context 'when parent is not persisted' do
        before { allow(parent).to receive(:save).and_call_original }

        it { expect(member.save).to be(true) }

        it do
          member.save
          expect(parent).to have_received(:save).once
        end

        context 'after saving' do
          before { member.save }
          let(:member_parent_id) { member.fake_resource_id }

          it { is_expected.to be_persisted }
          it { expect(parent).to be_persisted }
          it { expect(member_parent_id).to eql(parent.id) }
        end
      end

      it 'should not save persisted parent' do
        parent.save

        aggregate_failures('when saving') do
          expect(parent).not_to receive(:save)
          expect(member.save).to be(true)
        end

        aggregate_failures('after saving') do
          expect(member.persisted?).to be(true)
          expect(parent.persisted?).to be(true)
          foriegn_key = :"#{parent.class.resource}_id"
          expect(member.send(foriegn_key)).to eq(parent.id)
        end
      end

      it 'should not add to parent if existing' do
        member.save
        embedded_resource = :"#{Util.to_plural(parent.class.resource)}"
        tracked_ids = parent.send(embedded_resource)
        size = tracked_ids.size
        member.save
        expect(size).to eql(size)
        expect(tracked_ids).to include(member.id)
      end
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
