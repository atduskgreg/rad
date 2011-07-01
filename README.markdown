# Welcome to RAD (Ruby Arduino Development)

RAD is a framework for programming the Arduino physcial computing platform using Ruby. RAD converts Ruby scripts written using a set of Rails-like conventions and helpers into C source code which can be compiled and run on the Arduino microcontroller. It also provides a set of Rake tasks for automating the compilation and upload process.

For a full introduction see http://rad.rubyforge.org

## Documentation

The main documentation is here: ArduinoSketch.

See also the Arduino Software reference: http://www.arduino.cc/en/Reference/HomePage

## Examples

See the examples directory for lots of examples of RAD in action: 
http://github.com/atduskgreg/rad/tree/master/lib/examples

The atduskgreg/rad wiki also contains a growing library of examples and hardware tutorials:
http://github.com/atduskgreg/rad/wikis

## Getting Started

To install the gem:

    $ gem install rad

Run the rad command to create a new project:

    $ rad my_project

Write a sketch that will blink a single LED every 500ms:

```ruby
class MyProject < ArduinoSketch
  output_pin 13, :as => led
  def loop
    blink led, 500
  end
end
```

Attach your Arduino and use rake to complile and upload your sketch:

    $ rake make:upload

##Installing the Arduino Software

Installing RAD and the Arduino software on Linux can be a little more difficult than on OS X. Thankfully, the RAD command line tool can help. Run:

    $ rad install arduino

And RAD will do its best to get the Arduino software installed on your system.

#Get Involved

##Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix on a new topic branch
* Add specs and cukes for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Issue a pull request.

##Cheers?  Jeers?  Questions?  Comments?  

Contact Greg Borenstein - greg [dot] borenstein [at] gmail [dot] com

Matthew Williams - matthew [dot] williams [at] gmail [dot] com

Also, please don't hesitate to submit issues!