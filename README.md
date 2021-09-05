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
:heavy_check_mark: Create a decoupled bot that will call an API using the stock_code as a parameter
(https://stooq.com/q/l/?s=aapl.us&f=sd2t2ohlcv&h&e=csv, here aapl.us is the
stock_code) \
:heavy_check_mark: As a user, I must be able to upload a CSV file for processing. At the time of uploading the file, the user must choose which column belongs to which specific contact information, i.e. the user must match the columns of the file with the information to be processed and then save it into the database. This means that in the CSVs the columns with information will not be standard and may arrive in a different order or with different names than the ones that will be used in the database. \
:heavy_check_mark: The following values must be saved in the database:
[Name, Date of Birth, Phone, Address, Credit Card, Franchise, Email] \
:heavy_check_mark: As a system, I must process the content of the CSV file. The following validations must have the elements in the CSV file. \

### Completed all Bonus (Optional) Features
:heavy_check_mark: Have more than one chatroom. \
:heavy_check_mark: Handle messages that are not understood or any exceptions raised within the bot. \

### My Personal Bonus Features
+ Also i created a crud that is possible to register a new user in the page [http://127.0.0.1:8000/register/](http://127.0.0.1:8000/register/).
+ I used websocket services to create async system !
+ A logged user can create a new chat room in the page [http://127.0.0.1:8000/room/](http://127.0.0.1:8000/room/).
+ All routes are protected and just only loged users post comments and create a new chat room.
+ All project was developed using the kanban of github as shown in page [https://github.com/gbhgit/Chat-Django/projects/1](https://github.com/gbhgit/Chat-Django/projects/1)
