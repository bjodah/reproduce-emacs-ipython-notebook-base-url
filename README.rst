Launch a container with Emacs, EIN, and Jupyter Notebook 6.x
------------------------------------------------------------
This self-contained container environment was first meant to reproduce an issue with EIN,
but it turns out that things seem to be working just fine in a fresh environment with
recent versions of all depenencies. I'll keep this repo around for my own (and possibly others) future benefit.

This script required `podman <https://www.podman.org>`_

.. code-block:: shell-session

   $ ./run-in-container.sh

if you wish to access the notebook instance from outside the container, you may expose the port:

.. code-block:: shell-session

   $ ./run-in-container.sh -p 8888
