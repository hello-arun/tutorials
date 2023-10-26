# MONGODB

mongodb is a database management system which stores the data in key value pairs. Rather than inforcing a strict tabular structure it allows the flexibility in management. Let us discus first in brief how it work.

MONGODB is shipped with a database service `mongod` and a shell `mongosh`. Shell is used to basically to implment CRUD operations. `mongod` is the service that must run in the background which accept request from `mongosh` and implement them. 

`pymongo` allows us to implement these CRUD tasks through python langugae interface, rather than `mongosh`. 

## How to install

### Linux

First of all remove the previous installation of MONGODB if there are any. Not only the executables but also the log temp files everything should be remove for this installation to work properly. Till now I find that the installation thourgh the `apt` manager is the best way. 
The instuctions for the same are provided on MONGODB website.

* The default location of database store might be erased when system restarts, to avoid this you may choose the database storage path.
* To change the path first create the path and change the ownership to `mongodb` and also the group to `mongodb`
```bash
mkdir -p $dbPath
chown `mongodb:mongodb` $dbPath
```
* Changing the ownership is necessary for mongodb to work properly.
* Always run the process `mongod` with sudo access.