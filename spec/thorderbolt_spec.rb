# frozen_string_literal: true

RSpec.describe Thorderbolt do
  it 'has a version number' do
    expect(Thorderbolt::VERSION).not_to be nil
  end

  describe '.order_as' do
    after { [Post, User, City].each(&:delete_all) }

    let(:resources_field_values) { resources.map(&:name) }
    let(:resources_ids) { resources.map(&:id) }

    context 'with no table name specified' do
      subject(:ordered) { City.order_as(name: resources_field_values) }

      let!(:resources) do
        (1..4).map { |i| City.create(name: "City #{i}") }.shuffle
      end
      let!(:extra_resource) { City.create(name: 'Nothing') }

      it 'returns not extra resource too' do
        expect(ordered).to include extra_resource
      end

      it 'returns results in the given order' do
        expect(ordered.map(&:id)).to eq([*resources_ids, extra_resource.id])
      end
    end

    context 'with order by joined table' do
      subject(:ordered) { User.joins(:city).order_as(cities: { name: resources_field_values }) }

      let!(:resources) do
        (1..4).map do |i|
          User.create(
            name: "User #{rand(1..10)}",
            city: City.create!(name: "City #{i}")
          )
        end.shuffle
      end
      let(:resources_field_values) { resources.map(&:city).map(&:name) }
      let!(:extra_resource) { User.create(name: 'John', city: City.create(name: 'Nothing')) }

      it 'returns not extra resource too' do
        expect(ordered).to include extra_resource
      end

      it 'returns results in the given order' do
        expect(ordered.map(&:id)).to eq([*resources_ids, extra_resource.id])
      end
    end

    context 'with order by joined to joined table' do
      subject(:ordered) { Post.joins(:city).order_as(users: { cities: { name: resources_field_values } }) }

      let(:resources_field_values) { resources.map(&:user).map(&:city).map(&:name) }

      let!(:resources) do
        (1..4).map do |i|
          Post.create(
            name: "Post #{i}",
            user: User.create(
              name: "User #{i}",
              city: City.create!(name: "City #{i}")
            )
          )
        end.shuffle
      end
      let!(:extra_resource) { Post.create(name: 'Post', user: User.create(name: 'John', city: City.create(name: 'Nothing'))) }

      it 'returns not extra resource too' do
        expect(ordered).to include extra_resource
      end

      it 'returns results in the given order' do
        expect(ordered.map(&:id)).to eq([*resources_ids, extra_resource.id])
      end
    end

    context 'when the order is chained with other orderings' do
      subject(:ordered) do
        City
          .order_as(name: resources_field_values.take(3))
          .order(:id)
      end

      let!(:resources) do
        (1..4).map { |i| City.create(name: "City #{i}") }.shuffle
      end
      let!(:extra_resource) { City.create(name: 'Nothing') }

      it 'returns results in the given order by multiple fields' do
        expect(subject.map(&:id)).to eq [
          *resources_ids.take(3),
          *resources_ids.drop(3).sort,
          extra_resource.id
        ]
      end
    end

    # TODO refactor this test, using shared examples
    # TODO add possibility to order_as, but equally between sort params

    # context 'when the order includes nil' do
    #   let(:resources) do
    #     Array.new(5) do |i|
    #       City.create(name: (i == 0 ? nil : "Field #{i}"))
    #     end.shuffle
    #   end

    #   it 'raises an error' do
    #     subject
    #     expect { subject }.to raise_error(Thorderbolt::ThorderboltError)
    #   end
    # end
  end
end
