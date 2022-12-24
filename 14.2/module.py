import hvac
import sys

# Kubernetes (from k8s pod)
client = hvac.Client(
    url='http://vault:8200'
)

client.auth.approle.login(
    role_id=sys.argv[1]
)

client.is_authenticated()

# Читаем секрет
secret = client.secrets.kv.v2.read_secret_version(
    path='module',
)

print(secret['data']['data'])
