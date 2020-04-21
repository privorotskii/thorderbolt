# frozen_string_literal: true

RSpec.describe Thorderbolt do
  after { [Post, User, City].each(&:delete_all) }

  it 'has a version number' do
    expect(Thorderbolt::VERSION).not_to be nil
  end

  describe '.order_as' do
    let(:resources_ids) { resources.map(&:id) }

    context 'with no table name specified' do
      subject(:ordered) { City.order_as(name: resources_field_values) }

      let!(:resources) { create_list(:city, 4).shuffle }
      let!(:extra_resource) { create(:city, :extra) }

      let(:resources_field_values) { resources.map(&:name) }

      it_behaves_like 'sorts correctly'
    end

    context 'with empty arguments passed' do
      subject(:ordered) { City.order_as(name: []) }

      let!(:resources) { create_list(:city, 4).shuffle }
      let!(:extra_resource) { create(:city, :extra) }

      let(:resources_ids) { resources.map(&:id).sort }

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
  end

  describe '.order_as_any' do
    subject(:ordered_as_any) { City.order_as_any(name: resources_field_values) }

    let!(:resources) { create_list(:city, 2).shuffle }
    let!(:extra_resources) { create_list(:city, 2, :extra) }

    let(:resources_ids) { resources.sort.map(&:id) }
    let(:extra_resources_ids) { extra_resources.sort.map(&:id) }
    let(:resources_field_values) { resources.map(&:name) }

    it 'sorts correctly' do
      expect(ordered_as_any.map(&:id))
        .to eq([*resources_ids, *extra_resources_ids])
    end
  end
end
