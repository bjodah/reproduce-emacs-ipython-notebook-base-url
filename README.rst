Launch a container with Emacs, EIN, and Jupyter Notebook 6.x
------------------------------------------------------------

This script required `podman <https://www.podman.org>`_

.. code: shell-session

   $ ./run-in-container.sh

if you wish to access the notebook instance from outside the container, you may expose the port:

.. code: shell-session

   $ ./run-in-container.sh -p 8888
