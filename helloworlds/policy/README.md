### Goals
[Top][]

This document will explain how to deploy a new policy to *CogNet infrastructure*

# Warning

All ips shown in this example are not updated, they are example ones.
Each time CogNet infrastructure is deployed different servers get new dynamic ips. There is an automatically updated list of those ips/hosts combination in [hosts](https://github.com/CogNet-5GPPP/demos_public/blob/master/hosts) file from demos_public repository.

## Navigation
[Goals][] | [Working steps][] | [Policy manager capabilities][] | [Policy definition][] | [topicName][] | [Event][] | [Condition][] | [Action][] | [Deployment][] | [Update policy][] | [Authors][] | [License][]



# Working steps

There are two steps in the deploying and the execution of a new policy

1. user pushes a new policy eca-supa definition to *newpolicy* *Kafka* topic.
2. user pushes eca-supa events to *topicName* *Kafka* topic



# Policy manager capabilities

* Policy Manager will be available to handle different topics.

* A topic will be available to handle different events.

* A event will be available to handle different conditions.


# Policy definition
A new policy will consist on a eca-supa JSON like element. 

Let's take *newpolicy.json* file as example:

```
{"supa-policy": {
    "supa-policy-validity-period": {
      "start": "2016-12-20T08:42:57.527404Z"
    },
    "supa-policy-target": {
      "domainName": "systemZ",
      "subNetwork": "192.168.1.1",
      "instanceName": ["devstack", "devstack2"],
      "topicName": "demo1"
    },
    "supa-policy-statement": {
      "event": {
        "event-name": "cpu_performance",
        "event-value-type": "int",
        "event-value": "10",
        "instanceName": ["compute1", "compute2"]

      },
      "condition": {
        "condition-name": "cpu_performance_high",
        "condition-operator": ">",
        "condition-threshold": "95"
      },
      "action": {
        "action-name": "deploy_new_machines",
        "action-host": "http://host.com/",
        "action-type": "deploy-topology",
        "action-param":[ {
          "param-type": "topology",
          "param-value": "ring",
          "instanceName": ["compute1", "compute2"]
        },{
          "param-type": "size",
          "param-value": "10",
          "instanceName": ["compute1", "compute2"]
        }]
      }
    }
  }
}
```



Here we can find the different parts of the *eca-supa* policy example:

The elements that concern us are:

* supa-policy-target->topicName
* supa-policy-statement->event
* supa-policy-statement->action
* supa-policy-statement->condition

## topicName

*topicName*: is the *Kafka* topic where *Policy Manager* will listen events to be evaluated.

We need to define a topicName to push desired data to this topic on Kafka:

topicName **MUST** be a lowercase - number combination [a-z][0-9] with no special characters.

## Event

The event that is going to be evaluated by *Policy Manager*

* *event-name*: is the element name we are going to evaluate. We will fill it with a descriptive name of the variable we are going to evaluate, "cpu_performance" for example.
* *event-value-type*: Only ints are supported now.We will write "int" here.
* *event-value*: Must be a number. Here we will put the value of the element.
* *instanceName*: Must be an array of 1 to n elements, it will be the name or names of the element (node) from insfrastructure where that event is happening, can be void. If present will be searched in the yang model to check with other nodes are linked to it.


## Condition

*condition-name*: will be the condition to comply to execute the action. We will need to fill it with a combination of the value of *event-name*. "cpu_performance_high" will be a good option.


As we are working with numeric conditions support the following operations:


* ==
* !=
* >
* <
* >=
* <=

We can write any of these conditions as value.

condition-threshold: The threshold that will be used to compare the *event-value* to decide if the *action* must be executed or not. Here we will write the value which will make the threshold to trigger.

## Action

The action that is going to be executed if the *event* comply with the condition.

* *action-name*: A descriptive name of the action, special chars allowed. A descriptive name for this action could be "deploy_new_machines".
* *action-host*: The hostname that will perform the action ordered by the *Policy manager*. "http://host.com" could be a good option to write here. If action-host is void, policy manager will redirect its output through kafka using the same topicName.
* *action-type*: A descriptive name for the type of the action. "deploy-topology" for example.
* *action-param*: JSON params to post to the *action-host*. We will fill this with our JSON params.
  * *InstanceName* can be filled in running time. It would be filled if it is defined as an array of n elements. There are two ways to be filled:
    * Hardcoded value
    * Multiple events input
    * Unique event input

  ### Action parameter variables

  #### Hardcoded value

  Nothing to evealuate here, the Policy Manager will push that value as is. A literal value or array (depending on the type of value) has to be filled in this position. 

  Please refer to [tutorial](https://github.com/CogNet-5GPPP/demos_public/tree/master/demos/Dockers/tutorial) to see a working example.


  #### Unique event input

  A variable will start with the symbol "$", it will indicate the name of the field of the event (in current execution) which will fill the action-param value, ie:

  ```$event-value``` will be substituted by the value of the field ```event-value```.

  Please refer to [tutorial with parameters](https://github.com/CogNet-5GPPP/demos_public/tree/master/demos/Dockers/tutorial_with_param) to see a working example.

  #### Multiple events input

  action-param variable will be indicated by two fields (begining with ```$``` symbol) begining with name of the field to be searched and followed by the name of the event to get the field from, ie:

  ```$instanceName$cpu_performance``` points to the field ```instanceName``` from the event which name is ```cpu_performance```.

  Please refer to [tutorial with multiple events and param variables](https://github.com/CogNet-5GPPP/demos_public/tree/master/demos/Dockers/tutorial_multiple_events_with_param_variables) to see a working example.

  An example of a multiple events, action-param with variables policy will be:

```
{"supa-policy": {
        "supa-policy-validity-period": {
            "start": "2016-12-20T08:42:57.527404Z"
        },
        "supa-policy-target": {
            "domainName": "systemZ",
            "subNetwork": "192.168.1.1",
            "instanceName": ["devstack", "devstack2"],
            "topicName": "demoX"
        },
        "supa-policy-statement": {
            "event": [{
                "event-name": "cpu_performance",
                "event-value-type": "int",
                "event-value": "10",
                "instanceName": ["compute1", "compute2"]
            },
            {
                "event-name": "disk_usage",
                "event-value-type": "int",
                "event-value": "10",
                "instanceName": ["compute1", "compute2"]
            }],
            "condition": {
                "condition-name": "cpu_performance_high",
                "condition-operator": ">",
                "condition-threshold": "95"
            },
            "action": {
                "action-name": "deploy_new_machines",
                "action-host": "http://host.com/",
                "action-type": "deploy-topology",
                "action-param":[ {
                    "param-type": "topology",
                    "param-value": "ring",
                    "instanceName": ["compute1", "compute2"]
                },{
                    "param-type": "size",
                    "param-value": "$event-value$cpu_performance",
                    "instanceName": ["$instanceName$cpu_performace"]
                }]
            }
        }
    }
} 
```


# Deployment

First step to create a new policy will be to push a message to *Kafka* machine to the *newpolicy* topic:

Let's se our example (create_new_policy.py):

```
from kafka import KafkaConsumer
from kafka import KafkaProducer
from kafka.errors import KafkaError
import json

# Read newpolicy.json
with open('newpolicy.json') as json_data:
    json_policy = json.load(json_data)

#Read topicName and conditionName from policy
topicName=json_policy['supa-policy']['supa-policy-target']['topicName']
conditionName=json_policy['supa-policy']['supa-policy-statement']['condition']['condition-name']

# To consume latest messages from metrics topic
groupId="%s%s"%(topicName,conditionName)
consumer = KafkaConsumer('metrics',bootstrap_servers=["localhost:9092"],group_id=groupId)

# To produce new messages to kafka
producer = KafkaProducer(bootstrap_servers=["localhost:9092"])


#Push new policy to Kafka
future = producer.send('newpolicy',json.dumps(json_policy))

# Receive messages from kafka metrics topic
for message in consumer:
                # do something with received messages
        #load each message as json data
        print("message")
        try:
            data = json.loads(message.value)

            #get type of metric of the message
            value_name=data['metric']['name']

            #check that that metric is the metric we need
            if value_name == "cpu.percent":

                #get metric value
                print("value")
                value_data=data['metric']['value']

                #set that value to the previous defined policy
                json_policy['supa-policy']['supa-policy-statement']['event']['event-value']=value_data

                #Send that policy as new measure to the listening topicName topic
                future = producer.send(topicName,json.dumps(json_policy))
            #else:
                #print("Not valid data")
        except ValueError:
            print "No valid data"
```

In this example we can see that we read *newpolicy.json* file and load it as a json element.

After that we create a new producer that connects to kafka server to a broker that is available at port 9092, it will be necessary to connect using an unique *groupid* per client to let all clients to listen messages from the same Kafka topic.

Final step will be sending the json newpolicy to the topic *newpolicy* where *Policy manager* will be listening for new incoming policies.


## Installation and dependencies 

This python example has *kafka-python* as pip dependency, to install it user just needs to execute

```
$sudo pip install kafka-python
```

To execute this example we will have to execute the following command:

```
$python create_new_policy.py
```


When we have made this action we will have to wait some minutes to let *Policy Manager* building a new policy client to listen for our data.

After this we can start pushing our data.

We have to give format our data in the same format as *newpolicy.json* file, so we will create a *data.json* file that will be like:


```
{"supa-policy": {
                "supa-policy-validity-period": {
                        "start": "2016-12-20T08:42:57.527404Z"
                },
                "supa-policy-target": {
                        "domainName": "systemZ",
                        "subNetwork": "192.168.1.1",
                        "instanceName": ["devstack", "devstack2"],
                        "topicName": "tutorial"
                },
                "supa-policy-statement": {
                        "event": {
                                "event-name": "cpu.system_perc",
                                "event-value-type": "float",
                                "event-value": "5.1",
                                "instanceName": ["openflow:1"]
                        },
                        "condition": {
                                "condition-name": "cpu.system_perc_high",
                                "condition-operator": ">",
                                "condition-threshold": "5.0"
                        },
                        "action": {
                                "action-name": "cpu.system_perc",
                                "action-host": "http://host.com",
                                "action-type": "deploy-topology",
                                "action-param":[ {
                                        "param-type": "topology",
                                        "param-value": "ring",
                                        "instanceName": ["<>"]
                                },{
                                        "param-type": "size",
                                        "param-value": "10",
                                        "instanceName": ["<>"]
                                }]
                        }
                }
        }
}
```

In this element we will have the measures we want to compare to execute the action. So *supa-policy-statement->event->event-value* will be the only element we will have to modify to add our measure.

After adding our measure we will push this data to kafka server using the **topicName** (demo1) of our *newpolicy* as kafka topic.

So, in example we will execute a python app like push_data.py:

```
from kafka import KafkaProducer
from kafka.errors import KafkaError
import json


with open('data.json') as json_data:
    data = json.load(json_data)



producer = KafkaProducer(bootstrap_servers=["kafka:9092"])

#send eca-supa sample
future = producer.send('demo1',json.dumps(data))

```

Please notice that **demo1** is the kafka topic where we are going to push data.

 and the topic that the newpolicy we had created before will be listening for new measures.
 
 ### Update policy

Policy Manager is capable of updating policies on demand. The system will rebuild policy with new requisites, stop former policy and start the updated one in an automatic way.

 The way to update a policy is:
 
 1. Modify policy definition
 2. Push new policy definition to *newpolicy* topic on Kafka
 3. Wait some minutes



 ### Authors
[Top][]

- Joe Tynan (jtynan@tssg.org)
- Angel Martin (amartin@vicomtech.org)

### License
[Top][]

Copyright 2016 WIT/TSSG.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0.

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

[Top]: #navigation
[Goals]: #goals
[Working steps]: #working-steps
[Policy manager capabilities]: #policy-manager-capabilities
[Policy definition]: #policy-definition
[topicName]: #topicname
[Event]: #event
[Condition]: #condition
[Action]: #action
[Deployment]: #deployment
[Update policy]: #update-policy
[Authors]: #authors
[License]: #license
