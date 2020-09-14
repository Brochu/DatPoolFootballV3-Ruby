# DatPoolFootballV3-Ruby
3rd and last try at a web application for the football pool of the Brochus
'
The goal is to write a Ruby on Rails application that will live on a custom Ubuntu Server machine and access data from a MongoDB Atlas cluster in the cloud.

We want to save a list of pools with active poolers. Each week of a NFL season, the poolers will have to pick the winners of every game this week. We then save these picks as a base64 string in the DB for this pooler, in this pool, for this week, of this season.