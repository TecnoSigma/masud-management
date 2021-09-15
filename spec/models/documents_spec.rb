require 'rails_helper'

RSpec.describe Documents do
  describe '.render_pdf' do
    it 'mounts params to render PDF file' do
      filename = 'ABC'
      template = 'file_template'
      layout = 'file_layout'
      
      expected_result = { pdf: filename,
                          page_size: 'A4',
                          template: template,
                          layout: layout,
                          orientation: 'Landscape',
                          lowquality: true,
                          zoom: 1,
                          dpi: 75 }

      result = described_class.render_pdf(filename: filename, template: template, layout: layout)

      expect(expected_result).to eq(result)
    end
  end
end
