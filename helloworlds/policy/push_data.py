from kafka import KafkaProducer
from kafka.errors import KafkaError
import json


with open('data.json') as json_data:
    data = json.load(json_data)



producer = KafkaProducer(bootstrap_servers=["kafka:9092"])

#send eca-supa sample
future = producer.send('demo1',json.dumps(data))