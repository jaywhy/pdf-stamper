# = pdf/stamper/rjb.rb -- PDF template stamping.
#
#  Copyright (c) 2007-2009 Jason Yates

require 'rubygems'
require 'rjb'

Rjb::load(File.join(File.dirname(__FILE__), '..', '..', '..', 'ext', 'iText-2.1.4.jar'), ['-Djava.awt.headless=true'])

module PDF
  # PDF::Stamper::RJB
  #
  # RJB needs the LD_LIBRARY_PATH and JAVA_HOME environment set for it
  # to work correctly.  For example on my system:
  #
  # export LD_LIBRARY_PATH=/usr/java/jdk1.6.0/jre/lib/i386/:/usr/java/jdk1.6.0/jre/lib/i386/client/:./
  # export JAVA_HOME=/usr/java/jdk1.6.0/
  #
  # Check the RJB documentation if you are having issues with this.
  class Stamper
    def initialize(pdf = nil, options = {})
      @bytearray    = Rjb::import('java.io.ByteArrayOutputStream')
      @filestream   = Rjb::import('java.io.FileOutputStream')
      @acrofields   = Rjb::import('com.lowagie.text.pdf.AcroFields')
      @pdfreader    = Rjb::import('com.lowagie.text.pdf.PdfReader')
      @pdfstamper   = Rjb::import('com.lowagie.text.pdf.PdfStamper')
      @pdfwriter    = Rjb::import('com.lowagie.text.pdf.PdfWriter')
      @image_class  = Rjb::import('com.lowagie.text.Image')
      @pdf_content_byte_class = Rjb::import('com.lowagie.text.pdf.PdfContentByte')
      @basefont_class = Rjb::import('com.lowagie.text.pdf.BaseFont')
      @rectangle = Rjb::import('com.lowagie.text.Rectangle')
    
      template(pdf) if ! pdf.nil?
    end
  
    def template(template)
      reader = @pdfreader.new(template)
      @pagesize = reader.getPageSize(1)
      @numpages = reader.getNumberOfPages()
      @baos = @bytearray.new
      @stamp = @pdfstamper.new(reader, @baos)
      @form = @stamp.getAcroFields()
    end

    # Set a button field defined by key and replaces with an image.
    def image(key, image_path)
      # Idea from here http://itext.ugent.be/library/question.php?id=31 
      # Thanks Bruno for letting me know about it.
      img = @image_class.getInstance(image_path)
      img_field = @form.getFieldPositions(key.to_s)

      
      rect = @rectangle.new(img_field[1], img_field[2], img_field[3], img_field[4])
      img.scaleToFit(rect.width, rect.height)
      img.setAbsolutePosition(
        img_field[1] + (rect.width - img.getScaledWidth) / 2,
        img_field[2] + (rect.height - img.getScaledHeight) /2
      )

      cb = @stamp.getOverContent(img_field[0].to_i)
      cb.addImage(img)
    end
    
    # Takes the PDF output and sends as a string.  Basically it's sole
    # purpose is to be used with send_data in rails.
    def to_s
      fill
      @baos.toByteArray
    end
    
    def add_images(images)
      basefont = @basefont_class.createFont(@basefont_class.HELVETICA, @basefont_class.CP1252, @basefont_class.NOT_EMBEDDED)
      image_size = []
      half_page_width = @pagesize.width() / 2
      half_page_height = @pagesize.height() / 2
      image_size[0] = half_page_width - 80
      image_size[1] = half_page_height - 80
      pages = (images.length / 4.0).ceil
      pages.times do |index|
        page_number = index + @numpages + 1
        image_index = index * 4
        @stamp.insertPage(page_number, @pagesize)
        over = @stamp.getOverContent(page_number)
        over.setFontAndSize(basefont, 12.0)
        4.times do |n|
          if pdf_image = images[image_index + n]
            if image_path = pdf_image[0]
              img = @image_class.getInstance(image_path)
              img.scaleToFit(image_size[0] + 30, (image_size[1]))
              img_x_offset = (half_page_width - image_size[0]) / 2
              img_y_offset = (half_page_height - img.getScaledHeight()) / 2
              case n
              when 0
                img.setAbsolutePosition(img_x_offset, (half_page_height + img_y_offset))
              when 1
                img.setAbsolutePosition((half_page_width + (img_x_offset - 30)), (half_page_height + img_y_offset))
              when 2
                img.setAbsolutePosition(img_x_offset, img_y_offset)
              when 3
                img.setAbsolutePosition((half_page_width + (img_x_offset - 30)), img_y_offset)
              end
              over.addImage(img)
            end
            if image_label = pdf_image[1]
              over.beginText()
              over.showTextAligned(@pdf_content_byte_class.ALIGN_CENTER, image_label, (img.getAbsoluteX() + ((image_size[0] + 30) / 2)), (img.getAbsoluteY() - 15), 0)
              over.endText()
            end
          end
        end
      end
      @stamp.setFullCompression()
    end
    
    def add_image_on_page(page, x, y, url)
      over = @stamp.getOverContent(page)
      img = @image_class.getInstance(url)
      img.setAbsolutePosition(x,y)
      img.scaleToFit(200,70)
      over.addImage(img)
    end
  end
end
