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

### required packatges on Ubuntu:

    sudo apt-get update
    sudo apt-get install mysql-server csh libqt4-dev


Running Tests
-------------

Javascript tests use capybara-webkit, which requires installation of
QT Webkit library, you can find installations instruction on
[capybara-webkit wiki][9]

    bundle exec rake db:migrate SEABASE_ENV=test
    bundle exec rake db:seed SEABASE_ENV=test
    bundle exec rake

Also look at [.travis.yml][10] file for more information


Copyright
---------

Code: [Nathan Wilson][11],[Dmitry Mozzherin][12]

Copyright (c) 2014 [Marine Biological Laboratory][13]. See [LICENSE][14] for
further details.

[1]: https://secure.travis-ci.org/EOL/seabase.png
[2]: http://travis-ci.org/EOL/seabase
[3]: https://coveralls.io/repos/EOL/seabase/badge.png?branch=master
[4]: https://coveralls.io/r/EOL/seabase?branch=master
[5]: https://codeclimate.com/github/EOL/seabase.png
[6]: https://codeclimate.com/github/EOL/seabase
[7]: https://gemnasium.com/EOL/seabase.png
[8]: https://gemnasium.com/EOL/seabase
[9]: http://goo.gl/BNFBZM
[10]: https://github.com/EOL/seabase/blob/master/.travis.yml
[11]: https://github.com/nwilson-EOL
[12]: https://github.com/dimus
[13]: http://mbl.edu
[14]: https://github.com/EOL/seabase/blob/master/LICENSE
