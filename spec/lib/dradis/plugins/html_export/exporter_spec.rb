require 'rails_helper'

describe Dradis::Plugins::HtmlExport::Exporter do
  let!(:project) { create(:project) }
  let!(:issues) { create_list(:issue, 3, node: project.issue_library) }

  let(:export_options) do
    {
      project_id: project.id,
      template: File.join(
        File.dirname(__FILE__),
        '../../../../',
        'fixtures',
        'files',
        'template.html.erb'
      )
    }
  end

  after do
    exporter.remove_tmp_folder
  end

  let(:exporter) { described_class.new(export_options) }

  it 'exports html' do
    html = exporter.export

    issues.each do |issue|
      expect(html.include?(issue.title))
    end
  end
end
