# frozen_string_literal: true

RSpec.shared_examples 'sorts correctly' do
  it do
    expect(ordered.map(&:id)).to eq([*resources_ids, extra_resource.id])
  end
end
