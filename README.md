# Bootstrap

This gem provides helpers for easy creating sites with [Twitter Bootstrap 3](http://getbootstrap.com) framework.

> **Warning!** This gem is in active development state. Please, don't use it in production.

# Installation

put following line in you `Gemfile`

```ruby
gem 'bootstrap', github: 'cybernetlab/bootstrap'
```

and run

```sh
bundle install
```

# Configuration


# Usage

## Common guidelines

### Flags and enumerations arguments

All helpers supports Bootstrap flags and enumerations, passed as symbols. For example, following code

```ruby
button :large, :success, 'Text'
```

produces HTML:

```html
<button type="button" class="btn btn-success btn-lg">Text</button>
```

Order of flags irrelevant, but all flags and enumerations should be **symbols**. Only supported flags allowed, so refer to [Bootstrap documentation](getbootstrap.com/css) or read corresponding chapter of this document for valid values.

### Capturing tags

Not all helpers produces HTML, but it's recommended to always use capturing tags `<%= >` instead of `<% >` form.

## Components

### Grid system