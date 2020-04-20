# frozen_string_literal: true

RSpec.describe Thorderbolt do
  it 'has a version number' do
    expect(Thorderbolt::VERSION).not_to be nil
  end

  describe '.order_as' do
    after { [Post, User, City].each(&:delete_all) }

    let(:resources_ids) { resources.map(&:id) }

    context 'with no table name specified' do
      subject(:ordered) { City.order_as(name: resources_field_values) }

      let!(:resources) { create_list(:city, 4).shuffle }
      let!(:extra_resource) { create(:city, :extra) }

      let(:resources_field_values) { resources.map(&:name) }

      it_behaves_like 'sorts correctly'
    end

    context 'with order by joined table' do
      subject(:ordered) do
        User
          .joins(:city)
          .order_as(
            cities: { name: resources_field_values }
          )
      end

      let!(:resources) { create_list(:user, 4, :with_city).shuffle }
      let!(:extra_resource) { create(:user, :extra, :with_city) }

      let(:resources_field_values) { resources.map(&:city).map(&:name) }

      it_behaves_like 'sorts correctly'
    end

    context 'with order by joined to joined table' do
      subject(:ordered) do
        Post
          .joins(:city)
          .order_as(
            users: { cities: { name: resources_field_values } }
          )
      end

      let!(:resources) { create_list(:post, 4, :with_user).shuffle }
      let!(:extra_resource) { create(:post, :extra, :with_user) }

      let(:resources_field_values) do
        resources.map(&:user).map(&:city).map(&:name)
      end

      it_behaves_like 'sorts correctly'
    end

    context 'when the order is chained with other orderings' do
      subject(:ordered) do
        City
          .order_as(name: resources_field_values.take(3))
          .order(:id)
      end

      let!(:resources) { create_list(:city, 4).shuffle }
      let!(:extra_resource) { create(:city, :extra) }

      let(:resources_field_values) { resources.map(&:name) }

      it 'returns results in the given order by multiple fields' do
        expect(ordered.map(&:id)).to eq [
          *resources_ids.take(3),
          *resources_ids.drop(3).sort,
          extra_resource.id
        ]
      end
    end

    context 'when the order includes nil' do
      subject(:ordered) { City.order_as(name: resources_field_values) }

      let!(:resources) { create_list(:city, 4).shuffle }
      let!(:extra_resource) { create(:city, :extra) }

      let(:resources_field_values) { resources.map(&:name) + [nil] }

      it 'raises an error' do
        expect { ordered }.to raise_error(Thorderbolt::ThorderboltError)
      end
    end

    # TODO: add possibility to order_as, but equally between sort params
  end
end
