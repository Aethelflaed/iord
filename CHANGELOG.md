## 0.8.2
* Some code improvements on search

## 0.8 - Search
* Added search method module

## 0.7 - Sort
* Added sort methods for resource attributes

## 0.6 - Paginate
* Added paginate

## 0.5 - Hooks
* Added hooks for create / update / destroy methods

## 0.4.2
* Correctly handling form-oriented attributes validation

## 0.4.1
* Improved the request path, to calculate the route methods
* Using `params[:action]` and `params[:format]` to sanitize the request path
* Replaced `:label` by `:as` for form-oriented attributes 

## 0.4.0 - Defaults
* Added `Iord::Defaults`
* Added `before_set_resource` hook
* `Iord::Json` now works with `Iord::Nested`
* Added more customization in crud actions

## 0.3.0 - Nested resources
* Added module `Iord::Nested` to handle nested resources

## 0.2.0 - Singleton resource
* Correclty handling singleton resources
* Added `has_collection?` to handle correctly singleton resource.
* Added `form_resource_url`

## 0.1.1
* Added `json_show_attrs` and `json_index_attrs` to specialize attributes for
  json. These methods default to `show_attrs` and `index_attrs`.
* Fixed Iord::OutputHelper.image and its call in Iord::Field.
* Added key `:as` for display-oriented attributes to override the field name.
* Added `json_attrs` as shortcut for both `json_***_attrs` methods.
* Fixed hazardous value retrieving in field_name.

## 0.1.0 - JSON
* Added JSON support, can be enabled by including Iord::Json module.
* Fixed field name not humanized
* Fixed resource_actions methods

## 0.0.5
* Added id as permitted attribute by default

## 0.0.4
* Fixed error when adding a response format
* Completed the deletation to crud_response_format
* i18n flash
* Changed error display

## 0.0.3
* Fixed edit_resource_url returning always the same value
* Added Iord::HtmlHelper accessible via iordh to generate html

## 0.0.2
* Updated README with some information on the project.
* Prepending a `view_paths` when using Iord::GenericController.
  This permits to define a route like `resources :clients, controller: 'iord/generic'`
  and still customize views under `app/views/clients`.
* Remove usage of Mongoid constants to detect relation. Now based on attribute name
* Removed partial json handling. Will move this code to another gem someday
* Added i18n
* Added generators
* Fixed update CRUD method raising on validation error

## 0.0.1
* Initial release
