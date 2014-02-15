# IORD

IORD is a runtime scaffolding system based on an easy way to represent data.

## Description

IORD stands for *Information Oriented Representation of Data*.

It can be used to easily create customizable CRUD based controllers and scaffolds views automatically.
IORD also handles strong parameters verification based on the given data.

## Installation

Add iord to your Gemfile:

```ruby
gem 'iord'
```

And run `bundle install` within your app's directory.

## Getting Started

### Quick method

The easiest way to use IORD is to define a route with the `iord/generic` controller:

```ruby
# config/routes.rb
resources :products, controller: 'iord/generic'
```

This will automatically handles the CRUD methods and display the data from the `Product`.

The attributes displayed will be the model's attributes except `deleted_at` on all views
and `_id`, `created_at`, `updated_at` on index, new and edit.

You can still customize the views by creating the corresponding file in `app/views/products/`.

#### Namespaced resources

For namespaced resources, use the following syntax:

```ruby
namespace :admin, module: nil do
  resource :products, controller: 'iord/generic'
end
namespace :admin do
  # normal admin scoped routes, which controllers will be in module Admin
end
```

The model used in this case is still `::Product`.

### Customizable method

You can also create your own route pointing to your controller, for example:

```ruby
# config/routes.rb
resources :products

# app/controllers/products_controller.rb
require 'iord/controller'

class ProductsController < ApplicationController
  include Iord::Controller
end
```

You can then override the actions, change the displayed attributes, ...

Views will be loaded from the corresponding views directory and default to IORD views.

#### Namespaced resources

For namespaced routes, you don't have to specify `module: nil` as for the quick method,
and the model used will still be `::Product`.

## Documentation

This documentation provides customization informations which are mainly available if you
use your own controller.

### Attributes

IORD defines a lot of helper method to retrieve which attributes to display:

```ruby
show_attrs      # used for `show` action
                # defaults to resource_class.attribute_names.map{|i| i.to_sym} - %i(deleted_at)
index_attrs     # used for `index` action
                # defaults to `attrs`
new_attrs       # used for `new` and `create` action
                # defaults to `form_attrs`
edit_attrs      # used for `edit` and `update` action
                # defaults to `form_attrs`
form_attrs      # defaults to `attrs`
attrs           # defaults to `show_attrs` - %i(_id created_at updated_at)
```

IORD's attributes are used to generate the views and the parameters requirements / permissions.

The default and basic attributes methods return and array of symbols corresponding directly to the
model's attributes.

For more complex cases, there are two kinds of data expected:
* display-oriented attributes for `show_attrs` and `index_attrs`.
* form-oriented attributes for `new_attrs` and `edit_attrs`.

Both complex cases attributes are fully recursive, meaning you can have nested objects.

#### Display oriented attributes

Display oriented attributes are either symbols or hashes.

Symbols are directly sent to the resource and the corresponding value is used. The name displayed for
the attribute will be a humanized version of itself.

Hashes permits more complex structures based on the presence of a specific key. The value used depends on
the first keys encountered given this order:

* `:array` will display an array of attributes, typically an has_many relation.

  It will list each element inside an `ul` and display them as if they had the `:object` key
  with the attributes in the `:attr` field.

  The name of the attribute will be a humanized version of the value of `:array`

* `:object` expects the hash to also have the `:attrs` key mapped to an array of
  display oriented attributes.

  It will use the same logic as the action but will display the values of the object
  it get by calling the value of `:object` on the resource.

  The name of the attribute will be a humanized version of the value of `:object`

* `:value` is a fully customizable attribute which value will be used as the name
  of the attribute.

  The value of the attribute is computed using the `:format` mapped value which should be
  a `Proc`.
  
  Depending on the current resource to respond to the `:value` mapped value, the proc
  will either receive the corresponding value or the resource and the `:value` mapped value.

* `:image` will display the image at the url returned by the resource when calling `:image`
  mapped value.

* `:link` will display a link to the url returned by the resource when calling `:link`
  mapeed value.

* In any other case, it calls itself recursively by replacing the current resource by
  the value returned by the resource when calling the method named after the first key,
  and the attributes by the value of the first key.

  The name of the attribute will be a humanized version of the first key.

  In other words, in the products controller, to following code displays the
  value `category.to_s` labelled `Category`:

		```ruby
		  {category: :to_s}
		```

#### Form oriented attributes

Form oriented attributes are either symbols, arrays or hashes.

Symbols are displayed using `f.text_field` for the input, and `f.label` for the label.

Arrays are displayed using `f.public_send *attr` for the input, and `f.label attr[1]` for the label.

Example:
```ruby
def form_attrs
  [
    :name,
    [:select, :category_id, Category.all.collect{|c| [c.name, c.id]}]
  ]
end
```
This will display a form with a text field labelled *Name* and a select labelled `Category`.

Hashes permits more complex structures based on the presence of a specific key.
The label will have either the value of the `:attr` key humanized, or the value of the `:label` key,
if present. Lastly, if the array has the key `:hidden`, then no label is displayed.

The value used depends on the first keys encountered given this order:

* `:fields` will trigger a nested form (using the NestedForm gem), for the object referenced
  by the attribute mapped by `:attr`.

  The `:fields` is mapped to an array of form oriented attributes.

  It will display either one or many objects depending on the kind of relation. When displaying
  many objects, it will also add the `Add a ...` and `Remove this ...` links.

  When displaying many objects, you can add the key `:not_new_record` to prevent it
  from being displayed on new objects (usefull for `id` for example).

* `:field`, which type is check:
  - when Array, uses `f.public_send `*attr[:field]`.
    
	This is quite similar to directly giving an Array, but permits to change the label.

  - when Hash, calls the controller method in field `attr[:field][:helper][0]`
    The `:helper` sub-key should be an array.
    
	The method should accept at least 2 arguments:
	- the form object (from `form_for` or `fields_for`)
	- the current attr Hash
	- any other parameters provided (`attr[:field][:helper][1..-1]`)

### Accessing the instances

IORD uses `@resource` to store a model instance and `@collection` to store the collection.

The `@resource` is initialized only in resource-based actions and not in collection-based actions
such as index.

You can add a resource-based action using the following class methods:

```ruby
# app/controllers/products_controller.rb
require 'iord/controller'

class ProductsController < ApplicationController
  include Iord::Controller

  resource_actions :inc_qty
  # or
  resource_actions :inc_qty, :dec_qty
  # or
  resource_actions [:inc_qty, :dec_qty]

  # to replace any existing actions:
  resource_actions! :show, :destroy
end
```

### URL helpers

IORD defines several URL helpers:

```ruby
collection_url
new_resource_url
resource_url(resource = nil)
edit_resource_url(resource = nil)
```

### Model's namespace

You can set the model's namespace using the following class methods:

```ruby
# app/controllers/products_controller.rb
require 'iord/controller'

class ProductsController < ApplicationController
  include Iord::Controller

  set_resource_namespace Subsidiary
  # or the other syntax this one is aliased to:
  self.resource_namespace = Subsidiary
end
```
The model loaded will now be `Subsidiary::Product`.

### Resource information

You can query information on the resource using the following controller helper methods:

* `resource_class`, complete model class constant
* `resource_name`, humanized version of the model class name
* `resource_name_u`, underscore version of the model class name
* `collection_name`, humanized version of the collection name (plural of `resource_name`)
* `resource_path`, array of the modules as Symbol in which the model is nested
* `action_path`, path used to access the controller, used by url helpers.

### Add a response format

You can add a response format with the following class method:

```ruby
# app/controllers/products_controller.rb
require 'iord/controller'

class ProductsController < ApplicationController
  include Iord::Controller

  crud_response_format do |instance, format, action|
    case action
	when :index
	  format.json { instance.render json: @resource_class.all }
    end
  end
end
```

## License

This project rocks and uses MIT-LICENSE.

Copyright 2014 Geoffroy Planquart

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
