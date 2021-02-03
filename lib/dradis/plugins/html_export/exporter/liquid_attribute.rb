module Dradis
  module Plugins
    module HtmlExport
      class Exporter::LiquidAttribute
        def initialize(params = {})
          @categorized_issues = params[:categorized_issues]
          @controller = params[:controller]
          @issues = params[:issues]
          @nodes = params[:nodes]
          @notes = params[:notes]
          @project = params[:project]
          @report_category = params[:report_category]
          @tags = params[:tags]
          @title = params[:title]
          @user = params[:user]
        end

        def format
          # Liquid::Template#render expects hash keys with string.
          {
            categorized_issues: format_categorized_issues(@categorized_issues),
            issues: format_issues(@issues),
            nodes: format_nodes(@nodes),
            notes: format_notes(@notes),
            project: format_project(@project),
            report_category: format_category(@report_category),
            tags: format_tags(@tags),
            title: @title,
            user: format_user(@user)
          }.deep_stringify_keys
        end

        private

        def format_categorized_issues(categorized_issues)
          categorized_issues.transform_values do |issues|
            format_issues(issues)
          end
        end

        def format_category(category)
          {
            id: category.id,
            name: category.name
          }
        end

        def format_evidence(evidence)
          {
            author: evidence.author,
            content: @controller.helpers.markup(evidence.content),
            fields: evidence.fields,
            id: evidence.id,
            issue: format_note(evidence.issue),
            node: format_node(evidence.node),
            raw_content: evidence.content
          }
        end

        # issue#evidence_by_node is an array of grouped node with evidence
        # E.g. [
        #   [Node1, [Node1Evidence1, Node1Evidence2]],
        #   [Node2, [Node2Evidence1, Node2Evidence2]]
        # ]
        def format_evidence_by_node(evidence_by_node)
          evidence_by_node.map do |node, evidence_collection|
            {
              node: format_node(node),
              evidence: format_evidence_collection(evidence_collection)
            }
          end
        end

        def format_evidence_collection(evidence_collection)
          evidence_collection.map { |evidence| format_evidence(evidence) }
        end

        def format_issues(issues)
          issues.map do |issue|
            format_note(issue).merge({
              evidence: format_evidence_collection(issue.evidence),
              evidence_by_node: format_evidence_by_node(issue.evidence_by_node),
              tags: format_tags(issue.tags)
            })
          end
        end

        def format_node(node)
          {
            children_count: node.children_count,
            created_at: node.created_at,
            id: node.id,
            label: node.label,
            parent_id: node.parent_id,
            position: node.position,
            updated_at: node.updated_at
          }
        end

        def format_nodes(nodes)
          nodes.map { |node| format_node(node) }
        end

        def format_note(note)
          {
            author: note.author,
            category: format_category(note.category),
            created_at: note.created_at,
            fields: note.fields,
            id: note.id,
            node: format_node(note.node),
            raw_text: note.text,
            text: @controller.helpers.markup(note.text),
            updated_at: note.updated_at
          }
        end

        def format_notes(notes)
          notes.map { |note| format_note(note) }
        end

        def format_project(project)
          {
            created_at: project.created_at,
            end_date: project.end_date,
            id: project.id,
            name: project.name,
            start_date: project.start_date,
            team: format_team(project.team),
            updated_at: project.updated_at
          }
        end


        def format_tags(tags)
          tags.map do |tag|
            {
              color: tag.color,
              id: tag.id,
              name: tag.display_name
            }
          end
        end

        def format_team(team)
          return unless team

          {
            id: team.id,
            name: team.name,
            since: team.team_since,
            type: team.team_type
          }
        end

        def format_user(user)
          return unless user

          {
            email: user.email,
            id: user.id,
            name: user.name,
            team: format_team(user.team)
          }
        end
      end
    end
  end
end
