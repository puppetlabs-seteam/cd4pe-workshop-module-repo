#!/bin/bash
if puppet config print server | grep -v -q `hostname`; then
  echo "This task can only be run on the PE master!"; 
  exit 1
fi

if [ $PT_filter == 'true' ]; then
  filter=" and facts { name = \"$PT_filter_fact\" and value = \"$PT_filter_factvalue\" }"
fi

if [ $PT_summarize == 'true' ]; then
    if [ -z $PT_factvalue ]; then
        echo "Executing the following query:"
        echo "puppet query \"facts[count(certname),value] { name = '$PT_factname'$filter group by value }\""
        /opt/puppetlabs/bin/puppet-query "facts[count(certname),value] { name = '$PT_factname'$filter group by value }"
    else
        echo "Executing the following query:"
        echo "puppet query \"facts[count(certname)] { name = '$PT_factname' and value = '$PT_factvalue'$filter group by value }\""
        /opt/puppetlabs/bin/puppet-query "facts[count(certname)] { name = '$PT_factname' and value = '$PT_factvalue'$filter group by value }"
    fi
else
    if [ -z $PT_factvalue ]; then
        echo "Executing the following query:"
        echo "puppet query \"facts[certname,value] { name = '$PT_factname'$filter }\""
        /opt/puppetlabs/bin/puppet-query "facts[certname,value] { name = '$PT_factname'$filter }"
    else
        echo "Executing the following query:"
        echo "puppet query \"facts[certname] { name = '$PT_factname' and value = '$PT_factvalue'$filter }\""
        /opt/puppetlabs/bin/puppet-query "facts[certname] { name = '$PT_factname' and value = '$PT_factvalue'$filter }"
    fi
fi