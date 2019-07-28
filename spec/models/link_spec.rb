require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }
  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should allow_value('https://google.com').for(:url) }
  it { should allow_value('http://google.com').for(:url) }
  it { should_not allow_value('google.com').for(:url) }
  it { should_not allow_value('htp://google.com').for(:url) }

  describe '#gist?' do
    let(:question) { create(:question) }
    let(:link) { create(:link, linkable: question) }
    let(:gist_link) { create(:link, :gist, linkable: question) }

    it 'returning true if gist link' do
      expect(gist_link.gist?).to eq true
    end

    it 'returning false if not gist' do
      expect(link.gist?).to eq false
    end
  end
end
