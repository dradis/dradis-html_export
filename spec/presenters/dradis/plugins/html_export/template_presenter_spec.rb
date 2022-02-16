require 'rails_helper'

RSpec.describe Dradis::Plugins::HtmlExport::TemplatePresenter do
  class FakeView
    include ActionView::Helpers::TextHelper
  end

  let(:template_presenter) { described_class.new(template, FakeView.new) }

  describe '#title' do
    context 'when template is a string' do
      let(:template) { 'basic.html.erb' }

      it 'returns the string' do
        expect(template_presenter.title).to eq template
      end
    end

    context 'when template is a RTP' do
      let(:template) do
        double(
          'ReportTemplateProperties',
          title: 'Basic',
          template_file: 'basic.html.erb'
        )
      end

      it 'returns a formatted title' do
        expect(template_presenter.title).to eq "#{template.title} - <small>#{template.template_file}</small>"
      end
    end
  end
end
