#!/usr/bin/python
# -*- coding: utf-8 -*-
""" can_reach ansible module """
from ansible.module_utils.basic import AnsibleModule

DOCUMENTATION = r'''
---
module: can_reach
short_description: Checks server reachability
description: Checks if a remote server can be reached

options:
  host:
    description:
      - A DNS hostname or IP address
    required: true
  port:
    description:
      - The TCP port number
    required: true
  timeout:
    description:
      - The amount of time trying to connect before giving up, in seconds
    required: false
    default: 3

requirements: [nmap]
author: Lorin Hochstein, Bas Meijer
notes:
  - This is just an example to demonstrate how to write a module.
  - You probably want to use the native M(wait_for) module instead.
'''

EXAMPLES = r'''
# Check that ssh is running, with the default timeout
- can_reach: host=localhost port=22 timeout=1

# Check if postgres is running, with a timeout
- can_reach: host=example.com port=5432
'''


def can_reach(module, host, port, timeout):
    """ can_reach is a method that does a tcp connect with nc """
    # Gets the path of an external program
    nc_path = module.get_bin_path('nc', required=True)
    args = [nc_path, "-z", "-v", "-w", str(timeout), host, str(port)]
    # (return_code, stdout, stderr) = module.run_command(args)
    # Invokes an external program
    return module.run_command(args, check_rc=True)


def main():
    """ ansible module that uses netcat to connect """
    module = AnsibleModule(  # Instantiates the AnsibleModule helper class
        argument_spec=dict(  # Specifies the permitted set of arguments
            host=dict(required=True),
            port=dict(required=True, type='int'),  # A required argument
            # An optional argument with a default value
            timeout=dict(required=False, type='int', default=3)
        ),
        supports_check_mode=True
        # Specifies that this module supports check mode
    )

    # In check mode, we take no action
    # Since this module never changes system state, we just
    # return changed=False
    if module.check_mode:  # Tests whether the module is running in check mode
        module.exit_json(changed=False)
        # Exits successfully, passing a return value
    # Once you’ve d""" e """clared an AnsibleModule object, you can access the
    # values of the arguments through the params dictionary, like this:
    host = module.params['host']
    port = module.params['port']
    timeout = module.params['timeout']

    if can_reach(module, host, port, timeout)[0] == 0:
        msg = "Could reach %s:%s" % (host, port)
        module.exit_json(changed=False, msg=msg)
        # Exits successfully, passing a message
    else:
        msg = "Could not reach %s:%s" % (host, port)
        module.fail_json(failed=True, msg=msg)
        # Exits with failure, passing an error message


if __name__ == "__main__":
    main()
