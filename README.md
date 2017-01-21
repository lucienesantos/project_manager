## Project Management
	
	This is a Rails REST API to help in projects management
	
### Endpoints

The API provides the following endpoints:

#### - GET /api/v1/projects

List of paginated projects

##### parameters:
* **page:** number of the page current
* **per_page:** number of projects per page

#### - POST /api/v1/projects

Creates a project

##### parameters:

* **name:** the name of the project
* **conclusion_at:** the deadline date of the project(expected format: yyyy/mm/dd)
* **client_id:** id of the client that project belongs to

#### - PUT/PATCH /api/v1/projects/:id

Updates the project by the given `id`

##### parameters:

* **name:** the name of the project
* **conclusion_at:** the deadline date of the project(expected format: yyyy/mm/dd)
* **client_id:** id of the client that project belongs to

#### - PATCH /api/v1/projects/:id/conclude

Updates the state to `concluded` of the project by the given `id`

#### - PATCH /api/v1/projects/archive

Updates the `archived` attribute to `true` and the `archived_at` of the project by the given `ids`
This works as a soft 

##### parameters:

* **ids:** id or ids of the project that might be archived

#### GET /api/v1/projects/:id/notes

List of paginated notes of the project

##### parameters:

* **id:** id of the project that the note belongs to
* **page:** number of the current page
* **per_page:** number of notes per page

#### - POST  /api/v1/projects/:id/notes

Creates a note for a specific project
If that notes should change the state of a project set `conclude_project`attribute for `true`

##### parameters:

* **project_id:** id of the project that the note belongs to
* **content:** the content text of the note
* **conclude_project:** if should conclude project

#### - PATCH /api/v1/projects/:id/notes/:note_id/archive

Updates the `archived` attribute to `true` and the `archived_at` of the note by the given `note_id`
This works as a soft deletion
