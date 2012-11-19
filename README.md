# pdf/stamper - PDF Templates
  http://github.com/jaywhy/pdf-stamper/
  by Jason Yates

## Description

Fill out PDF forms (templates) using iText's PdfStamper.

## Example
    pdf = PDF::Stamper.new("my_template.pdf")
  
    pdf.text :first_name, "Jason"
    pdf.text :last_name, "Yates"
  
    pdf.image :photo, "photo.jpg"
    pdf.checkbox :hungry
    pdf.ellipse(140, 380, 50, 13)
    pdf.rectangle(140, 380, 50, 13)
    pdf.circle(140, 380)
  
    pdf.save_as "my_output.pdf"

Here is how you use it in Rails.

    # In your controller.
    def send 
      pdf = PDF::Stamper.new("sample.pdf") 
      pdf.text :first_name, "Jason"
      pdf.text :last_name, "Yates" 
      send_data(pdf.to_s, :filename => "output.pdf", :type => "application/pdf",:disposition => "inline")
    end   

## Installation

  gem install pdf-stamper

## Code


  git clone http://github.com/jaywhy/pdf-stamper/

## Contributors

Paul Schreiber
Joe Steele
Ronny Hanssen

## License

(The MIT License)

Copyright (c) 2007-2012 Jason Yates

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
