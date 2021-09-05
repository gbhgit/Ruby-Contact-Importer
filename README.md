# Ruby Contact Importer
This application allow users to upload contact files in CSV format and process them in order
to generate a unified contact file. The contacts are associated to the user who imported
them into the platform. When uploading the files, the application validate the fields. 

### Recomendations
  - SQLite3
  - Ruby 2.5.8
  - Tested in Linux

### Installation and Deploy

		
## Considerations
### Completed all Mandatory Features
:heavy_check_mark: As a user, I must be able to log into the system using an email and a password. \
:heavy_check_mark: As a user, I must be able to register on the platform. For this, it will only be necessary to enter a username and password. \
:heavy_check_mark: As a user, I must be able to upload a CSV file for processing. At the time of uploading the file, the user must choose which column belongs to which specific contact information, i.e. the user must match the columns of the file with the information to be processed and then save it into the database. This means that in the CSVs the columns with information will not be standard and may arrive in a different order or with different names than the ones that will be used in the database. \
:heavy_check_mark: The following values must be saved in the database: Name, Date of Birth, Phone, Address, Credit Card, Franchise, Email. \
:heavy_check_mark: As a system, I must process the content of the CSV file. And some validations must have the elements in the CSV file. \
:heavy_check_mark: As a user, I should be able to see a summary of the contacts I have imported. All
contacts that I have imported and that were successfully created should be displayed in a list that is paginated. \
:heavy_check_mark: As a user, I should be able to see a log of the contacts that could not be imported and the error associated with it. \
:heavy_check_mark: As a user, I should be able to see a list of imported files with their respective status. Valid statuses include: On Hold, Processing, Failed, Terminated

### Bonus (Optional) Features
:heavy_check_mark: Process the CSV file in a background job. I used the gem 'sidekiq'.
