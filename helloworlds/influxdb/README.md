This document will explain how to get data from Influxdb

# Warning

All ips shown in this example are not updated, they are example ones.
Each time CogNet infrastructure is deployed different servers get new dynamic ips. There is an automatically updated list of those ips/hosts combination in [hosts](https://github.com/CogNet-5GPPP/demos_public/blob/master/hosts) file from demos_public repository.

# Background information

* influxdb user/password=root/root
* influxdb [api version 0.8](https://docs.influxdata.com/influxdb/v0.8/api/administration/)
* We use curl to make the calls


# Hello world example

We have written data into *monasca*, now we need to read it from *Influxdb*

First of all we need to get what series do we have stored in our *influxdb* database:

```
curl -G "http://<influxdb_ip>:8086/db/mon/series?u=root&p=root" --data-urlencode "q=list series" | python -c 'import sys, json; print json.load(sys.stdin)[0]["points"]'
```

response:

```
[[0, u'0fe69572168041f291814f7bc06672b2?mini-mon&cpu_load&server=server1'], [0, u'0fe69572168041f291814f7bc06672b2?mini-mon&cpu_load&server=server2']]
```

we can see that we have two series called `0fe69572168041f291814f7bc06672b2?mini-mon&cpu_load&server=server1` and  `0fe69572168041f291814f7bc06672b2?mini-mon&cpu_load&server=server2`

If we analyze their names we can check that `0fe69572168041f291814f7bc06672b2?mini-mon&cpu_load&server=server1` corresponds to the previous metrics we have made (cpu_load(metric) on server1(dimensions)).

We are going to extract those measures:


```
curl -G "http://<influxdb_ip>:8086/db/mon/series?u=root&p=root" --data-urlencode 'q=select * from "0fe69572168041f291814f7bc06672b2?mini-mon&cpu_load&server=server1"' | python -c 'import sys, json; print json.load(sys.stdin)[0]["points"]'
```

we get response:

```
[[1466497708, 60001, 15, u'{"measure_value":"percentage"}'], [1466497668, 40001, 25, u'{"measure_value":"percentage"}'], [1466497568, 50001, 17, u'{"measure_value":"percentage"}'], [1466497526, 30001, 15, u'{"measure_value":"percentage"}'], [1466492613, 20001, 12, u'{"measure_value":"percentage"}'], [1466427647, 10001, 12, u'{"measure_value":"percentage"}']]
```

That corresponds to

|  time |  sequence_number | value  | value_meta |
|---|---|---|---|
| 1466497708  |  60001 | 15  | {"measure_value":"percentage"} |
| 1466497668  | 40001  |  25 | {"measure_value":"percentage"}|
| 1466497568 | 50001  |  17 | {"measure_value":"percentage"}|
| 1466497526  |  30001 | 15  | {"measure_value":"percentage"}|
| 1466492613  | 20001  | 12  | {"measure_value":"percentage"}|
| 1466427647  | 10001  | 12  | {"measure_value":"percentage"}|

Those data correspond to the values we have entered previously.



