This file will show a hello world example to use with *apache kafka*

# Warning

All ips shown in this example are not updated, they are example ones.
Each time CogNet infrastructure is deployed different servers get new dynamic ips. There is an automatically updated list of those ips/hosts combination in [hosts](https://github.com/CogNet-5GPPP/demos_public/blob/master/hosts) file from demos_public repository.

# Background information

We have used [kafka-python](https://github.com/dpkp/kafka-python) library to make this hello world.

This library only admits hostnames as kafka server, no ip address is allowed. Kafka servers must be mapped on a dns address, if not user can modify it's */etc/hosts* file to map ip address to hostname manually:

```
192.168.1.100 mykafkahostname
```

Apache kafka server usually runs on port 9092.

We suppose that our client is running a Linux based computer.



# Hello world example

First step will be installing kafka-python library:

```
$ sudo pip install kafka-python
```


We define a hello-world-kafka.py file that contains:
    
```
    from kafka import KafkaConsumer
    
    # To consume latest messages and auto-commit offsets
    consumer = KafkaConsumer('metrics',
                             bootstrap_servers=['hostname:port'])
    for message in consumer:
        # message value and key are raw bytes -- decode if necessary!
        # e.g., for unicode: `message.value.decode('utf-8')`
        print ("%s:%d:%d: key=%s value=%s" % (message.topic, message.partition,
                                              message.offset, message.key,
                                              message.value))
    
``` 

## How it works


* Import *KafkaConsumer* class from *kafka* package
* Create a new consumer
  * We look for *metrics* topic from available topics from monasca(metrics, alarms, seguir buscando)
  * Set bootstrap_servers hostname:port (must be a hostname, ip address doesn't work, modify /etc/hosts file to "address" an ip to an host manually)
* Print the message receive each time we get a new one



# Testing Kafka Hello world

To check the correct working of this process we will push some data to monasca and we will listen kafka to retrieve them:


We use a monasca pushing script example *set_monasca_data.sh* to push some random data (from 1 to 100) as cpu_load from server1 to the monasca server. User just needs to change the url value to the appropriate ip address where monasca server is running.


If we launch `hello-world-kafka.py` we will be waiting for kafka to get some values.

Each time we execute `set_monasca_data.sh` we will get some data through `hello-world-kafka.py`:

```
metrics:1:2: key=b'dc06f486548c46ff99d81fa5a84c2d0ccpu_loadserverserver1' value=b'{"metric":{"name":"cpu_load","dimensions":{"server":"server1"},"timestamp":1470726231,"value":36.0,"value_meta":{"measure_value":"percentage"}},"meta":{"tenantId":"dc06f486548c46ff99d81fa5a84c2d0c","region":"mini-mon"},"creation_time":1470726231}'
```
