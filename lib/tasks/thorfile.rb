class HtmlExportTasks < Thor
  include Dradis::Plugins::thor_helper_module.to_s.constantize

  namespace     "dradis:plugins:html"

  desc 'export', 'export the current repository structure as an HTML document'
  method_option :output,   required: false, type: :string, desc: "the report file to create (if ends in .html), or directory to create it in"
  method_option :template, required: true, type: :string, desc: "the template file to use. If not provided the value of the 'advanced_word_export:docx' setting will be used."

  def export
    require 'config/environment'

    # The options we'll end up passing to the Processor class
    opts = {}

    STDOUT.sync = true
    logger = Logger.new(STDOUT)
    logger.level = Logger::DEBUG
    opts[:logger] = logger
    content_service = nil

    report_path = options.output || Rails.root
    unless report_path.to_s =~ /\.html\z/
      date      = DateTime.now.strftime("%Y-%m-%d")
      sequence  = Dir.glob(File.join(report_path, "dradis-report_#{date}_*.html")).collect { |a| a.match(/_([0-9]+)\.html\z/)[1].to_i }.max || 0
      report_path = File.join(report_path, "dradis-report_#{date}_#{sequence + 1}.html")
    end


    if template = options.template
      shell.error("Template file doesn't exist") && exit(1) unless File.exists?(template)
      opts[:template] = template
    end

    detect_and_set_project_scope
    exporter = Dradis::Plugins::HtmlExport::Exporter.new(
      content_service: Dradis::Plugins::ContentService.new(plugin: Dradis::Plugins::HtmlExport)
    )

    doc = exporter.export(opts)

    File.open(report_path, 'w') do |f|
      f << doc
    end

    logger.info{ "Report file created at:\n\t#{report_path}" }
    logger.close
  end


end
