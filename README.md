[![CircleCI](https://circleci.com/gh/guillaumemaka/administrate-field-enum.svg?style=svg)](https://circleci.com/gh/guillaumemaka/administrate-field-enum)

# Administrate::Field::Enum

A plugin to show enum in [Administrate].

This repository is the first field plugin extracted out of Administrate.
Although its structure may change,
it's designed to act as a template for other Administrate field plugins.

## Installation

```
gem 'administrate-field-enum', git: "https://github.com/guillaumemaka/administrate-field-enum.git", branch: "master"
```

## Usage

In your dashboard ATTRIBUTES_TYPE
```
ATTRIBUTE_TYPES = {
  ...
  "status": Field:Enum
  ...
}
```

By default the plugin render radio buttons if the enum contains less than 4 enumerations, otherwise it render a select input box in forms and the text representation (titleized) for show and index page.

## Custom collection method

By default the plugin retrieve all the enum values by calling the mapping class method pluralize  attribute on your model object:

```
class Post < ActiveRecor::Base
  enum status: { submitted: 1, approved: 2, published: 3 }
end
```

In this exemple if we declared an attribute like this:

```
class PostDashboard
  ATTRIBUTE_TYPES = {
    "status": Field:Enum
  }
end
```

the plugin will call ```Post.statuses```, that will return a Hash. The Hash keys will be use as the text label (titleized) and as input value.

So if any circonstances you need to return a custom collection (usually you don't) you can pass the ```:collection_method``` option to the field this method will be called instead.

Your custom method collection method should return :

- A string/integer key/value Hash object
```
{ submitted: 1, approved: 2, published: 3 }
```
- An Array where each element is an Array with the first element correspond to the text label and the second to the value
```
[
    ['Submitted', 1],
    ['Approved', 1],
    ['Rejected', 1]
]
```

- An Array of Hash :
```
[
    { label: "Submitted", value: 1 },
    { label: "Approved", value: 2 },
    { label: "Rejected", value: 3 },
]
```
In that case you must pass ```label_key``` and ```value_key``` options to the options field :
```
class PostDashboard
  ATTRIBUTE_TYPES = {
    "status": Field:Enum.with_options(
      collection_method: :a_method,
      label_key: :label,
      value_key: :value)
  }
end
```

## FAQs

**Q: How should I name my gem?**

A: Administrate field gems must be named according to the [Rubygems naming guidelines].

Essentially, name your gem after the field class that it defines.
If there's a namespace in the class name, that gets translated to a dash (`-`) in the gem name.
If the class name is CamelCased, that translates to an underscore (`_`) in the gem name.

Since all administrate field gems are under the namespace `Administrate::Field`,
every field gem name should start with the prefix `administrate-field-`.

Here are some examples (these don't correspond to actual gems):

| Gem Name | Field Name |
|----------------------------|------------------------------|
| `administrate-field-enum` | `Administrate::Field::Enum` |
| `administrate-field-file_upload` | `Administrate::Field::FileUpload` |
| `administrate-field-geocoding-region` | `Administrate::Field::Geocoding::Region` |
| `administrate-field-geocoding-geo_json` | `Administrate::Field::Geocoding::GeoJson` |

[Rubygems naming guidelines]: http://guides.rubygems.org/name-your-gem/

[Administrate]: https://github.com/thoughtbot/administrate
