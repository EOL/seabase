Seabase cosine similarity calculation
=====================================

Usage
-----

* Download and set classpath for [mysql jdbc driver][1]

    Classpath can be changed in either /etc/environment, .bashrc, .bash_profile 

    export CLASSPATH=$CLASSPATH:path/to/mysql...jar

    source ~/.bashrc # or whatever has modified CLASSPATH

* Compile 

    javac CosineCalc.java

* Execute
 
    java CosineCalc

* Use result from java/similarities.tsv
