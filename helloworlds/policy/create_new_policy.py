from kafka import KafkaProducer
from kafka.errors import KafkaError
import json

#Load JSON file
with open('newpolicy.json') as json_data:
    jsonpolicy = json.load(json_data)


#Prepare connection to Kafka
producer = KafkaProducer(bootstrap_servers=["kafka:9092"])

#send eca-supa sample
future = producer.send('newpolicy',json.dumps(jsonpolicy))