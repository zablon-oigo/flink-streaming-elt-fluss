CREATE CATALOG developer_catalog WITH (
    'type' = 'fluss',
    'bootstrap.servers' = 'coordinator-server:9123',
    'client.security.protocol' = 'SASL',
    'client.security.sasl.mechanism' = 'PLAIN',
    'client.security.sasl.username' = 'developer',
    'client.security.sasl.password' = 'developer-pass'
);