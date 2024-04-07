(wip)

- Install `nu_plugin_gstat`

    ```nushell
    cargo install nu_plugin_gstat
    let gstat = (which nu_plugin_gstat | get path | first); nu -c $'register '($plugin)'; version'
    ```

- Install Stylua

    ```nushell
    cargo install stylua
    ```
