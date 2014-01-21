SeaBase
=======

SeaBase is a tool for searching, analysing and sharing gene expression 
data of marine organisms.

[![Continuous Integration Status][1]][2]
[![Coverage Status][3]][4]
[![CodePolice][5]][6]
[![Dependency Status][7]][8]


Install
-------

General requirements:

  - Ruby version 2.0 or higher
  - MySQL server version 5.1 or higher
  - Web Server for production (Nginx, or Apache)
  - Blast+ 

### Blast install on Ubuntu:

    sudo apt-get update
    sudo apt-get install ncbi-blast+


Running Tests
-------------

    bundle exec rake

Also look at [.travis.yml][9] file for more information


Copyright
---------

Code: [Nathan Wilson][10],[Dmitry Mozzherin][11] 

Copyright (c) 2014 [Marine Biological Laboratory][12]. See LICENSE[13] for
further details.

[1]: https://secure.travis-ci.org/EOL/seabase.png
[2]: http://travis-ci.org/EOL/seabase
[3]: https://coveralls.io/repos/EOL/seabase/badge.png?branch=master
[4]: https://coveralls.io/r/EOL/seabase?branch=master
[5]: https://codeclimate.com/github/EOL/seabase.png
[6]: https://codeclimate.com/github/EOL/seabase
[7]: https://gemnasium.com/EOL/seabase.png
[8]: https://gemnasium.com/EOL/seabase
[9]: https://github.com/EOL/seabase/blob/master/.travis.yml
[10]: https://github.com/nwilson-EOL
[11]: https://github.com/dimus
[12]: http://mbl.edu
[13]: https://github.com/EOL/seabase/blob/master/LICENSE
