# Post Maker

This tool is intended to gather a set of merged pull requests from GitHub and
convert them into a *blog post*. It's in its early stages of development and
there's a lot of room for improvement, but it's somehow usable right now.

## Usage

*Post Maker* will retrieve pull requests which:

* belong to a determined user (`libyui` and `yast` by default),
* were merged in the a period
* and are tagged to be used in a post (`blog`).

For example:

    post_maker --format summary --lang html --output my-post.html

To get more information about available options, just use the `--help` switch:

    post_maker --help


## Authentication

At this time, the only supported authentication method is `netrc`. Just create a
`$HOME/.netrc` file like this:

	machine api.github.com
	  login <user>
	  password <password>
