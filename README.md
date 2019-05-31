# Floorplanner

Ruby interface working against floor planners API.

[![Build Status](https://travis-ci.org/Skalar/floorplanner.svg?branch=master)](https://travis-ci.org/Skalar/floorplanner)

## Installation

Add this line to your application's Gemfile:

    gem 'floorplanner'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install floorplanner

## Usage

```Ruby
# Create a client for authenticated requests
client = Floorplanner::Client.new(api_key: 'yourkey', password: 'yourpwd', subdomain: 'skalar')

# Create a resource for Project API helper methods
resource = Floorplanner::Resources::ProjectsResource.new(client)

# Set up a project
new_project = Floorplanner::Models::Project.new(
  name: "My test project",
  description: "For demonstration purposes only",
  public: true
)

# Create the project in Floorplanner, returning a new Floorplanner::Models::Project
# instance with an id assigned by Floorplanner
created = resource.create(new_project)

# Render a 2D version of the project
resource.render_2d(created.id, callback: 'http://my.server.com/callback-handler', width: 2000, height: 1500, filetype: 'jpg')

# Check out lib/floorplanner/resources/projects_resource.rb for more helper methods.
# There is also Floorplanner::Resources::UsersResource with a helper method for
# creating authentication tokens for use in the embedded JavaScript/Flash editor.
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
