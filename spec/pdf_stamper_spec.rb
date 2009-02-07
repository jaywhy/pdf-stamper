$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'pdf/stamper'

describe PDF::Stamper do
  before(:each) do
    @pdf = PDF::Stamper.new(File.join(File.dirname(__FILE__), "test_template.pdf"))
    @pdf.text :text_field01, "test"
    @pdf.text :text_field02, "test2"
    @pdf.image :button_field01, File.join(File.dirname(__FILE__), "logo.gif")
  end

  it "should create PDF document" do
    @pdf.to_s.should_not be_nil
  end

  it "should save PDF document" do
    @pdf.save_as "test_output.pdf"
    File.exist?("test_output.pdf").should be_true
    File.delete("test_output.pdf") # Comment this out to view the output
  end
end
