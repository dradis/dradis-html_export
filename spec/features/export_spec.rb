# frozen_string_literal: true

module Dradis::Plugins::HtmlExport
  describe 'Receiving an export request' do
    it 'calls the exporter using the request parameters' do
      allow(Dradis::Plugins::HtmlExport::Exporter).to receive(:new) do
        OpenStruct.new(export: '<html></html>')
      end
      parameters = { project_id: '1', template: 'rspec.html.erb' }

      expect(Dradis::Plugins::HtmlExport::Exporter).to \
        receive(:new).with(
          ActionController::Parameters.new(parameters).permit!
        )
      visit dradis_html_export_path(parameters)
    end
  end
end
