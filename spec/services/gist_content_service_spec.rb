# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GistContentService, type: :service do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:gist) { create(:link, :gist, linkable: question) }
  subject { described_class.call(gist.send(:gist_id)) }

  it 'returning a value' do
    expect(subject).to eq('Gist text - gist text')
  end
end
