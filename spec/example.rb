require 'rubygems'
require 'pdf/stamper'


@pdf = PDF::Stamper.new(File.join(File.dirname(__FILE__), "test_template.pdf"))
@pdf.text :text_field01, "test"
@pdf.text :text_field02, "test2"
@pdf.image :button_field01, File.join(File.dirname(__FILE__), "logo.gif")

@pdf.save_as "test_output.pdf"