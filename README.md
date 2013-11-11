# Floorplanner

Ruby interface working against floor planners API.

## TODO

As this is more or less a stub of the ruby API, only able to do a couple of things (read and update users)
I'm writing this list so I remember where to begin, if Inviso decides to go for floorplanner:


* Make a clean http client interface. #build_request is kinda there, but I don't like that methods in FinderMethods and Persistence is
  calling build_request directly.
* Fix init of records. Initialize is to be used creating new records and marking them as new_records, while #instantiate should be used internally
  after loading records and marking records as not new records.
* Make a simple schema definition, more or less only listing attributes which we can use for instance to generate read and write methods (see below).
* Use ActiveModel::AttributeMethods for read method and write method.
* Validations. Simply use ActiveModel validations and do some client side validation on records before #save.
* Floorplanner API supports search. We should too?
* Floorplanner API supports pagination. We should too?



## Installation

Add this line to your application's Gemfile:

    gem 'floorplanner'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install floorplanner

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
