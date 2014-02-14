## 0.0.2
* Updated README with some information on the project.
* Prepending a view\_paths when using Iord::GenericController.
  This permits to define a route like `resources :clients, controller: 'iord/generic'`
  and still customize views under `app/views/clients`.
* Remove usage of Mongoid constants to detect relation. Now based on attribute name
* Removed partial json handling. Will move this code to another gem someday

## 0.0.1
* Initial release
