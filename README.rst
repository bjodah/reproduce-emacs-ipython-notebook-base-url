Launch a container with Emacs, EIN, and Jupyter Notebook 6.x
------------------------------------------------------------
This self-contained container environment was meant to reproduce an issue in the interaction between emacs-ipython-notebook (EIN), and a notebook server running with a non-default base url and a user defined password.
The issue has since been resolved by @dickmao in `gh-835 <https://github.com/millejoh/emacs-ipython-notebook/issues/835>`_, and this repository has been updated to use the (as of writing) unreleased ein version with the fix.

.. code-block:: shell-session

   $ ./run-in-container.sh

The script will prompt the user for:

    1. A password (beware, it is echoed to the screen), use this once emacs has launched.
    2. A base url

