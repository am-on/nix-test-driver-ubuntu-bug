# Nix test-driver bug when running Ubuntu
When using `sudo` command in Ubuntu, the stderr is somehow processed by the test-driver which expects only base64 encoded stdout.

Running the following command in Ubuntu vm using [nix-vm-test](https://github.com/numtide/nix-vm-test):

```python
vm.execute("sudo bash -c \"echo 'Created foo → bar.\n' >&2 && echo 'foo' \"")
```

Results in  error message:
```
Traceback (most recent call last):
  File "/nix/store/0l539chjmcq5kdd43j6dgdjky4sjl7hl-python3-3.12.8/lib/python3.12/base64.py", line 37, in _bytes_from_decode_data
    return s.encode('ascii')
additionally exposed symbols:
           ^^^^^^^^^^^^^^^^^
UnicodeEncodeError: 'ascii' codec can't encode character '\u2192' in position 12: ordinal not in range(128)
During handling of the above exception, another exception occurred:
Traceback (most recent call last):
  File "/nix/store/ahpc056hlclhnv4qrdlfb525pk3shnxw-nixos-test-driver-1.1/bin/.nixos-test-driver-wrapped", line 9, in <module>
    sys.exit(main())
             ^^^^^^
  File "/nix/store/ahpc056hlclhnv4qrdlfb525pk3shnxw-nixos-test-driver-1.1/lib/python3.12/site-packages/test_driver/__init__.py", line 146, in main
    driver.run_tests()
  File "/nix/store/ahpc056hlclhnv4qrdlfb525pk3shnxw-nixos-test-driver-1.1/lib/python3.12/site-packages/test_driver/driver.py", line 174, in run_tests
    vm,
    self.test_script()
  File "/nix/store/ahpc056hlclhnv4qrdlfb525pk3shnxw-nixos-test-driver-1.1/lib/python3.12/site-packages/test_driver/driver.py", line 166, in test_script
    exec(self.tests, symbols, None)
  File "<string>", line 2, in <module>
  File "/nix/store/ahpc056hlclhnv4qrdlfb525pk3shnxw-nixos-test-driver-1.1/lib/python3.12/site-packages/test_driver/machine.py", line 588, in execute
    output = base64.b64decode(self._next_newline_closed_block_from_shell())
             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/nix/store/0l539chjmcq5kdd43j6dgdjky4sjl7hl-python3-3.12.8/lib/python3.12/base64.py", line 83, in b64decode
    s = _bytes_from_decode_data(s)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/nix/store/0l539chjmcq5kdd43j6dgdjky4sjl7hl-python3-3.12.8/lib/python3.12/base64.py", line 39, in _bytes_from_decode_data
    raise ValueError('string argument should contain only ASCII characters')
ValueError: string argument should contain only ASCII characters
    vlan1,
    start_all, test_script, machines, vlans, driver, log, os, create_machine, subtest, run_tests, join_all, retry, serial_stdout_off, serial_stdout_on, polling_condition, Machine
```

