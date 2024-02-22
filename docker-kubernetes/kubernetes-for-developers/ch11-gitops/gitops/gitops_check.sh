#! /bin/bash

# 
# If we name our folders the same as the namespace, then the check is simple: 
# if current namespace is equal to the folder name, deploy.
# 
# For these scripts to work though, you’ll need to ensure that none of your configuration files
# specify a metadata -> namespace field directly. If they have a namespace set, it will ignore
# the current context, so the above script won’t prevent updates in that case.
 
CURRENT_DIR=`echo "${PWD##*/}"`
CURRENT_NAMESPACE=`kubectl config view --minify -o=jsonpath='{.contexts[0].context.namespace}'`

if [ "$CURRENT_DIR" != "$CURRENT_NAMESPACE" ]; then
    >&2 echo "Wrong namespace (currently $CURRENT_NAMESPACE but" \
             "$CURRENT_DIR expected)"
    exit 1
fi

exit 0
