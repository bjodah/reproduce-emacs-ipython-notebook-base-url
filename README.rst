Launch a container with Emacs, EIN, and Jupyter Notebook 6.x
------------------------------------------------------------
This self-contained container environment is meant to reproduce an issue in the interaction between emacs-ipython-notebook (EIN), and a notebook server running with a non-default base url and a user defined password. The other three combinations of specifying (or not) a base_url or password, seem to work just fine.

This script requires `podman <https://www.podman.org>`_

.. code-block:: shell-session

   $ ./run-in-container.sh

The script will prompt the user for:

    1. A password (beware, it is echoed to the screen), use this once emacs has launched.
    2. A base url

if you wish to access the notebook instance from outside the container, you may expose the port:

.. code-block:: shell-session

   $ ./run-in-container.sh -p 8888


Accessing the notebook using the browser works fine, it's only when using EIN issues arise. The error message printed in the jupyter server process log complains about unauthorized websocket connection:


.. code-block::

   [W 16:23:11.155 NotebookApp] Couldn't authenticate WebSocket connection
   [W 16:23:11.157 NotebookApp] 403 GET /bar/api/kernels/f1f305bb-e39d-4f15-aa46-9a727c464e27/channels?session_id=7ea0befd-1cd3-4d4b-b52c-2f7ccb4c0e41 (127.0.0.1) 3.850000ms referer=None
   
and the `*ein:log-all*` windows looks like:

.. code-block::

   16:23:10:539: [info] ein:websocket--prepare-cookies: no _xsrf among nil, retrying. @#<buffer  *ein: http://localhost:8888/bar/Untitled.ipynb*[python]>
   16:23:10:842: [info] ein:websocket--prepare-cookies: no _xsrf among nil, retrying. @#<buffer  *ein: http://localhost:8888/bar/Untitled.ipynb*[python]>
   16:23:11:157: [verbose] WS closed unexpectedly: ws://localhost:8888/bar/api/kernels/f1f305bb-e39d-4f15-aa46-9a727c464e27/channels?session_id=7ea0befd-1cd3-4d4b-\
   b52c-2f7ccb4c0e41 @#<buffer  *ein: http://localhost:8888/bar/Untitled.ipynb*[python]>
   16:23:11:160: [info] WS action [(websocket-received-error-http-response 403)] on-open (ws://localhost:8888/bar/api/kernels/f1f305bb-e39d-4f15-aa46-9a727c464e27/\
   channels?session_id=7ea0befd-1cd3-4d4b-b52c-2f7ccb4c0e41) @#<buffer  *ein: http://localhost:8888/bar/Untitled.ipynb*[python]>
   16:23:11:163: [verbose] WS opened: ws://localhost:8888/bar/api/kernels/f1f305bb-e39d-4f15-aa46-9a727c464e27/channels?session_id=7ea0befd-1cd3-4d4b-b52c-2f7ccb4c\
   0e41 @#<buffer  *ein: http://localhost:8888/bar/Untitled.ipynb*[python]>
   16:23:11:163: [info] WS action [(json-parse-error invalid token near 'OCTYPE' <string> 1 6 6)] on-message (ws://localhost:8888/bar/api/kernels/f1f305bb-e39d-4f1\
   5-aa46-9a727c464e27/channels?session_id=7ea0befd-1cd3-4d4b-b52c-2f7ccb4c0e41) @#<buffer  *ein: http://localhost:8888/bar/Untitled.ipynb*[python]>
   16:23:11:164: [info] WS action [(json-parse-error invalid token near 'ter' <string> 1 3 3)] on-message (ws://localhost:8888/bar/api/kernels/f1f305bb-e39d-4f15-a\
   a46-9a727c464e27/channels?session_id=7ea0befd-1cd3-4d4b-b52c-2f7ccb4c0e41) @#<buffer  *ein: http://localhost:8888/bar/Untitled.ipynb*[python]>
   
