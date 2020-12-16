class HtmlExportTasks < Thor
  include Rails.application.config.dradis.thor_helper_module

  namespace     "dradis:plugins:html"

  desc 'export', 'export the current repository structure as an HTML document'
  method_option :output,   required: false, type: :string, desc: "the report file to create (if ends in .html), or directory to create it in"
  method_option :template, required: true, type: :string, desc: "the template file to use. If not provided the value of the 'advanced_word_export:docx' setting will be used."

  def export
    require 'config/environment'

    # The options we'll end up passing to the Processor class
    opts = {}

    report_path = options.output || Rails.root
    unless report_path.to_s =~ /\.html\z/
      date = DateTime.now.strftime("%Y-%m-%d")
      base_filename = "dradis-report_#{date}.html"

      report_filename = NamingService.name_file(
        original_filename: base_filename,
        pathname: Pathname.new(report_path)
      )

      report_path = File.join(report_path, report_filename)
    end

    if template = options.template
      shell.error("Template file doesn't exist") && exit(1) unless File.exists?(template)
      task_options[:template] = template
    end

    detect_and_set_project_scope

    exporter = Dradis::Plugins::HtmlExport::Exporter.new(task_options)
    html = exporter.export

    File.open(report_path, 'w') do |f|
      f << html
    end

    logger.info{ "Report file created at:\n\t#{report_path}" }
  end

end
