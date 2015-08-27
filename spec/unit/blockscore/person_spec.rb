module BlockScore
  RSpec.describe Person do
    let(:api_stub) { @api_stub }
    let(:action) { -> { create(:person).details } }

    it '#valid?' do
      person = create(:person, status: 'valid')
      expect(person.valid?).to eq(true)
      expect(person.invalid?).to eq(false)
    end

    it '#invalid?' do
      person = create(:person, status: 'invalid')
      expect(person.invalid?).to eq(true)
      expect(person.valid?).to eq(false)
    end
  end
end
