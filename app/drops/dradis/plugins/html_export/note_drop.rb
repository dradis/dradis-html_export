module Dradis::Plugins::HtmlExport
  class NoteDrop < Liquid::Drop
    def initialize(note)
      @note = note
    end

    def title
      @note.title
    end
  end
end
