kinect_force
============

Move a particle system around with your hands

USAGE
-----

This is a processing sketch which listens to OSC messages send from
[OSCeleton](https://github.com/Sensebloom/OSCeleton). You will need to
setup your kinect to send skeleton data. More info on how to do that here:
[http://skyra.github.io/blog/Kinect-Processing/](http://skyra.github.io/blog/Kinect-Processing/)

Once you have that set up, start osceleton on port 12345

    ./osceleton -p 123451

DEPENDENCIES
------------

* [OSCeleton](https://github.com/Sensebloom/OSCeleton)
* [OSCeletonWrapper](https://github.com/cketcham/OSCeletonWrapper)

CONTRIBUTE
----------

If you would like to contribute code to kinect_force you can do so through
GitHub by forking the repository and sending a pull request.

You may [file an issue](https://github.com/cketcham/kinect_force/issues/new)
if you find bugs or would like to add a new feature.


DEVELOPED BY
------------

* Cameron Ketcham - [http://skyra.github.io](http://skyra.github.io)
