class Documents
  PAGE_SIZE = 'A4'.freeze
  ORIENTATION = 'Landscape'.freeze
  LOW_QUANTITY = true.freeze
  ZOOM = 1.freeze
  DPI = 75.freeze

  def self.render_pdf(filename:, template:, layout:)
    { pdf: filename,
      page_size: PAGE_SIZE,
      template: template,
      layout: layout,                                                                                                                                        
      orientation: ORIENTATION,
      lowquality: LOW_QUANTITY,
      zoom: ZOOM,
      dpi: DPI }
  end
end
