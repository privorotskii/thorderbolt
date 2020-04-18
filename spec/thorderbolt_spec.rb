# frozen_string_literal: true

RSpec.describe Thorderbolt do
  it 'has a version number' do
    expect(Thorderbolt::VERSION).not_to be nil
  end

  describe 'Execution' do
    after { [Post, User, City].each(&:delete_all) }

    let!(:shuffled_objects) do
      (1..5).map { |i| City.create(name: "City #{i}") }.shuffle
    end
    let!(:omitted_object) { City.create(name: 'Nothing') }
    let(:shuffled_object_fields) { shuffled_objects.map(&:name) }
    let(:shuffled_object_ids) { shuffled_objects.map(&:id) }

    context 'with no table name specified' do
      subject { City.order_as(name: shuffled_object_fields) }

      it 'returns results including unspecified objects' do
        expect(subject).to include omitted_object
      end

      it 'returns results in the given order' do
        expect(subject.map(&:id)).to eq [*shuffled_object_ids, omitted_object.id]
      end

      context 'when the order is chained with other orderings' do
        subject do
          City
            .order_as(name: shuffled_object_fields.take(3))
            .order(:id)
        end

        it 'returns results in the given order by multiple fields' do
          expect(subject.map(&:id)).to eq [
            *shuffled_object_ids.take(3),
            *shuffled_object_ids.drop(3).sort,
            omitted_object.id
          ]
        end
      end

      context 'when the order includes nil' do
        let(:shuffled_objects) do
          Array.new(5) do |i|
            City.create(name: (i == 0 ? nil : "Field #{i}"))
          end.shuffle
        end

        it 'raises an error' do
          expect { subject }.to raise_error(StandardError)
        end
      end
    end
  end
end
