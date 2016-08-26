# InstallFest Guides

The Ruby on Rails Installfest is a fast paced, hands on journey through getting your first Ruby on Rails application up and running live on the Internet. Includes full setup of your development environment and step by step instructions on how to build your first app.
This repository contains all the guides used in the InstallFest and also some stretch follow-on guides that interested "students" can use to keep their Rails learning journey on track.

# Running a Local Server

Run the server with the following command:
`bundle exec middleman server`

This will start a local web server running at `http://localhost:4567/`

# Deploying the Website

Note you need to have proper aws credentials to do this.

1. Open your terminal application.
2. Change to your installfest_guide folder. eg: `cd dev/installfest`
3. Build the middleman files: `middleman build`
4. Deploy the website: `middleman s3_sync`

## Contributing

Spot an error? Had some issues following the guide? Raise an issue and we'll look into it. Alternatively submit a pull request and we'll get it merged ASAP.

## Sponsorship

The Ruby on Rails Installfest is a proud initiative from Australian Rails
development firm [reInteractive](http://reinteractive.net/).

## License

You're allowed to basically make use of the stuff here provided you give us some attribution. See the link below for a more legal specific description.

http://creativecommons.org/licenses/by/3.0/
