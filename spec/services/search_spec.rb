# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Search do
  let(:search_text) { 'search_text' }
  %w[question answer comment user].each do |type|
    it "type: #{type} search" do
      expect(type.classify.constantize).to receive(:search).with(search_text, page: 1, per_page: 20)
      Services::Search.call(q: search_text, type: type)
    end
  end

  context 'all and wrong types' do
    %w[all undefined any_other_type].each do |type|
      it "type: #{type} search" do
        expect(ThinkingSphinx).to receive(:search).with(search_text, page: 1, per_page: 20)
        Services::Search.call(q: search_text, type: type)
      end
    end
  end
end
