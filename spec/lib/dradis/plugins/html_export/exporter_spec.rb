require 'rails_helper'

describe Dradis::Plugins::HtmlExport::Exporter do
  before { Dradis::Plugins::HtmlExport::Exporter.include(ApplicationHelper) }

  let!(:project) { create(:project, :with_team) }

  let!(:content_blocks) { create_list(:content_block, 5, project: project) }
  let!(:issues) { create_list(:issue, 5, node: project.issue_library) }
  let!(:nodes) { create_list(:node, 5, project: project) }
  let!(:tags) { create_list(:tag, 5, project: project) }

  let(:controller) { Dradis::Plugins::HtmlExport::ExportController.new }

  let(:exporter) { described_class.new(export_options) }

  context 'html' do
    let(:export_options) do
      {
        project_id: project.id,
        template: Dradis::Plugins::HtmlExport::Engine.root.join(
          'spec/fixtures/files/template.html.erb'
        )
      }
    end

    it 'exports html' do
      html = exporter.export

      issues.each do |issue|
        expect(html.include?(issue.title))
      end
    end
  end

  context 'templates' do
    describe 'basic template' do
      let(:export_options) do
        {
          project_id: project.id,
          template: Dradis::Plugins::HtmlExport::Engine.root.join(
            'templates/basic.html.erb'
          )
        }
      end

      it 'exports html' do
        html = exporter.export

        issues.each do |issue|
          expect(html.include?(issue.title))
        end
      end
    end

    describe 'default template' do
      let(:export_options) do
        {
          project_id: project.id,
          template: Dradis::Plugins::HtmlExport::Engine.root.join(
            'templates/default_dradis_template_v3.0.html.erb'
          )
        }
      end

      it 'exports html' do
        html = exporter.export

        issues.each do |issue|
          expect(html.include?(issue.title))
        end
      end
    end
  end

  context 'liquid' do
    let(:export_options) do
      {
        project_id: project.id,
        template: Dradis::Plugins::HtmlExport::Engine.root.join(
          'spec/fixtures/files/liquid.html.erb'
        )
      }
    end

    before do
      report_content = project.content_library
      report_content.properties = {
        'dradis.project' => project.name,
        'dradis.version' => 'v1.0'
      }
      report_content.save

      nodes.each do |node|
        create(:evidence, node: node, issue: issues.first)
      end

      create(:issue,
        node: project.issue_library,
        text: <<-TEXT
#[Title]#
Test Issue

#[Description]#
*Project:* {{ project.name }}
*Document Properties:*
* {{ document_properties.dradis.project }}
* {{ document_properties.dradis.version }}

*Nodes:*
{% for node in nodes %}
* {{ node.label }}
{% endfor %}

*Content blocks:*
{% for content_block in content_blocks %}
* {{ content_block.fields['Title'] }}
{% endfor %}

*Tags:*
{% for tag in tags %}
* {{ tag.name }}
{% endfor %}
TEXT
      )
    end

    it 'parses liquid syntax' do
      html = exporter.export

      expect(html).to include project.name

      project.content_library.properties.each do |_, value|
        expect(html).to include value
      end

      nodes.each do |node|
        expect(html).to include node.label
      end

      content_blocks.each do |content_block|
        expect(html).to include content_block.title
      end

      tags.each do |tag|
        expect(html).to include tag.name
      end
    end
  end
end
