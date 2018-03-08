This document will show how to use *monasca* and will show a fully working example.
# Warning

All ips shown in this example are not updated, they are example ones.
Each time CogNet infrastructure is deployed different servers get new dynamic ips. There is an automatically updated list of those ips/hosts combination in [hosts](https://github.com/CogNet-5GPPP/demos_public/blob/master/hosts) file from demos_public repository.

# Background information

* OS_AUTH_TOKEN from keystone server is ADMIN (from /etc/keystone.conf file)
* monasca and keystone are in the same machine 
* mon-api password is "password"
* We use curl to make the calls to the API

## Architecture

There is some architecture information to be known before starting this section:

[Monasca](https://wiki.openstack.org/wiki/Monasca) is an open-source monitoring-as-a-service solution that integrates with OpenStack. It uses a REST API for high-speed metrics processing and querying and has a streaming alarm engine and notification engine. 

It uses [keystone](http://docs.openstack.org/developer/keystone/) for it's authentication, so, to write a metric to *monasca* user must follow two steps:

1. Get authentication token from *keystone*
2. Post a metric to *monasca*


# Hello world example

## Get authentication token from keystone

We need to get an authentication token from keystone server, this authentication token must be get for user *mon-api* which is the user authorized from *keystone* to write and read changes from *monasca*:

```
curl -X POST http://<monasca_ip>:5000/v2.0/tokens -d '{"auth":{"tenantName":"mini-mon","passwordCredentials":{"username": "mini-mon", "password":"password"}}}' -H "Content-type: application/json" -H "X-Auth-Token: ADMIN" | python -mjson.tool
```
After this we get an auth token (bc3f0d53c47b41f69ada91ee8c9ef646) that we can use to put some data in monasca:

```
curl -i -X POST -H "X-Auth-Token: bc3f0d53c47b41f69ada91ee8c9ef646" -H 'Content-Type: application/json' -H 'Cache-Control: no-cache' http://<monasca_ip>::8080/v2.0/metrics -d '{"name":"cpu_load","timestamp":"1466427647","dimensions":{"server":"server1"},"value":12.0,"value_meta":{"measure_value":"percentage"}}'
```



# How does it work

We look for an auth token by :

```
curl -X POST http://<monasca_ip>:4:5000/v2.0/tokens -d '{"auth":{"tenantName":"mini-mon","passwordCredentials":{"username": "mini-mon", "password":"password"}}}' -H "Content-type: application/json" -H "X-Auth-Token: ADMIN" | python -mjson.tool
```


we get the following response:

```
{
    "access": {
        "metadata": {
            "is_admin": 0,
            "roles": [
                "423af08cd50347189a34eebef4854475",
                "9fe2ff9ee4384b1894a90878d3e92bab"
            ]
        },
        "serviceCatalog": [
            {
                "endpoints": [
                    {
                        "adminURL": "http://localhost:8774/v2/0fe69572168041f291814f7bc06672b2",
                        "id": "2c7bf89a7ae44c889b5415ccf3bcd2dd",
                        "internalURL": "http://localhost:8774/v2/0fe69572168041f291814f7bc06672b2",
                        "publicURL": "http://localhost:8774/v2/0fe69572168041f291814f7bc06672b2",
                        "region": "RegionOne"
                    }
                ],
                "endpoints_links": [],
                "name": "nova",
                "type": "compute"
            },
            {
                "endpoints": [
                    {
                        "adminURL": "http://localhost:8774/v2.1/0fe69572168041f291814f7bc06672b2",
                        "id": "5d6e285522864f65b0ed20e8f01c5480",
                        "internalURL": "http://localhost:8774/v2.1/0fe69572168041f291814f7bc06672b2",
                        "publicURL": "http://localhost:8774/v2.1/0fe69572168041f291814f7bc06672b2",
                        "region": "RegionOne"
                    }
                ],
                "endpoints_links": [],
                "name": "novav21",
                "type": "computev21"
            },
            {
                "endpoints": [
                    {
                        "adminURL": "http://localhost:8776/v2/0fe69572168041f291814f7bc06672b2",
                        "id": "1f415d68b03c40cd8f320a87288254ab",
                        "internalURL": "http://localhost:8776/v2/0fe69572168041f291814f7bc06672b2",
                        "publicURL": "http://localhost:8776/v2/0fe69572168041f291814f7bc06672b2",
                        "region": "RegionOne"
                    }
                ],
                "endpoints_links": [],
                "name": "cinderv2",
                "type": "volumev2"
            },
            {
                "endpoints": [
                    {
                        "adminURL": "http://localhost:8777/",
                        "id": "b53d9cdd00e8426d832eda55a55a3ec1",
                        "internalURL": "http://localhost:8777/",
                        "publicURL": "http://localhost:8777/",
                        "region": "RegionOne"
                    }
                ],
                "endpoints_links": [],
                "name": "novav3",
                "type": "computev3"
            },
            {
                "endpoints": [
                    {
                        "adminURL": "http://localhost:9292",
                        "id": "e5665abfd9294df4ad7567a5ab266d24",
                        "internalURL": "http://localhost:9292",
                        "publicURL": "http://localhost:9292",
                        "region": "RegionOne"
                    }
                ],
                "endpoints_links": [],
                "name": "glance",
                "type": "image"
            },
            {
                "endpoints": [
                    {
                        "adminURL": "http://localhost:8000/v1",
                        "id": "9388826975114e609ad14a708e69a10a",
                        "internalURL": "http://localhost:8000/v1",
                        "publicURL": "http://localhost:8000/v1",
                        "region": "RegionOne"
                    }
                ],
                "endpoints_links": [],
                "name": "heat-cfn",
                "type": "cloudformation"
            },
            {
                "endpoints": [
                    {
                        "adminURL": "http://localhost:8776/v1/0fe69572168041f291814f7bc06672b2",
                        "id": "ce6cf85b37ea4701a6c250969c240630",
                        "internalURL": "http://localhost:8776/v1/0fe69572168041f291814f7bc06672b2",
                        "publicURL": "http://localhost:8776/v1/0fe69572168041f291814f7bc06672b2",
                        "region": "RegionOne"
                    }
                ],
                "endpoints_links": [],
                "name": "cinder",
                "type": "volume"
            },
            {
                "endpoints": [
                    {
                        "adminURL": "http://localhost:8004/v1/0fe69572168041f291814f7bc06672b2",
                        "id": "3bd88b92c21246beb45813d2cea7d097",
                        "internalURL": "http://localhost:8004/v1/0fe69572168041f291814f7bc06672b2",
                        "publicURL": "http://localhost:8004/v1/0fe69572168041f291814f7bc06672b2",
                        "region": "RegionOne"
                    }
                ],
                "endpoints_links": [],
                "name": "heat",
                "type": "orchestration"
            },
            {
                "endpoints": [
                    {
                        "adminURL": "http://172.17.0.10:8080/v2.0",
                        "id": "bc6e136fcf454cc48f1a9324b2c46abf",
                        "internalURL": "http://172.17.0.10:8080/v2.0",
                        "publicURL": "http://172.17.0.10:8080/v2.0",
                        "region": "RegionOne"
                    }
                ],
                "endpoints_links": [],
                "name": "monasca",
                "type": "monitoring"
            },
            {
                "endpoints": [
                    {
                        "adminURL": "http://127.0.0.1:5000/v2.0",
                        "id": "fa3aeae8412e4a53a551b0141e816086",
                        "internalURL": "http://127.0.0.1:5000/v2.0",
                        "publicURL": "http://127.0.0.1:5000/v2.0",
                        "region": "RegionOne"
                    }
                ],
                "endpoints_links": [],
                "name": "keystone",
                "type": "identity"
            }
        ],
        "token": {
            "audit_ids": [
                "ji9SBxyyQYy7o-pQOw_dog"
            ],
            "expires": "2016-06-21T07:56:40Z",
            "id": "bc3f0d53c47b41f69ada91ee8c9ef646",
            "issued_at": "2016-06-21T06:56:40.732873",
            "tenant": {
                "description": null,
                "enabled": true,
                "id": "0fe69572168041f291814f7bc06672b2",
                "name": "mini-mon"
            }
        },
        "user": {
            "id": "c62fbb55b04441ab9365eb4bd4322dc2",
            "name": "mini-mon",
            "roles": [
                {
                    "name": "monasca-user"
                },
                {
                    "name": "_member_"
                }
            ],
            "roles_links": [],
            "username": "mini-mon"
        }
    }
}
```
The interesting part for us is the one that contains the token:

```
        "token": {
            "audit_ids": [
                "ji9SBxyyQYy7o-pQOw_dog"
            ],
            "expires": "2016-06-21T07:56:40Z",
            "id": "bc3f0d53c47b41f69ada91ee8c9ef646",
            "issued_at": "2016-06-21T06:56:40.732873",
            "tenant": {
                "description": null,
                "enabled": true,
                "id": "0fe69572168041f291814f7bc06672b2",
                "name": "mini-mon"
            }
        },
```

The token that we need is the corresponding to "id" field, so, our token is:

`bc3f0d53c47b41f69ada91ee8c9ef646`

## Post a metric to *monasca*

We have our authorization token and we want to send a metric to monasca that measures cpu_load in server1 with a value of 12% and value is measured in percentage. To create this metric we stablish:


|  metric |  dimensions (can be an array) | value  | value_meta (can be an array) |
|--- | --- | --- | --- |
| cpu_load  |  "server":"server1" | 12.0  | "measure_value":"percentage"|

We can set any metric and any pair (or array of them) of dimensions or value_meta.


```
curl -i -X POST -H "X-Auth-Token: bc3f0d53c47b41f69ada91ee8c9ef646" -H 'Content-Type: application/json' -H 'Cache-Control: no-cache' http://<monasca_ip>::8080/v2.0/metrics -d '{"name":"cpu_load","timestamp":"1466427647","dimensions":{"server":"server1"},"value":12.0,"value_meta":{"measure_value":"percentage"}}'
```

that returns:

```
HTTP/1.1 204 No Content
Date: Tue, 21 Jun 2016 07:02:42 GMT
```

Timestamp is [epoch time](http://www.epochconverter.com/), in Linux/Unix machines we can get it with command `date '+%s'`

# Automatic script

There is an attached an example script called *set_data_monasca.sh* that makes this operation on a transparent way, it is only needed to set-up the url field with the appropriate hostname or ip where monasca and keystone are running and the data to be filled.


# Extra information about keystone

We can check available users in keystone:


```
curl -s  -H "X-Auth-Token: ADMIN"  http://<keystone_ip>::5000/v3/users | python -mjson.tool
```

we have 

```
{
    "links": {
        "next": null,
        "previous": null,
        "self": "http://<keystone_ip>::5000/v3/users"
    },
    "users": [
        {
            "default_project_id": "57a700bb731e4514b21ca2e905db677a",
            "domain_id": "default",
            "email": null,
            "enabled": true,
            "id": "ba428853a0ef46a3ab5d6a7f2b0532b7",
            "links": {
                "self": "http://<keystone_ip>:5000/v3/users/ba428853a0ef46a3ab5d6a7f2b0532b7"
            },
            "name": "admin"
        },
        {
            "default_project_id": "b259f6c3b4fd4edca99b13527983ac81",
            "domain_id": "default",
            "email": null,
            "enabled": true,
            "id": "197024158095455bb7da1eb127793e33",
            "links": {
                "self": "http://<keystone_ip>:5000/v3/users/197024158095455bb7da1eb127793e33"
            },
            "name": "nova"
        },
        {
            "default_project_id": "b259f6c3b4fd4edca99b13527983ac81",
            "domain_id": "default",
            "email": null,
            "enabled": true,
            "id": "31f7fd5c1e694a2994448c7c68e887a8",
            "links": {
                "self": "http://<keystone_ip>:5000/v3/users/31f7fd5c1e694a2994448c7c68e887a8"
            },
            "name": "glance"
        },
        {
            "default_project_id": "b259f6c3b4fd4edca99b13527983ac81",
            "domain_id": "default",
            "email": null,
            "enabled": true,
            "id": "dd0be8d535b64f4ea5e3361d55aa43f4",
            "links": {
                "self": "http://<keystone_ip>:5000/v3/users/dd0be8d535b64f4ea5e3361d55aa43f4"
            },
            "name": "cinder"
        },
        {
            "default_project_id": "d20876f459f4455baddbd35db29eb526",
            "domain_id": "default",
            "email": null,
            "enabled": true,
            "id": "55a3f66641a94781b323296a8b6a01af",
            "links": {
                "self": "http://<keystone_ip>:5000/v3/users/55a3f66641a94781b323296a8b6a01af"
            },
            "name": "mini-mon"
        },
        {
            "default_project_id": "d20876f459f4455baddbd35db29eb526",
            "domain_id": "default",
            "email": null,
            "enabled": true,
            "id": "86cffc370bca457fa886fe7fa8c4cbb1",
            "links": {
                "self": "http://<keystone_ip>:5000/v3/users/86cffc370bca457fa886fe7fa8c4cbb1"
            },
            "name": "monasca-agent"
        }
    ]
}
```

We have the following users:
* admin
* nova
* glance
* cinder 
* mini-mon
* monasca-agent

If we check available tenants:

```
curl -s  -H "X-Auth-Token: ADMIN"  http://<keystone_ip>:35357/v2.0/tenants | python -mjson.tool
{
    "tenants": [
        {
            "description": null,
            "enabled": true,
            "id": "57a700bb731e4514b21ca2e905db677a",
            "name": "admin"
        },
        {
            "description": null,
            "enabled": true,
            "id": "d20876f459f4455baddbd35db29eb526",
            "name": "mini-mon"
        },
        {
            "description": null,
            "enabled": true,
            "id": "b259f6c3b4fd4edca99b13527983ac81",
            "name": "service"
        }
    ],
    "tenants_links": []
}
```

We have checked other tenants but *mini-mon* seems to be the one that has communication with monasca, other ones seem to be internal for keystone server.

If we check *mini-mo* tennant available users we get:

```
curl -s  -H "X-Auth-Token: ADMIN"  http://<keystone_ip>:35357/v2.0/tenants/d20876f459f4455baddbd35db29eb526/users | python -mjson.tool
{
    "users": [
        {
            "email": null,
            "enabled": true,
            "id": "55a3f66641a94781b323296a8b6a01af",
            "name": "mini-mon",
            "tenantId": "d20876f459f4455baddbd35db29eb526",
            "username": "mini-mon"
        },
        {
            "email": null,
            "enabled": true,
            "id": "86cffc370bca457fa886fe7fa8c4cbb1",
            "name": "monasca-agent",
            "tenantId": "d20876f459f4455baddbd35db29eb526",
            "username": "monasca-agent"
        }
    ]
}
```
So we have *monasca-agent* and *mini-mon* as authored users.

checking their roles:

```
curl -s  -H "X-Auth-Token: ADMIN"  http://<keystone_ip>:35357/v2.0/tenants/d20876f459f4455baddbd35db29eb526/users/86cffc370bca457fa886fe7fa8c4cbb1/roles | python -mjson.tool
{
    "roles": [
        {
            "id": "9fe2ff9ee4384b1894a90878d3e92bab",
            "name": "_member_"
        },
        {
            "id": "d2675d49819e44b28230253bba862d4d",
            "name": "monasca-agent"
        }
    ]
}
```
```
curl -s  -H "X-Auth-Token: ADMIN"  http://<keystone_ip>:35357/v2.0/tenants/d20876f459f4455baddbd35db29eb526/users/55a3f66641a94781b323296a8b6a01af/roles | python -mjson.tool
{
    "roles": [
        {
            "id": "96a32b94b380477fb4563f501f71c078",
            "name": "monasca-user"
        },
        {
            "id": "9fe2ff9ee4384b1894a90878d3e92bab",
            "name": "_member_"
        }
    ]
}
```
we get that their roles are members.
